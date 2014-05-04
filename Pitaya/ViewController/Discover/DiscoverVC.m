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
#import "PinyinTools.h"
#import "SearchResultVC.h"

@interface DiscoverVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *allCategoryArray;
@property (nonatomic, strong) NSMutableArray *filteredCategoryArray;
@property (nonatomic, strong) NSMutableArray *categoryGroupArray;

@property (nonatomic, assign) BOOL isSearching;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UITextField *searchTextField;
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

- (void)searchCategoryByKeyword:(NSString *)keyword
{
    [self.filteredCategoryArray removeAllObjects];
    
    for (GKEntityCategory *category in self.allCategoryArray) {
        if ([PinyinTools ifNameString:category.categoryName SearchString:keyword]) {
            [self.filteredCategoryArray addObject:category];
        }
    }
    
    [self.filteredCategoryArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO]]];
    [self.collectionView reloadData];
}

#pragma mark - Selector Method

- (IBAction)editingChanged:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    if (textField.text.length > 0) {
        self.isSearching = YES;
        [self searchCategoryByKeyword:textField.text];
    } else {
        self.isSearching = NO;
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.isSearching) {
        return 1;
    } else {
        return self.categoryGroupArray.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return self.filteredCategoryArray.count;
    } else {
        NSArray *categoryArray = self.categoryGroupArray[section][CategoryArrayKey];
        return categoryArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    GKEntityCategory *category;
    if (self.isSearching) {
        category = self.filteredCategoryArray[indexPath.row];
    } else {
        category = self.categoryGroupArray[indexPath.section][CategoryArrayKey][indexPath.row];
    }
    cell.category = category;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (self.isSearching) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultSectionHeaderView" forIndexPath:indexPath];
            UILabel *label = (UILabel *)[reusableview viewWithTag:200];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 20.f, 200.f, 20.f)];
                label.font = [UIFont appFontWithSize:16.f bold:YES];
                label.textAlignment = NSTextAlignmentLeft;
                label.textColor = UIColorFromRGB(0x666666);
                label.tag = 200;
                label.text = @"搜索结果：";
                [reusableview addSubview:label];
            }
            
            if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
                // 竖屏
                label.deFrameLeft = 23.f;
            } else {
                // 横屏
                label.deFrameLeft = 48.f;
            }
            
        } else {
            DiscoverSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscoverSectionHeaderView" forIndexPath:indexPath];
            
            headerView.groupDict = self.categoryGroupArray[indexPath.section];
            headerView.imageView.image = [UIImage imageNamed:@"icon_next"];
            headerView.tapButton.tag = indexPath.section;
            
            reusableview = headerView;
        }
    }
    
    return reusableview;
}

#pragma mark - UICollectionViewDelegate

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.isSearching) {
        return CGSizeZero;
    } else {
        return CGSizeMake(50.f, 40.f);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.categoryGroupArray.count - 1 == (NSUInteger)section || self.isSearching) {
        return CGSizeMake(50.f, 20.f);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        SearchResultVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchResultVC"];
        vc.keyword = textField.text;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"发现页";
    
    self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_icon_search"]];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.isSearching = NO;
    _filteredCategoryArray = [NSMutableArray array];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultSectionHeaderView"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.searchTextField.text = @"";
    [self editingChanged:nil];
    
    if (self.categoryGroupArray.count == 0 && self.allCategoryArray.count == 0) {
        __weak __typeof(&*self)weakSelf = self;
        [GKDataManager getAllCategoryFromNetwork:NO result:^(NSArray *categoryGroupArray, NSArray *fullCategoryGroupArray, NSArray *allCategoryArray) {
            weakSelf.categoryGroupArray = [categoryGroupArray mutableCopy];
            [weakSelf.categoryGroupArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"Status" ascending:NO]]];
            weakSelf.allCategoryArray = [allCategoryArray mutableCopy];
            if (weakSelf.categoryGroupArray.count == 0 && weakSelf.allCategoryArray.count == 0) {
                [weakSelf refresh];
            } else {
                [weakSelf.activityIndicatorView stopAnimating];
                [weakSelf.collectionView reloadData];
            }
        }];
    }
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

@end
