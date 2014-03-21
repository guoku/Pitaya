//
//  HomepageVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "HomepageVC.h"
#import "HotCell.h"
#import "SVPullToRefresh.h"
#import "EntityDetailVC.h"

@interface HomepageVC ()

@property (nonatomic, strong) NSMutableArray *entityArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation HomepageVC

#pragma mark - Private Method

- (void)refresh
{
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
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    
    cell.entity = self.entityArray[indexPath.row];
    
    return cell;
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
    
    top = bottom = 23.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
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
        HotCell *cell = (HotCell *)sender;
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

@end
