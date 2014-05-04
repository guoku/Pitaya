//
//  UserVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "UserVC.h"
#import "SVPullToRefresh.h"
#import "EntityCollectionCell.h"
#import "NoteCollectionCell.h"
#import "UserSectionHeaderView.h"
#import "EntityDetailVC.h"
#import "CategoryVC.h"
#import "TagCollectionCell.h"
#import "TagVC.h"
#import "UserListVC.h"

@interface UserVC () <UICollectionViewDataSource, UICollectionViewDelegate, UserSectionHeaderViewDelegate, NoteCollectionCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet UIButton *rightButton;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSTimeInterval likeTimestamp;

@end

@implementation UserVC

#pragma mark - Private Method

- (void)refresh
{
    [self.activityIndicatorView startAnimating];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [GKDataManager getUserDetailWithUserId:self.user.userId success:nil failure:nil];
    
    NSInteger index = self.selectedIndex;
    switch (index) {
        case 0:
        {
            [GKDataManager getUserLikeEntityListWithUserId:self.user.userId timestamp:[[NSDate date] timeIntervalSince1970] count:kRequestSize success:^(NSTimeInterval timestamp, NSArray *entityArray) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
                
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:entityArray];
                weakSelf.likeTimestamp = timestamp;
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
            
        case 1:
        {
            [GKDataManager getUserNoteListWithUserId:self.user.userId timestamp:[[NSDate date] timeIntervalSince1970] count:kRequestSize success:^(NSArray *dataArray) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
                
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:dataArray];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
            
        case 2:
        {
            [GKDataManager getTagListWithUserId:self.user.userId offset:0 count:kRequestSize success:^(GKUser *user, NSArray *tagArray) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
                
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:tagArray];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
    }
}

- (void)loadMore
{
    __weak __typeof(&*self)weakSelf = self;
    
    NSInteger index = self.selectedIndex;
    switch (index) {
        case 0:
        {
            GKEntity *entity = ((NSMutableArray *)self.dataArray[index]).lastObject;
            NSTimeInterval likeTimestamp = entity ? self.likeTimestamp : [[NSDate date] timeIntervalSince1970];
            
            [GKDataManager getUserLikeEntityListWithUserId:self.user.userId timestamp:likeTimestamp count:kRequestSize success:^(NSTimeInterval timestamp, NSArray *entityArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                
                [weakSelf.dataArray[index] addObjectsFromArray:entityArray];
                weakSelf.likeTimestamp = timestamp;
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            }];
            
            break;
        }
            
        case 1:
        {
            GKNote *note = ((NSMutableArray *)self.dataArray[index]).lastObject[@"note"];
            NSTimeInterval timestamp = note ? note.createdTime : [[NSDate date] timeIntervalSince1970];
            
            [GKDataManager getUserNoteListWithUserId:self.user.userId timestamp:timestamp count:kRequestSize success:^(NSArray *dataArray) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
                
                [weakSelf.dataArray[index] addObjectsFromArray:dataArray];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.pullToRefreshView stopAnimating];
            }];
            
            break;
        }
            
        case 2:
        {
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            
            break;
        }
    }
}

- (void)refreshFollowButtonState
{
    switch (self.user.relation) {
        case GKUserRelationTypeNone:
        {
            self.rightButton.hidden = NO;
            self.rightButton.backgroundColor = UIColorFromRGB(0x427ec0);
            [self.rightButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [self.rightButton setTitle:@"关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeFollowing:
        {
            self.rightButton.hidden = NO;
            self.rightButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [self.rightButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
            [self.rightButton setTitle:@"已关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeFan:
        {
            self.rightButton.hidden = NO;
            self.rightButton.backgroundColor = UIColorFromRGB(0x427ec0);
            [self.rightButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [self.rightButton setTitle:@"关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeBoth:
        {
            self.rightButton.hidden = NO;
            self.rightButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [self.rightButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
            [self.rightButton setTitle:@"已关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeSelf:
        {
            self.rightButton.hidden = YES;
            self.rightButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [self.rightButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
            [self.rightButton setTitle:@"自己" forState:UIControlStateNormal];
            break;
        }
        default:
        {
            self.rightButton.hidden = YES;
            [self.rightButton setTitle:@"" forState:UIControlStateNormal];
            [self.rightButton setImage:nil forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark - Getter And Setter

- (void)setUser:(GKUser *)user
{
    if (self.user) {
        [self removeObserver];
    }
    _user = user;
    [self addObserver];
}

#pragma mark - Selector Method

- (IBAction)tapFollowButtom:(id)sender
{
    if (k_isLogin) {
        BOOL state;
        
        switch (self.user.relation) {
            case GKUserRelationTypeNone:
            {
                state = YES;
                break;
            }
                
            case GKUserRelationTypeFollowing:
            {
                state = NO;
                break;
            }
                
            case GKUserRelationTypeFan:
            {
                state = YES;
                break;
            }
                
            case GKUserRelationTypeBoth:
            {
                state = NO;
                break;
            }
                
            case GKUserRelationTypeSelf:
            {
                return;
            }
        }
        
        GKUserRelationType oldRelation = self.user.relation;
        
        [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [GKDataManager followUserId:self.user.userId state:state success:^(GKUserRelationType relation) {
            self.user.relation = relation;
            if (oldRelation%2 != relation%2) {
                if (relation%2 == 1) {
                    [Passport sharedInstance].user.followingCount += 1;
                    self.user.fanCount += 1;
                } else {
                    [Passport sharedInstance].user.followingCount -= 1;
                    self.user.fanCount -= 1;
                }
            }
            [BBProgressHUD dismiss];
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD dismiss];
        }];
    } else {
        [Passport loginWithSuccessBlock:nil];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSMutableArray *)self.dataArray[self.selectedIndex]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.selectedIndex) {
        case 0:
        {
            EntityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntityCollectionCell" forIndexPath:indexPath];
            GKEntity *entity = self.dataArray[self.selectedIndex][indexPath.row];
            cell.entity = entity;
            return cell;
        }
            
        case 1:
        {
            NoteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCollectionCell" forIndexPath:indexPath];
            cell.delegate = self;
            
            GKEntity *entity = self.dataArray[self.selectedIndex][indexPath.row][@"entity"];
            GKNote *note = self.dataArray[self.selectedIndex][indexPath.row][@"note"];
            cell.entity = entity;
            cell.note = note;
            return cell;
        }
            
        case 2:
        {
            TagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionCell" forIndexPath:indexPath];
            NSString *tagName = self.dataArray[self.selectedIndex][indexPath.row][@"tagName"];
            NSInteger entityCount = [self.dataArray[self.selectedIndex][indexPath.row][@"entityCount"] integerValue];
            cell.tagName = tagName;
            cell.entityCount = entityCount;
            return cell;
        }
            
        default:
        {
            UICollectionViewCell *cell;
            return cell;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UserSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserSectionHeaderView" forIndexPath:indexPath];
        headerView.delegate = self;
        headerView.user = self.user;
        reusableView = headerView;
    }
    
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top, left, bottom, right;
    if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
        // 竖屏
        if (self.selectedIndex == 0) {
            // 商品
            left = 23.f;
        } else if (self.selectedIndex == 1) {
            // 点评
            left = 20.f;
        } else {
            // 喜爱
            left = 20.f;
        }
    } else {
        // 横屏
        if (self.selectedIndex == 0) {
            // 商品
            left = 48.f;
        } else if (self.selectedIndex == 1) {
            // 点评
            left = 45.f;
        } else {
            // 喜爱
            left = 45.f;
        }
    }
    
    top = bottom = 16.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.selectedIndex == 0) {
        // 商品
        return 16.f;
    } else if (self.selectedIndex == 1) {
        // 点评
        return 0.f;
    } else {
        // 喜爱
        return 0.f;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.selectedIndex) {
        case 0:
        {
            // 商品
            return CGSizeMake(210.f, 250.f);
            break;
        }
            
        case 1:
        {
            // 点评
            GKNote *note = self.dataArray[1][indexPath.row][@"note"];
            return [NoteCollectionCell sizeForCellWithNote:note];
            break;
        }
            
        case 2:
        {
            // 喜爱
            return CGSizeMake(668.f, 50.f);
            break;
        }
            
        default:
        {
            return CGSizeZero;
            break;
        }
    }
}

#pragma mark - UserSectionHeaderViewDelegate

- (void)headerView:(UserSectionHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    self.selectedIndex = index;
    
    [self.activityIndicatorView stopAnimating];
    
    if (((NSMutableArray *)self.dataArray[index]).count == 0) {
        [self.collectionView triggerPullToRefresh];
    } else {
        [self.collectionView reloadData];
    }
}

- (void)headerView:(UserSectionHeaderView *)headerView didTapedFanButton:(UIButton *)fanButton
{
    UserListVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserListVC"];
    vc.user = self.user;
    vc.type = UserListTypeFans;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerView:(UserSectionHeaderView *)headerView didTapedFriendButton:(UIButton *)friendButton
{
    UserListVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserListVC"];
    vc.user = self.user;
    vc.type = UserListTypeFriends;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NoteCollectionCellDelegate

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectEntity:(GKEntity *)entity note:(GKNote *)note
{
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
    [self.dataArray addObject:[NSMutableArray array]];
    [self.dataArray addObject:[NSMutableArray array]];
    [self.dataArray addObject:[NSMutableArray array]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"用户页";
    
    self.rightButton.hidden = YES;
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
    
    if (((NSMutableArray *)self.dataArray[self.selectedIndex]).count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[EntityDetailVC class]]) {
        EntityCollectionCell *cell = (EntityCollectionCell *)sender;
        EntityDetailVC *vc = (EntityDetailVC *)segue.destinationViewController;
        vc.entity = cell.entity;
    } else if ([segue.destinationViewController isKindOfClass:[CategoryVC class]]) {
        UIButton *categoryButton = (UIButton *)sender;
        CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
        NSUInteger categoryId = categoryButton.tag;
        vc.category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId)}];
    } else if ([segue.destinationViewController isKindOfClass:[TagVC class]]) {
        TagCollectionCell *cell = (TagCollectionCell *)sender;
        TagVC *vc = (TagVC *)segue.destinationViewController;
        vc.tagName = cell.tagName;
        vc.user = self.user;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collectionView reloadData];
    });
}

#pragma mark - KVO

- (void)addObserver
{
    [self.user addObserver:self forKeyPath:@"relation" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.user removeObserver:self forKeyPath:@"relation"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"relation"]) {
        [self refreshFollowButtonState];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
