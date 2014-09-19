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
#import "EntityDetailVC.h"
#import "UserVC.h"
#import "TagVC.h"

@interface CategoryVC () <UICollectionViewDataSource, UICollectionViewDelegate, CategorySectionHeaderViewDelegate, NoteCollectionCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UIButton *navTitleButton;
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
            [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"like" reverse:NO offset:0 count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
                
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:[entityArray mutableCopy]];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
            
        case 1:
        {
            [GKDataManager getNoteListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:0 count:kRequestSize success:^(NSArray *dataArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
                
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:[dataArray mutableCopy]];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
            break;
        }
            
        case 2:
        {
            [GKDataManager getLikeEntityListWithCategoryId:self.category.categoryId userId:[Passport sharedInstance].user.userId sort:@"" reverse:YES offset:0 count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
                
                [weakSelf.dataArray[index] removeAllObjects];
                [weakSelf.dataArray[index] addObjectsFromArray:[entityArray mutableCopy]];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.activityIndicatorView stopAnimating];
            }];
            
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
            [GKDataManager getEntityListWithCategoryId:self.category.categoryId sort:@"like" reverse:NO offset:((NSMutableArray *)self.dataArray[index]).count count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                
                [weakSelf.dataArray[index] addObjectsFromArray:entityArray];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            }];
            
            break;
        }
            
        case 1:
        {
            [GKDataManager getNoteListWithCategoryId:self.category.categoryId sort:@"" reverse:YES offset:((NSMutableArray *)self.dataArray[index]).count count:kRequestSize success:^(NSArray *dataArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                
                [weakSelf.dataArray[index] addObjectsFromArray:[dataArray mutableCopy]];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            }];
            
            break;
        }
            
        case 2:
        {
            [GKDataManager getLikeEntityListWithCategoryId:self.category.categoryId userId:[Passport sharedInstance].user.userId sort:@"" reverse:YES offset:((NSMutableArray *)self.dataArray[index]).count count:kRequestSize success:^(NSArray *entityArray) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                
                [weakSelf.dataArray[index] addObjectsFromArray:[entityArray mutableCopy]];
                [weakSelf.collectionView reloadData];
            } failure:^(NSInteger stateCode) {
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            }];
            
            break;
        }
    }
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
            cell.delegate = self;
            
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top, left, bottom, right;
    if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
        // 竖屏
        if (self.selectedIndex == 0) {
            // 商品
            left = 23.f;
        } else if (self.selectedIndex == 1) {
            // 点评
            left = 20.f;
        } else {
            // 喜爱
            left = 23.f;
        }
    } else {
        // 横屏
        if (self.selectedIndex == 0) {
            // 商品
            left = 48.f;
        } else if (self.selectedIndex == 1) {
            // 点评
            left = 45.f;
        } else {
            // 喜爱
            left = 48.f;
        }
    }
    
    top = bottom = 16.f;
    right = left;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.selectedIndex == 0) {
        // 商品
        return 16.f;
    } else if (self.selectedIndex == 1) {
        // 点评
        return 0.f;
    } else {
        // 喜爱
        return 16.f;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.selectedIndex) {
        case 0:
        {
            // 商品
            return CGSizeMake(210.f, 250.f);
            break;
        }
        
        case 1:
        {
            // 点评
            GKNote *note = self.dataArray[1][indexPath.row][@"note"];
            return [NoteCollectionCell sizeForCellWithNote:note];
            break;
        }
            
        case 2:
        {
            // 喜爱
            return CGSizeMake(210.f, 250.f);
            break;
        }
            
        default:
        {
            return CGSizeZero;
            break;
        }
    }
}

#pragma mark - CategorySectionHeaderViewDelegate

- (void)headerView:(CategorySectionHeaderView *)headerView didSelectedIndex:(NSInteger)index
{
    [self.activityIndicatorView stopAnimating];
    [self.collectionView reloadData];
    
    self.selectedIndex = index;
    
    if (index == 2 && !k_isLogin) {
        __weak __typeof(&*self)weakSelf = self;
        NSUInteger categoryId = self.category.categoryId;
        [Passport loginWithSuccessBlock:^{
            [GKDataManager getCategoryStatByCategoryId:categoryId success:^(NSInteger likeCount, NSInteger noteCount, NSInteger entityCount) {
                [weakSelf refresh];
            } failure:nil];
        }];
    } else {
        if (((NSMutableArray *)self.dataArray[index]).count == 0) {
            [self refresh];
        }
    }
}

#pragma mark - NoteCollectionCellDelegate

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectEntity:(GKEntity *)entity note:(GKNote *)note
{
#if EnableDataTracking
    [self saveStateWithEventName:@"ENTITY"];
#endif
    
    EntityDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EntityDetailVC"];
    vc.entity = entity;
    vc.note = note;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectUser:(GKUser *)user
{
    UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectTag:(NSString *)tag fromUser:(GKUser *)user
{
    TagVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TagVC"];
    if (tag.length > 1) {
        vc.tagName = [tag substringFromIndex:1];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
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
    
    self.screenName = @"品类页";
    
    NSString *title = [self.category.categoryName componentsSeparatedByString:@"-"].firstObject;
    [self.navTitleButton setTitle:title forState:UIControlStateNormal];
    self.navTitleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.category.iconURL) {
        [self.navTitleButton sd_setImageWithURL:self.category.iconURL forState:UIControlStateNormal];
    } else {
        self.navTitleButton.titleEdgeInsets = UIEdgeInsetsZero;
        [self.navTitleButton setImage:nil forState:UIControlStateNormal];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[EntityDetailVC class]]) {
#if EnableDataTracking
        [self saveStateWithEventName:@"ENTITY"];
#endif
        
        EntityCollectionCell *cell = (EntityCollectionCell *)sender;
        EntityDetailVC *vc = (EntityDetailVC *)segue.destinationViewController;
        vc.entity = cell.entity;
    } else if ([segue.destinationViewController isKindOfClass:[CategoryVC class]]) {
#if EnableDataTracking
        [self saveStateWithEventName:@"CATEGORY"];
#endif
        
        UIButton *categoryButton = (UIButton *)sender;
        CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
        NSUInteger categoryId = categoryButton.tag;
        vc.category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId)}];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collectionView reloadData];
    });
}

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"CATEGORY";
    kAppDelegate.trackNode.tabIndex = self.selectedIndex;
    kAppDelegate.trackNode.xid = @(self.category.categoryId).stringValue;
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
