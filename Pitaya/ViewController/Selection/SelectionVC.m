//
//  SelectionVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SelectionVC.h"
#import "SVPullToRefresh.h"
#import "SelectionCell.h"

@interface SelectionVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectionArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation SelectionVC

#pragma mark - Private Method

- (void)refresh
{
    __weak __typeof(&*self)weakSelf = self;
    
    [GKDataManager getSelectionListWithTimestamp:[[NSDate date] timeIntervalSince1970] cateId:0 count:kRequestSize success:^(NSArray *dataArray) {
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
        weakSelf.collectionView.showsInfiniteScrolling = !(dataArray.count < kRequestSize);
        
        [weakSelf.selectionArray removeAllObjects];
        [weakSelf.selectionArray addObjectsFromArray:dataArray];
        [weakSelf.collectionView reloadData];
        
        [GKDataManager sharedInstance].unreadSelectionCount = 0;
    } failure:^(NSInteger stateCode) {
        [weakSelf.collectionView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    NSTimeInterval timestamp = (NSTimeInterval)[self.selectionArray.lastObject[@"time"] doubleValue];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [GKDataManager getSelectionListWithTimestamp:timestamp cateId:0 count:kRequestSize success:^(NSArray *dataArray) {
        [weakSelf.selectionArray addObjectsFromArray:dataArray];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        
        if (dataArray.count < kRequestSize) {
            weakSelf.collectionView.showsInfiniteScrolling = NO;
        } else {
            weakSelf.collectionView.showsInfiniteScrolling = YES;
        }
    } failure:^(NSInteger stateCode) {
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - Selector Method

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectionCell" forIndexPath:indexPath];
    
    cell.note = self.selectionArray[indexPath.row][@"content"][@"note"];
    cell.entity = self.selectionArray[indexPath.row][@"content"][@"entity"];
    NSTimeInterval timestamp = [self.selectionArray[indexPath.row][@"time"] doubleValue];
    cell.date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _selectionArray = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    if (self.selectionArray.count == 0) {
        [self.collectionView triggerPullToRefresh];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    [super prepareForSegue:segue sender:sender];
//    
//    if ([segue.destinationViewController isKindOfClass:[GroupVC class]]) {
//        UIButton *button = (UIButton *)sender;
//        GroupVC *vc = (GroupVC *)segue.destinationViewController;
//        vc.groupDict = self.categoryGroupArray[button.tag];
//    } else if ([segue.destinationViewController isKindOfClass:[CategoryVC class]]) {
//        CategoryCell *cell = (CategoryCell *)sender;
//        CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
//        vc.category = cell.category;
//    }
//}

@end
