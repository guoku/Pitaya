//
//  GroupVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "GroupVC.h"
#import "DiscoverSectionHeaderView.h"
#import "CategoryCell.h"
#import "CategoryVC.h"

@interface GroupVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation GroupVC

#pragma mark - Private Method

- (void)refresh
{
    [GKDataManager getAllCategoryFromNetwork:YES result:^(NSArray *categoryGroupArray, NSArray *fullCategoryGroupArray, NSArray *allCategoryArray) {
        for (NSDictionary *groupDict in fullCategoryGroupArray) {
            if ([self.groupDict[GroupIdKey] isEqualToNumber:groupDict[GroupIdKey]]) {
                NSMutableArray *categoryArray = [groupDict[CategoryArrayKey] mutableCopy];
                [categoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
                
                self.categoryArray[0] = [categoryArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.status > 0"]];
                self.categoryArray[1] = [categoryArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.status <= 0"]];
                break;
            }
        }
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.categoryArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSMutableArray *)self.categoryArray[section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    GKEntityCategory *category = self.categoryArray[indexPath.section][indexPath.row];
    cell.category = category;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        DiscoverSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscoverSectionHeaderView" forIndexPath:indexPath];
        headerView.titleLabel.text = (indexPath.section == 0) ? @"优选品类" : @"普通品类";
        
        reusableview = headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"DiscoverSectionFooterView" forIndexPath:indexPath];
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
#if EnableDataTracking
    [self saveStateWithEventName:@"CATEGORY"];
#endif
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top, left, bottom, right;
    if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
        // 竖屏
        left = 23.f;
    } else {
        // 横屏
        left = 48.f;
    }
    
    top = 20.f;
    bottom = 0.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.categoryArray.count - 1 == (NSUInteger)section) {
        return CGSizeMake(50.f, 20.f);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"品类组页";
    
    self.navigationItem.title = self.groupDict[GroupNameKey];
    
    self.categoryArray = [@[@[], @[]] mutableCopy];
    
    [GKDataManager getAllCategoryFromNetwork:NO result:^(NSArray *categoryGroupArray, NSArray *fullCategoryGroupArray, NSArray *allCategoryArray) {
        for (NSDictionary *groupDict in fullCategoryGroupArray) {
            if ([self.groupDict[GroupIdKey] isEqualToNumber:groupDict[GroupIdKey]]) {
                NSMutableArray *categoryArray = [groupDict[CategoryArrayKey] mutableCopy];
                if (categoryArray.count > 0) {
                    [categoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
                    self.categoryArray[0] = [categoryArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.status > 0"]];
                    self.categoryArray[1] = [categoryArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.status <= 0"]];
                    [self.collectionView reloadData];
                } else {
                    [self refresh];
                }
                break;
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    CategoryCell *cell = (CategoryCell *)sender;
    CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
    vc.category = cell.category;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collectionView reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"GROUP";
    kAppDelegate.trackNode.xid = [self.groupDict[GroupIdKey] stringValue];
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
