//
//  DiscoverVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "DiscoverVC.h"
#import "DiscoverSectionHeaderView.h"
#import "CategoryCell.h"

@interface DiscoverVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *allCategoryArray;
@property (nonatomic, strong) NSMutableArray *filteredCategoryArray;
@property (nonatomic, strong) NSMutableArray *categoryGroupArray;

@end

@implementation DiscoverVC

#pragma mark - Private Method

- (void)refresh
{
    [GKDataManager getAllCategoryFromNetwork:YES result:^(NSArray *categoryGroupArray, NSArray *fullCategoryGroupArray, NSArray *allCategoryArray) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.categoryGroupArray = [NSMutableArray arrayWithArray:categoryGroupArray];
            [self.categoryGroupArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"Status" ascending:NO]]];
            self.allCategoryArray = [allCategoryArray mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.activityIndicatorView stopAnimating];
            });
        });
    }];
}

#pragma mark - Selector Method

- (void)tapSectionHeaderView
{
    BaseViewController *vc = [[BaseViewController alloc] init];
    vc.view.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.categoryGroupArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *categoryArray = self.categoryGroupArray[section][CategoryArrayKey];
    return categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    GKEntityCategory *category = self.categoryGroupArray[indexPath.section][CategoryArrayKey][indexPath.row];
    [cell.imageView setImageWithURL:category.iconURL];
    cell.titleLabel.text = [category.categoryName componentsSeparatedByString:@"-"].firstObject;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DiscoverSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscoverSectionHeaderView" forIndexPath:indexPath];
        headerView.imageView.backgroundColor = [UIColor redColor];
        headerView.titleLabel.text = self.categoryGroupArray[indexPath.section][GroupNameKey];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionHeaderView)];
        [headerView addGestureRecognizer:tap];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *vc = [[BaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
