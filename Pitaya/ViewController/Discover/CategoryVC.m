//
//  CategoryVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CategoryVC.h"
#import "SVPullToRefresh.h"
#import "EntityCollectionCell.h"
#import "NoteCollectionCell.h"
#import "CategorySectionHeaderView.h"

@interface CategoryVC () <UICollectionViewDataSource, UICollectionViewDelegate, CategorySectionHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation CategoryVC

#pragma mark - Private Method

- (void)refresh
{
    [self.activityIndicatorView startAnimating];
    
    __weak __typeof(&*self)weakSelf = self;
    
    NSInteger index = self.selectedIndex;
    switch (index) {
        case 0:
        {
            [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:0 count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:[entityArray mutableCopy]];
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
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:[dataArray mutableCopy]];
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
    
    NSInteger index = self.selectedIndex;
    switch (index) {
        case 0:
        {
            [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:((NSMutableArray *)self.dataArray[index]).count count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.dataArray[index] addObjectsFromArray:entityArray];
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

#pragma mark - Selector Method

- (IBAction)tapLikeButton:(id)sender
{
    NSLog(@"tapLikeButton");
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
            GKEntity *entity = self.dataArray[self.selectedIndex][indexPath.row][@"entity"];
            GKNote *note = self.dataArray[self.selectedIndex][indexPath.row][@"note"];
            cell.entity = entity;
            cell.note = note;
            return cell;
        }
            
        case 2:
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
        CategorySectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategorySectionHeaderView" forIndexPath:indexPath];
        headerView.delegate = self;
        [headerView setEntityCount:self.category.entityCount noteCount:self.category.noteCount likeCount:self.category.likeCount];
        
        reusableView = headerView;
    }
    
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - CategorySectionHeaderViewDelegate

- (void)headerView:(CategorySectionHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    [self.activityIndicatorView stopAnimating];
    [self.collectionView reloadData];
    
    self.selectedIndex = index;
    if (((NSMutableArray *)self.dataArray[index]).count == 0) {
        [self refresh];
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
    
    self.navigationItem.title = [self.category.categoryName componentsSeparatedByString:@"-"].firstObject;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (((NSMutableArray *)self.dataArray[self.selectedIndex]).count == 0) {
        [GKDataManager getCategoryStatByCategoryId:self.category.categoryId success:Nil failure:nil];
        [self refresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
