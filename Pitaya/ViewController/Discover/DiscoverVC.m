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
#import "GroupVC.h"
#import "CategoryVC.h"

@interface DiscoverVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *allCategoryArray;
@property (nonatomic, strong) NSMutableArray *filteredCategoryArray;
@property (nonatomic, strong) NSMutableArray *categoryGroupArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DiscoverVC

#pragma mark - Private Method

- (void)refresh
{
    [GKDataManager getAllCategoryFromNetwork:YES result:^(NSArray *categoryGroupArray, NSArray *fullCategoryGroupArray, NSArray *allCategoryArray) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.allCategoryArray = [allCategoryArray mutableCopy];
            self.categoryGroupArray = [categoryGroupArray mutableCopy];
            [self.categoryGroupArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"Status" ascending:NO]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.activityIndicatorView stopAnimating];
            });
        });
    }];
}

#pragma mark - Selector Method

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
    cell.category = category;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DiscoverSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscoverSectionHeaderView" forIndexPath:indexPath];
        
        headerView.groupDict = self.categoryGroupArray[indexPath.section];
        headerView.imageView.image = [UIImage imageNamed:@"icon_next"];
        headerView.tapButton.tag = indexPath.section;
        
        reusableview = headerView;
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[GroupVC class]]) {
        UIButton *button = (UIButton *)sender;
        GroupVC *vc = (GroupVC *)segue.destinationViewController;
        vc.groupDict = self.categoryGroupArray[button.tag];
    } else if ([segue.destinationViewController isKindOfClass:[CategoryVC class]]) {
        CategoryCell *cell = (CategoryCell *)sender;
        CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
        vc.category = cell.category;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
