//
//  MasterViewController.m
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-6.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterTableViewCell.h"

static NSString * const CellReuseIdentifier = @"MasterTableViewCell";

@interface MasterViewController () <UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MasterViewController

#pragma mark - Selector Method

- (IBAction)tapAvatarButton:(id)sender
{
    if (k_isLogin) {
        if (_delegate && [_delegate respondsToSelector:@selector(masterViewController:didSelectRowAtIndexPath:)]) {
            [self.delegate masterViewController:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.titleArray.count inSection:0]];
        }
    } else {
        [Passport loginWithSuccessBlock:^{
            [self addObserver];
            [self.headerView setNeedsLayout];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(masterViewController:didSelectRowAtIndexPath:)]) {
        [_delegate masterViewController:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        if (k_isLogin) {
            [self addObserver];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleArray = @[@"首页",
                        @"精选",
                        @"热门",
                        @"发现",
                        @"动态",
                        @"消息",
                        @"设置"];
    
    CGRect frame = self.headerView.frame;
    frame.size.height = 60.f;
    if (iOS7) {
        frame.size.height += kStatusBarHeight;
    }
    self.headerView.frame = frame;
    
    if (k_isLogin) {
        [self.headerView.avatarButton setImageWithURL:[Passport sharedInstance].user.avatarURL_s forState:UIControlStateNormal];
        self.headerView.nicknameLabel.text = [Passport sharedInstance].user.nickname;
    } else {
        self.headerView.avatarButton.backgroundColor = [UIColor blueColor];
        self.headerView.nicknameLabel.text = @"未登录";
    }
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO

- (void)addObserver
{
    [[Passport sharedInstance].user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[Passport sharedInstance].user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    if ([Passport sharedInstance].user.observationInfo) {
        [[Passport sharedInstance].user removeObserver:self forKeyPath:@"avatarURL"];
        [[Passport sharedInstance].user removeObserver:self forKeyPath:@"nickname"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"avatarURL"]) {
        GKUser *user = (GKUser *)object;
        [self.headerView.avatarButton setBackgroundImageWithURL:user.avatarURL forState:UIControlStateNormal];
    } else if ([keyPath isEqualToString:@"nickname"]) {
        GKUser *user = (GKUser *)object;
        self.headerView.nicknameLabel.text = user.nickname;
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
