//
//  HomepageVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "HomepageVC.h"
#import "HomeSectionHeaderView.h"
#import "EntityCollectionCell.h"
#import "SVPullToRefresh.h"
#import "EntityDetailVC.h"
#import "CategoryVC.h"
#import "DiscoverVC.h"

@interface HomepageVC () <HomeSectionHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *hotCategoryArray;
@property (nonatomic, strong) NSMutableArray *entityArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation HomepageVC

#pragma mark - Private Method

- (void)refresh
{
    [GKDataManager getHomepageWithSuccess:^(NSArray *bannerArray, NSArray *hotCategoryArray) {
        self.bannerArray = [bannerArray mutableCopy];
        self.hotCategoryArray = [hotCategoryArray mutableCopy];
        [self.collectionView reloadData];
    } failure:nil];
    
    [GKDataManager getNewEntityListWithTimestamp:[[NSDate date] timeIntervalSince1970] cateId:0 count:kRequestSize success:^(NSArray *entityArray) {
        [self.collectionView.pullToRefreshView stopAnimating];
        
        self.entityArray = [entityArray mutableCopy];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    double timestamp = [[NSDate date] timeIntervalSince1970];
    GKEntity *entity = self.entityArray.lastObject;
    if (entity) {
        timestamp = entity.updatedTime;
    }
    
    [GKDataManager getNewEntityListWithTimestamp:timestamp cateId:0 count:kRequestSize success:^(NSArray *entityArray) {
        [self.collectionView.infiniteScrollingView stopAnimating];
        
        [self.entityArray addObjectsFromArray:entityArray];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark -HomeSectionHeaderViewDelegate

- (void)headerView:(HomeSectionHeaderView *)headerView didSelectUrl:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

- (void)headerView:(HomeSectionHeaderView *)headerView didSelectEntity:(GKEntity *)entity
{
    EntityDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EntityDetailVC"];
    vc.entity = entity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerView:(HomeSectionHeaderView *)headerView didSelectCategory:(GKEntityCategory *)category
{
    if (category) {
        CategoryVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CategoryVC"];
        vc.category = category;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        DiscoverVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DiscoverVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.entityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntityCollectionCell" forIndexPath:indexPath];
    
    cell.entity = self.entityArray[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HomeSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeSectionHeaderView" forIndexPath:indexPath];
        headerView.delegate = self;
        headerView.bannerArray = self.bannerArray;
        headerView.hotCategoryArray = self.hotCategoryArray;
        
        reusableView = headerView;
    }
    
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
#if EnableDataTracking
    [self saveStateWithEventName:@"ENTITY"];
#endif
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top, left, bottom, right;
    if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
        // 竖屏
        left = 23.f;
    } else {
        // 横屏
        left = 48.f;
    }
    top = 13.f;
    bottom = 23.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"首页";
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
    
    if (self.entityArray.count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[EntityDetailVC class]]) {
        EntityCollectionCell *cell = (EntityCollectionCell *)sender;
        EntityDetailVC *vc = (EntityDetailVC *)segue.destinationViewController;
        vc.entity = cell.entity;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collectionView reloadData];
    });
}

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"HOMEPAGE";
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
