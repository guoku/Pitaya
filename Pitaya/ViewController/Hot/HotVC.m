//
//  HotVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "HotVC.h"
#import "HotCell.h"
#import "SVPullToRefresh.h"

@interface HotVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation HotVC

#pragma mark - Private Method

- (void)refresh
{
    NSInteger segIndex = self.segmentedControl.selectedSegmentIndex;
    
    void (^successBlock)(NSArray *dataArray) = ^(NSArray *dataArray) {
        [self.collectionView.pullToRefreshView stopAnimating];
        
        [self.dataArray[segIndex] removeAllObjects];
        [self.dataArray[segIndex] addObjectsFromArray:dataArray];
        [self.collectionView reloadData];
    };
    
    void (^failureBlock)(NSInteger stateCode) = ^(NSInteger stateCode) {
        [self.collectionView.pullToRefreshView stopAnimating];
        
        if (stateCode == 400 && ((NSArray *)self.dataArray[self.segmentedControl.selectedSegmentIndex]).count == 0) {
            [BBProgressHUD showText:@"热门商品还没出锅\n等几分钟再来吧～"];
        }
    };
    NSString *type = segIndex ? @"weekly" : @"daily";
    [GKDataManager getHotEntityListWithType:type success:successBlock failure:failureBlock];
}

#pragma mark - Selector Method

- (IBAction)tapSegmentedControl:(id)sender
{
    [self.collectionView reloadData];
    
    NSInteger segIndex = self.segmentedControl.selectedSegmentIndex;
    NSArray *currentEntityArray = self.dataArray[segIndex];
    if (currentEntityArray.count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * entityArray = self.dataArray[self.segmentedControl.selectedSegmentIndex];
    return entityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCell" forIndexPath:indexPath];
    
    cell.entity = self.dataArray[self.segmentedControl.selectedSegmentIndex][indexPath.row];
    
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
        left = 45.f;
    }
    
    top = bottom = 25.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataArray = @[@[].mutableCopy, @[].mutableCopy].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!iOS7) {
        [self.segmentedControl setupFlat];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self tapSegmentedControl:nil];
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
