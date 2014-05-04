//
//  SearchResultVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-28.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SearchResultVC.h"
#import "SVPullToRefresh.h"
#import "EntityCollectionCell.h"
#import "SearchResultSectionHeaderView.h"
#import "EntityDetailVC.h"
#import "UserVC.h"
#import "TagVC.h"

@interface SearchResultVC () <UICollectionViewDataSource, UICollectionViewDelegate, SearchResultSectionHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger entityCount;
@property (nonatomic, assign) NSInteger likeCount;

@end

@implementation SearchResultVC

#pragma mark - Private Method

- (void)refresh
{
    [self.activityIndicatorView startAnimating];
    
    NSString *type = self.selectedIndex ? @"like" : @"all";
    __weak __typeof(&*self)weakSelf = self;
    [GKDataManager searchEntityWithString:self.keyword type:type offset:0 count:kRequestSize success:^(NSDictionary *stateDict, NSArray *entityArray) {
        weakSelf.entityCount = [stateDict[@"all_count"] integerValue];
        weakSelf.likeCount = [stateDict[@"like_count"] integerValue];
        
        [weakSelf.dataArray[weakSelf.selectedIndex] removeAllObjects];
        [weakSelf.dataArray[weakSelf.selectedIndex] addObjectsFromArray:entityArray];
        [weakSelf.collectionView reloadData];
        [weakSelf.activityIndicatorView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [weakSelf.activityIndicatorView stopAnimating];
    }];
}

- (void)loadMore
{
    NSString *type = self.selectedIndex ? @"like" : @"all";
    __weak __typeof(&*self)weakSelf = self;
    [GKDataManager searchEntityWithString:self.keyword type:type offset:((NSMutableArray *)weakSelf.dataArray[weakSelf.selectedIndex]).count count:kRequestSize success:^(NSDictionary *stateDict, NSArray *entityArray) {
        [weakSelf.dataArray[weakSelf.selectedIndex] addObjectsFromArray:entityArray];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    }];
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
            EntityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntityCollectionCell" forIndexPath:indexPath];
            GKEntity *entity = self.dataArray[self.selectedIndex][indexPath.row];
            cell.entity = entity;
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
        SearchResultSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchResultSectionHeaderView" forIndexPath:indexPath];
        headerView.delegate = self;
        [headerView setEntityCount:self.entityCount likeCount:self.likeCount];
        
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
        left = 23.f;
    } else {
        // 横屏
        left = 48.f;
    }
    
    top = bottom = 16.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(210.f, 250.f);
}

#pragma mark - SearchResultSectionHeaderViewDelegate

- (void)headerView:(SearchResultSectionHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    [self.activityIndicatorView stopAnimating];
    [self.collectionView reloadData];
    
    self.selectedIndex = index;
    
    if (index == 1 && !k_isLogin) {
        __weak __typeof(&*self)weakSelf = self;
        [Passport loginWithSuccessBlock:^{
            [weakSelf refresh];
        }];
    } else {
        if (((NSMutableArray *)self.dataArray[index]).count == 0) {
            [self refresh];
        }
    }
}

#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    _dataArray = [NSMutableArray array];
    [self.dataArray addObject:[NSMutableArray array]];
    [self.dataArray addObject:[NSMutableArray array]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"搜索结果页";
    
    self.navigationItem.title = self.keyword;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (((NSMutableArray *)self.dataArray[self.selectedIndex]).count == 0) {
        [self refresh];
    }
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

@end
