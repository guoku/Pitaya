//
//  EntityDetailVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "EntityDetailVC.h"
#import "NoteCell.h"
#import "RecommendEntityCell.h"
#import "CategoryVC.h"
#import "UserVC.h"
#import "NoteDetailVC.h"
#import "NotePostVC.h"
#import "WebVC.h"
#import "TagVC.h"
#import "WeiboPostVC.h"

@interface EntityDetailVC () <UITableViewDataSource, UITableViewDelegate, RecommendEntityCellDelegate, NoteCellDelegate>

@property (nonatomic, assign) BOOL hasLoadData;
@property (nonatomic, strong) NSMutableArray *noteArray;
@property (nonatomic, strong) NSMutableArray *likeUserArray;
@property (nonatomic, strong) NSMutableArray *recommendEntityArray;

@property (nonatomic, strong) IBOutlet UIButton *noteButton;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *imagePageControl;
@property (nonatomic, strong) IBOutlet UIView *likeUserView;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *priceButton;
@property (nonatomic, strong) IBOutlet UIButton *categoryButton;
@property (nonatomic, strong) IBOutlet UILabel *brandAndTitleLabel;

@end

@implementation EntityDetailVC

#pragma mark - Private Method

- (void)refreshHeaderView
{
    if (self.entity.brand.length > 0) {
        self.brandAndTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", self.entity.brand, self.entity.title];
    } else {
        self.brandAndTitleLabel.text = self.entity.title;
    }
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %d", self.entity.likeCount] forState:UIControlStateNormal];
    [self.priceButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xA1BFE0)] forState:UIControlStateDisabled];
    [self.priceButton setTitle:[NSString stringWithFormat:@"¥%.2f", self.entity.lowestPrice] forState:UIControlStateNormal];
    GKEntityCategory *category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(self.entity.categoryId)}];
    NSString *categoryName = [category.categoryName componentsSeparatedByString:@"-"].firstObject;
    [self.categoryButton setTitle:[NSString stringWithFormat:@"来自 「%@」", categoryName] forState:UIControlStateNormal];
    self.categoryButton.tag = category.categoryId;
}

- (void)refreshImageScrollView
{
    for (UIView *view in self.imageScrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.tag == 100) {
            [view removeFromSuperview];
        }
    }
    
    NSMutableArray *imageURLArray = [NSMutableArray array];
    if (self.entity.imageURL) {
        [imageURLArray addObject:self.entity.imageURL];
    }
    
    BOOL multiImageSupport = NO;
    if (self.entity.imageURLArray && multiImageSupport) {
        [imageURLArray addObjectsFromArray:self.entity.imageURLArray];
    }
    
    CGFloat scrollViewWidth = CGRectGetWidth(self.imageScrollView.bounds);
    CGFloat scrollViewHeight = CGRectGetHeight(self.imageScrollView.bounds);
    
    [imageURLArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSURL *imageURL = (NSURL *)obj;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth * idx, 0.f, scrollViewWidth, scrollViewHeight)];
        imageView.tag = 100;
        imageView.center = CGPointMake(scrollViewWidth * idx + scrollViewWidth/2,  scrollViewHeight/2);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:imageURL placeholderImage:imageView.image];
        [self.imageScrollView addSubview:imageView];
    }];
    
    self.imageScrollView.contentSize = CGSizeMake(scrollViewWidth * imageURLArray.count, scrollViewHeight);
    self.imagePageControl.currentPage = 0;
    self.imagePageControl.numberOfPages = imageURLArray.count;
}

- (void)refreshLikeUser
{
    for (UIView *subView in self.likeUserView.subviews) {
        [subView removeFromSuperview];
    }
    
    [self.likeUserArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat buttonLength = 35.f;
        
        CGRect frame;
        frame.origin.x = 20.f + (idx * (buttonLength + 15.f));
        frame.origin.y = 7.f;
        frame.size.width = buttonLength;
        frame.size.height = buttonLength;
        
        GKUser *user = obj;
        UIButton *avatarButton = [[UIButton alloc] initWithFrame:frame];
        avatarButton.backgroundColor = UIColorFromRGB(0xF6F6F6);
        avatarButton.layer.cornerRadius = buttonLength / 2;
        avatarButton.layer.masksToBounds = YES;
        avatarButton.tag = user.userId;
        [avatarButton sd_setImageWithURL:user.avatarURL forState:UIControlStateNormal];
        [avatarButton addTarget:self action:@selector(tapLikeUserButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeUserView addSubview:avatarButton];
    }];
}

