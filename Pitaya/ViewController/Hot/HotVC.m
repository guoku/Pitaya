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
        [self.dataArray[segIndex] removeAllObjects];
        [self.dataArray[segIndex] addObjectsFromArray:dataArray];
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
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
    } else {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
