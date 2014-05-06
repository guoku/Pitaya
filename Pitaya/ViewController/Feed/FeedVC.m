//
//  FeedVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "FeedVC.h"
#import "SVPullToRefresh.h"
#import "NoteCollectionCell.h"
#import "EntityDetailVC.h"
#import "CategoryVC.h"
#import "UserVC.h"
#import "TagVC.h"

@interface FeedVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NoteCollectionCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation FeedVC

#pragma mark - Private Method

- (void)refresh
{
    __weak __typeof(&*self)weakSelf = self;
    
    if (!k_isLogin) {
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
        [Passport loginWithSuccessBlock:^{
            [weakSelf refresh];
        }];
        return;
    }
    
    [GKDataManager getFriendFeedWithTimestamp:[[NSDate date] timeIntervalSince1970] type:@"entity" success:^(NSArray *dataArray) {
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
        
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:dataArray];
        [weakSelf.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    __weak __typeof(&*self)weakSelf = self;
    
    if (!k_isLogin) {
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        [Passport loginWithSuccessBlock:^{
            [weakSelf loadMore];
        }];
        return;
    }
    
    GKNote *note = self.dataArray.lastObject[@"object"][@"note"];
    [GKDataManager getFriendFeedWithTimestamp:note.updatedTime type:@"entity" success:^(NSArray *dataArray) {
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
        [weakSelf.dataArray addObjectsFromArray:dataArray];
        [weakSelf.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didLogin
{
    [self.collectionView triggerPullToRefresh];
}

- (void)didLogout
{
    [self.dataArray removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    GKEntity *entity = self.dataArray[indexPath.row][@"object"][@"entity"];
    GKNote *note = self.dataArray[indexPath.row][@"object"][@"note"];
    cell.entity = entity;
    cell.note = note;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top, left, bottom, right;
    if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
        left = 20.f;
    } else {
        left = 45.f;
    }
    
    top = bottom = 0.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKNote *note = self.dataArray[indexPath.row][@"object"][@"note"];
    
    return [NoteCollectionCell sizeForCellWithNote:note];
}

#pragma mark - NoteCollectionCellDelegate

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectEntity:(GKEntity *)entity note:(GKNote *)note
{
#if EnableDataTracking
    [self saveStateWithEventName:@"ENTITY"];
#endif
    
    EntityDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EntityDetailVC"];
    vc.entity = entity;
    vc.note = note;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectUser:(GKUser *)user
{
    UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectTag:(NSString *)tag fromUser:(GKUser *)user
{
    TagVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TagVC"];
    if (tag.length > 1) {
        vc.tagName = [tag substringFromIndex:1];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    _dataArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"动态页";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:GKUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:GKUserDidLogoutNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (k_isLogin) {
        if (self.dataArray.count == 0) {
            [self.collectionView triggerPullToRefresh];
        }
    } else {
        [Passport loginWithSuccessBlock:^{
            [self.collectionView triggerPullToRefresh];
        }];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[CategoryVC class]]) {
        UIButton *categoryButton = (UIButton *)sender;
        CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
        NSUInteger categoryId = categoryButton.tag;
        vc.category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId)}];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLogoutNotification object:nil];
}

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"FEED";
    kAppDelegate.trackNode.tabIndex = 0;
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
