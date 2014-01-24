//
//  GroupVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "GroupVC.h"
#import "CategoryCell.h"
#import "DiscoverSectionHeaderView.h"

@interface GroupVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation GroupVC

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
//    GKEntityCategory *category = self.categoryGroupArray[indexPath.section][CategoryArrayKey][indexPath.row];
    cell.imageView.backgroundColor = [UIColor blueColor];
    cell.titleLabel.text = @"123";
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DiscoverSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscoverSectionHeaderView" forIndexPath:indexPath];
        headerView.titleLabel.text = (indexPath.section == 0) ? @"优选品类" : @"普通品类";
        
        reusableview = headerView;
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.groupDict[GroupNameKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