- (void)shareToWeibo
{
    WeiboPostVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeiboPostVC"];
    vc.entity = self.entity;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Selector Method

- (void)tapNoteButton
{
    if (!k_isLogin) {
        [Passport loginWithSuccessBlock:^{
            [self tapNoteButton];
        }];
        return;
    }
    
    NotePostVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotePostVC"];
    vc.entity = self.entity;
    for (GKNote *note in self.noteArray) {
        if (note.creator.userId == [Passport sharedInstance].user.userId) {
            vc.note = note;
            break;
        }
    }
    __weak __typeof(&*self)weakSelf = self;
    vc.successBlock = ^(GKNote *note) {
        if (![weakSelf.noteArray containsObject:note]) {
            [weakSelf.noteArray insertObject:note atIndex:self.noteArray.count];
        }
        
        weakSelf.note = note;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapMoreButton
{
    __weak __typeof(&*self)weakSelf = self;
    if ([[Passport sharedInstance].weiboInstance isAuthValid]) {
        WeiboPostVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeiboPostVC"];
        vc.entity = weakSelf.entity;
        vc.noteArray = weakSelf.noteArray;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } else {
        [[Passport sharedInstance].weiboInstance logIn];
    }
}

- (IBAction)tapLikeButton:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    
    if (!k_isLogin) {
        [Passport loginWithSuccessBlock:^{
            [weakSelf tapLikeButton:self.likeButton];
        }];
        return;
    } else {
        UIButton *button = sender;
        
        [BBProgressHUD show];
        [GKDataManager likeEntityWithEntityId:self.entity.entityId isLike:!button.isSelected success:^(BOOL liked) {
            GKUser *user = [Passport sharedInstance].user;
            if (liked) {
                [BBProgressHUD showSuccessWithText:@"喜爱成功"];
                [weakSelf.likeUserArray insertObject:user atIndex:0];
            } else {
                [BBProgressHUD dismiss];
                [weakSelf.likeUserArray removeObject:user];
            }
            [weakSelf refreshLikeUser];
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showErrorWithText:@"喜爱失败"];
        }];
    }
}

- (IBAction)tapEntityImage:(id)sender
{
    if (self.priceButton.enabled) {
        [self tapPriceButton:nil];
    }
}

- (IBAction)tapPriceButton:(id)sender
{
    GKPurchase * purchase = self.entity.purchaseArray.firstObject;
    if (purchase) {
        WebVC *vc = [[WebVC alloc] initWithURL:purchase.buyLink];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)tapLikeUserButton:(UIButton *)button
{
    GKUser *user = [GKUser modelFromDictionary:@{@"userId":@(button.tag)}];
    UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RecommendEntityCellDelegate

- (void)recommendEntityCell:(RecommendEntityCell *)cell didSelectedEntity:(GKEntity *)entity
{
#if EnableDataTracking
    [self saveStateWithEventName:@"ENTITY"];
#endif
    
    EntityDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EntityDetailVC"];
    vc.entity = entity;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NoteCellDelegate

- (void)noteCell:(NoteCell *)cell didSelectUser:(GKUser *)user
{
    UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteCell:(NoteCell *)cell didSelectTag:(NSString *)tag fromUser:(GKUser *)user
{
    TagVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TagVC"];
    if (tag.length > 1) {
        vc.tagName = [tag substringFromIndex:1];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)noteCell:(NoteCell *)cell tapPokeButton:(UIButton *)pokeButton
{
    NSUInteger oldIndex = [self.noteArray indexOfObject:cell.note];
    [self.noteArray sortUsingDescriptors:@[
                                           [NSSortDescriptor sortDescriptorWithKey:@"marked" ascending:NO],
                                           [NSSortDescriptor sortDescriptorWithKey:@"pokeCount" ascending:NO],
                                           [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:YES]
                                           ]];
    NSUInteger newIndex = [self.noteArray indexOfObject:cell.note];
    [self.tableView beginUpdates];
    [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:oldIndex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0] ];
    [self.tableView endUpdates];
}

- (void)noteCell:(NoteCell *)cell tapCommentButton:(UIButton *)noteButton
{
    NoteDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoteDetailVC"];
    vc.note = cell.note;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.noteArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"NoteCell";
        NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        GKNote *note = self.noteArray[indexPath.row];
        cell.note = note;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"RecommendEntityCell";
        RecommendEntityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.entityArray = self.recommendEntityArray;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GKNote *note = self.noteArray[indexPath.row];
        return [NoteCell heightForCellWithNote:note];
    } else {
        return 510.f;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.imageScrollView) {
        // 获取当前页码
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        // 设置当前页码
        self.imagePageControl.currentPage = index;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"商品页";
    
    // 导航条按钮
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 30.f)];
    [moreButton setImage:[UIImage imageNamed:@"detail_icon_share"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(tapMoreButton) forControlEvents:UIControlEventTouchUpInside];
    
    _noteButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 30.f)];
    [self.noteButton setImage:[UIImage imageNamed:@"detail_icon_note"] forState:UIControlStateNormal];
    [self.noteButton addTarget:self action:@selector(tapNoteButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    UIBarButtonItem *noteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.noteButton];
    self.navigationItem.rightBarButtonItems = @[moreButtonItem, noteButtonItem];
    
    // headerView
    self.headerView.layer.borderColor = UIColorFromRGB(0xF6F6F6).CGColor;
    [self refreshHeaderView];
    
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.hasLoadData) {
        [self refreshImageScrollView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.hasLoadData) {
        [self.tableView reloadData];
    } else {
        __weak __typeof(&*self)weakSelf = self;
        [GKDataManager getEntityDetailWithEntityId:self.entity.entityId success:^(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray) {
            weakSelf.hasLoadData = YES;
            weakSelf.priceButton.enabled = YES;
            
            weakSelf.entity = entity;
            weakSelf.likeUserArray = [likeUserArray mutableCopy];
            weakSelf.noteArray = [NSMutableArray arrayWithArray:noteArray];
            
            // 根据设置，剔除掉未加精的点评
            if ([SettingManager sharedInstance].hidesNote) {
                NSMutableArray *discardedNoteArray = [NSMutableArray array];
                for (GKNote *note in weakSelf.noteArray) {
                    if (!(note.isMarked || note.creator.userId == [Passport sharedInstance].user.userId)) {
                        [discardedNoteArray addObject:note];
                    }
                }
                [weakSelf.noteArray removeObjectsInArray:discardedNoteArray];
            }
            
            // 排序
            [weakSelf.noteArray sortUsingDescriptors:@[
                                                   [NSSortDescriptor sortDescriptorWithKey:@"marked" ascending:NO],
                                                   [NSSortDescriptor sortDescriptorWithKey:@"pokeCount" ascending:NO],
                                                   [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:YES]]];
            
            [weakSelf refreshImageScrollView];
            [weakSelf refreshHeaderView];
            [weakSelf.tableView reloadData];
            [weakSelf refreshLikeUser];
        } failure:nil];
        
        [GKDataManager getRandomEntityListByCategoryId:self.entity.categoryId count:6 success:^(NSArray *entityArray) {
            weakSelf.recommendEntityArray = [entityArray mutableCopy];
            [weakSelf.tableView reloadData];
        } failure:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[CategoryVC class]]) {
#if EnableDataTracking
        [self saveStateWithEventName:@"CATEGORY"];
#endif
        
        UIButton *categoryButton = (UIButton *)sender;
        CategoryVC *vc = (CategoryVC *)segue.destinationViewController;
        NSUInteger categoryId = categoryButton.tag;
        vc.category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId)}];
    } else if ([segue.destinationViewController isKindOfClass:[NoteDetailVC class]]) {
        NoteCell *cell = (NoteCell *)sender;
        NoteDetailVC *vc = (NoteDetailVC *)segue.destinationViewController;
        vc.note = cell.note;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO

- (void)addObserver
{
    [self.entity addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.entity removeObserver:self forKeyPath:@"liked"];
    [self.entity removeObserver:self forKeyPath:@"likeCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"liked"]) {
        self.likeButton.selected = self.entity.isLiked;
    } else if ([keyPath isEqualToString:@"likeCount"]) {
        [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %d", self.entity.likeCount] forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"ENTITY";
    kAppDelegate.trackNode.xid = self.entity.entityId;
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
