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

@interface CategoryVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *entityArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation CategoryVC

#pragma mark - Private Method

- (void)refresh
{
    [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:0 count:20 success:^(NSArray *entityArray) {
        self.entityArray  = [entityArray mutableCopy];
        [self.collectionView reloadData];
        [self.collectionView.infiniteScrollingView stopAnimating];
    } failure:^(NSInteger stateCode) {
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadMore
{
    
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
    
    GKEntity *entity = self.entityArray[indexPath.row];
    cell.entity = entity;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategorySectionHeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.category.categoryName componentsSeparatedByString:@"-"].firstObject;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
