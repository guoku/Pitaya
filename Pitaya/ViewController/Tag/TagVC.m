//
//  TagVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-16.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "TagVC.h"
#import "TagCell.h"
#import "SVPullToRefresh.h"
#import "EntityDetailVC.h"

@interface TagVC ()

@property (nonatomic, strong) NSMutableArray *entityArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation TagVC

#pragma mark - Private Method

- (void)refresh
{
    [GKDataManager getEntityListWithUserId:self.user.userId tag:self.tagName offset:0 count:kRequestSize success:^(GKUser *user, NSArray *entityArray) {
        [self.collectionView.pullToRefreshView stopAnimating];
        
        self.entityArray = [entityArray mutableCopy];
        [self.collectionView reloadData];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
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
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    
    cell.entity = self.entityArray[indexPath.row];
    
    return cell;
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
    
    top = bottom = 23.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"标签页";
    
    self.navigationItem.title = [NSString stringWithFormat:@"#%@", self.tagName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    if (self.entityArray.count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[EntityDetailVC class]]) {
        TagCell *cell = (TagCell *)sender;
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

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"TAG";
    kAppDelegate.trackNode.xid = self.tagName;
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
