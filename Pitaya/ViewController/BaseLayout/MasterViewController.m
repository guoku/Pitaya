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
            [self.headerView setNeedsLayout];
        }];
    }
}

- (void)didLogin
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:GKUserDidLogoutNotification object:nil];
    [self.headerView setNeedsLayout];
}

- (void)didLogout
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:GKUserDidLoginNotification object:nil];
    [self.headerView setNeedsLayout];
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
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:GKUserDidLogoutNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:GKUserDidLoginNotification object:nil];
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
    [self.headerView setNeedsLayout];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
