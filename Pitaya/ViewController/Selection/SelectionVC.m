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

@interface SelectionVC () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectionArray;
@property (nonatomic, assign) NSInteger currentCategoryIndex;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIButton *categoryButton;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UITableView *popoverTableView;
@property (nonatomic, strong) NSArray *categoryTitleArray;

@end

@implementation SelectionVC

#pragma mark - Private Method

- (void)refresh
{
    __weak __typeof(&*self)weakSelf = self;
    
    [GKDataManager getSelectionListWithTimestamp:[[NSDate date] timeIntervalSince1970] cateId:self.currentCategoryIndex count:kRequestSize success:^(NSArray *dataArray) {
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
    
    [GKDataManager getSelectionListWithTimestamp:timestamp cateId:self.currentCategoryIndex count:kRequestSize success:^(NSArray *dataArray) {
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

- (IBAction)tapCategoryButton:(id)sender
{
    UIViewController *contentVC = [[UIViewController alloc] init];
    [contentVC.view addSubview:self.popoverTableView];
    _popover = [[UIPopoverController alloc] initWithContentViewController:contentVC];
    self.popover.popoverContentSize = self.popoverTableView.frame.size;
    [self.popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopoverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == self.currentCategoryIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = self.categoryTitleArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentCategoryIndex inSection:0]].accessoryType = UITableViewCellAccessoryNone;
    self.currentCategoryIndex = indexPath.row;
    [tableView reloadData];
    
    [self.categoryButton setTitle:self.categoryTitleArray[self.currentCategoryIndex] forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collectionView triggerPullToRefresh];
    });
}

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _selectionArray = @[].mutableCopy;
        _categoryTitleArray = @[@"全部", @"女装", @"男装", @"孩童", @"配饰", @"美容", @"科技", @"居家", @"户外", @"文化", @"美食", @"玩乐"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _popoverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 600.f) style:UITableViewStylePlain];
    self.popoverTableView.dataSource = self;
    self.popoverTableView.delegate = self;
    self.popoverTableView.scrollEnabled = NO;
    self.currentCategoryIndex = 0;
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
