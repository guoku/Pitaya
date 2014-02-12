//
//  CategoryVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CategoryVC.h"
#import "SVPullToRefresh.h"
#import "AKSegmentedControl.h"
#import "EntityCollectionCell.h"
#import "NoteCollectionCell.h"

@interface CategoryVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) AKSegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CategoryVC

#pragma mark - Private Method

- (void)refresh
{
    [self.activityIndicatorView startAnimating];
    
    __weak __typeof(&*self)weakSelf = self;
    
    switch (self.segmentedControl.selectedIndexes.firstIndex) {
        case 0:
        {
            [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:0 count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.dataArray[weakSelf.segmentedControl.selectedIndexes.firstIndex] removeAllObjects];
                [weakSelf.dataArray[weakSelf.segmentedControl.selectedIndexes.firstIndex] addObjectsFromArray:[entityArray mutableCopy]];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
            
        case 1:
        {
            [GKDataManager getNoteListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:0 count:kRequestSize success:^(NSArray *dataArray) {
                [weakSelf.dataArray[weakSelf.segmentedControl.selectedIndexes.firstIndex] removeAllObjects];
                [weakSelf.dataArray[weakSelf.segmentedControl.selectedIndexes.firstIndex] addObjectsFromArray:[dataArray mutableCopy]];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
            
        case 2:
        {
            break;
        }
    }
}

- (void)loadMore
{
    __weak __typeof(&*self)weakSelf = self;
    
    switch (self.segmentedControl.selectedIndexes.firstIndex) {
        case 0:
        {
            [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:((NSMutableArray *)self.dataArray[self.segmentedControl.selectedIndexes.firstIndex]).count count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.dataArray[weakSelf.segmentedControl.selectedIndexes.firstIndex] addObjectsFromArray:entityArray];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            }];
            
            break;
        }
            
        case 1:
        {
            break;
        }
            
        case 2:
        {
            break;
        }
    }
}

- (void)setupSegmentedControl
{
    _segmentedControl = [[AKSegmentedControl alloc] init];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.segmentedControlMode = AKSegmentedControlModeSticky;
    [self.segmentedControl addTarget:self action:@selector(tapSegmentedControl) forControlEvents:UIControlEventValueChanged];
    
    UIFont *titleFont = [UIFont appFontWithSize:14.f];
    UIColor *titleColor = UIColorFromRGB(0x427ec0);
    
    UIButton *segButton0 = [[UIButton alloc] init];
    UIButton *segButton1 = [[UIButton alloc] init];
    UIButton *segButton2 = [[UIButton alloc] init];
    
    segButton0.titleLabel.font = titleFont;
    segButton1.titleLabel.font = titleFont;
    segButton2.titleLabel.font = titleFont;
    
    segButton0.backgroundColor =UIColorFromRGB(0xcde3fb);
    segButton1.backgroundColor =UIColorFromRGB(0x659ad5);
    segButton2.backgroundColor =UIColorFromRGB(0xe4f0fc);
    
    [segButton0 setTitleColor:titleColor forState:UIControlStateNormal];
    [segButton0 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [segButton0 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [segButton0 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [segButton0 setTitle:@"点评" forState:UIControlStateNormal];
    
    [segButton1 setTitleColor:titleColor forState:UIControlStateNormal];
    [segButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [segButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [segButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [segButton1 setTitle:@"商品" forState:UIControlStateNormal];
    
    [segButton2 setTitleColor:titleColor forState:UIControlStateNormal];
    [segButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [segButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [segButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [segButton2 setTitle:@"喜爱" forState:UIControlStateNormal];
    
    self.segmentedControl.buttonsArray = @[segButton1, segButton0, segButton2];
    [self.segmentedControl setSelectedIndex:0];
}

#pragma mark - Selector Method

- (IBAction)tapLikeButton:(id)sender
{
    NSLog(@"tapLikeButton");
}

- (void)tapSegmentedControl
{
    [self.activityIndicatorView stopAnimating];
    
    NSUInteger index = self.segmentedControl.selectedIndexes.lastIndex;
    
    if (index == 0) {
        ((UIButton *)self.segmentedControl.buttonsArray[1]).backgroundColor = UIColorFromRGB(0xcde3fb);
        ((UIButton *)self.segmentedControl.buttonsArray[2]).backgroundColor = UIColorFromRGB(0xe4f0fc);
    } else {
        ((UIButton *)self.segmentedControl.buttonsArray[0]).backgroundColor = UIColorFromRGB(0xcde3fb);
        ((UIButton *)self.segmentedControl.buttonsArray[1]).backgroundColor = UIColorFromRGB(0xe4f0fc);
        ((UIButton *)self.segmentedControl.buttonsArray[2]).backgroundColor = UIColorFromRGB(0xe4f0fc);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        ((UIButton *)self.segmentedControl.buttonsArray[index]).backgroundColor = UIColorFromRGB(0x659ad5);
    }];
    
    [self.collectionView reloadData];
    
    if (((NSMutableArray *)self.dataArray[index]).count == 0) {
        [self refresh];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSMutableArray *)self.dataArray[self.segmentedControl.selectedIndexes.firstIndex]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentedControl.selectedIndexes.lastIndex) {
        case 0:
        {
            EntityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntityCollectionCell" forIndexPath:indexPath];
            GKEntity *entity = self.dataArray[self.segmentedControl.selectedIndexes.firstIndex][indexPath.row];
            cell.entity = entity;
            return cell;
        }
            
        case 1:
        {
            NoteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCollectionCell" forIndexPath:indexPath];
            GKEntity *entity = self.dataArray[self.segmentedControl.selectedIndexes.firstIndex][indexPath.row][@"entity"];
            GKNote *note = self.dataArray[self.segmentedControl.selectedIndexes.firstIndex][indexPath.row][@"note"];
            cell.entity = entity;
            cell.note = note;
            return cell;
        }
            
        case 2:
        {
            EntityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntityCollectionCell" forIndexPath:indexPath];
            GKEntity *entity = self.dataArray[self.segmentedControl.selectedIndexes.firstIndex][indexPath.row];
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
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategorySectionHeaderView" forIndexPath:indexPath];
        self.segmentedControl.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
        [headerView addSubview:self.segmentedControl];
        
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0.f];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeRight multiplier:1 constant:0.f];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeTop multiplier:1 constant:0.f];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0.f];
        [headerView addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
        
        reusableView = headerView;
    }
    
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    
    _dataArray = [NSMutableArray array];
    [self.dataArray addObject:[NSMutableArray array]];
    [self.dataArray addObject:[NSMutableArray array]];
    [self.dataArray addObject:[NSMutableArray array]];
    
    [self setupSegmentedControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.category.categoryName componentsSeparatedByString:@"-"].firstObject;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (((NSMutableArray *)self.dataArray[self.segmentedControl.selectedIndexes.firstIndex]).count == 0) {
        [self refresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
