//
//  SettingVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SettingVC.h"

static NSInteger const AvatarImageViewTag = 100;
static NSInteger const NicknameLabelTag = 101;
static NSInteger const EmailLabelTag = 102;
static NSInteger const VersionLabelTag = 103;
static NSInteger const LogoutButtonTag = 999;

@interface SettingVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation SettingVC

#pragma mark - Private Method

- (void)refresh
{
    if (k_isLogin) {
        self.logoutButton.hidden = NO;
    } else {
        self.logoutButton.hidden = YES;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Selector Method

- (void)tapLogoutButton
{
    if (k_isLogin) {
        [Passport logout];
        [self.tableView reloadData];
    }
}

- (void)didLogin
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLoginNotification object:nil];
    
    [self addObserver];
    [self refresh];
}

- (void)willLogout
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserWillLogoutNotification object:nil];
    
    [[Passport sharedInstance].user removeObserver:self forKeyPath:@"avatarURL"];
    [[Passport sharedInstance].user removeObserver:self forKeyPath:@"nickname"];
    [[Passport sharedInstance].user removeObserver:self forKeyPath:@"email"];
}

- (void)didLogout
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLogoutNotification object:nil];
    
    [self addObserver];
    [self refresh];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    switch (indexPath.row) {
        // 帐号设置
        case 0:
            CellIdentifier = @"SettingCell00";
            break;
        case 1:
            CellIdentifier = @"SettingCell01";
            break;
        case 2:
            CellIdentifier = @"SettingCell02";
            break;
        case 3:
            CellIdentifier = @"SettingCell03";
            break;
        case 4:
            CellIdentifier = @"SettingCell04";
            break;
        // 推荐
        case 5:
            CellIdentifier = @"SettingCell10";
            break;
        case 6:
            CellIdentifier = @"SettingCell11";
            break;
        case 7:
            CellIdentifier = @"SettingCell12";
            break;
        case 8:
            CellIdentifier = @"SettingCell13";
            break;
        case 9:
            CellIdentifier = @"SettingCell14";
            break;
        // 其他
        case 10:
            CellIdentifier = @"SettingCell20";
            break;
        case 11:
            CellIdentifier = @"SettingCell21";
            break;
        case 12:
            CellIdentifier = @"SettingCell22";
            break;
        case 13:
            CellIdentifier = @"SettingCell23";
            break;
        case 14:
            CellIdentifier = @"SettingCell24";
            break;
        // 注销登录
        case 15:
            CellIdentifier = @"SettingCell30";
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!iOS7) {
        cell.backgroundView = [UIView new];
        UIView *separatorView = [cell viewWithTag:111];
        if (!separatorView) {
            separatorView = [[UIView alloc] initWithFrame:CGRectMake(15.f, 49.f, 758.f, 1.f)];
            separatorView.backgroundColor = UIColorFromRGB(0xE9E9E9);
            [cell addSubview:separatorView];
        }
    }
    
    switch (indexPath.row) {
        case 1:
        {
            // 头像
            self.avatarImageView = (UIImageView *)[cell viewWithTag:AvatarImageViewTag];
            [self.avatarImageView setImageWithURL:[Passport sharedInstance].user.avatarURL_s];
        }
            
        case 2:
        {
            // 昵称
            self.nicknameLabel = (UILabel *)[cell viewWithTag:NicknameLabelTag];
            self.nicknameLabel.text = [Passport sharedInstance].user.nickname;
            break;
        }
            
        case 3:
        {
            // 邮箱
            self.emailLabel = (UILabel *)[cell viewWithTag:EmailLabelTag];
            self.emailLabel.text = [Passport sharedInstance].user.email;
            break;
        }
            
        case 14:
        {
            // 版本
            self.versionLabel = (UILabel *)[cell viewWithTag:VersionLabelTag];
            self.versionLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            break;
        }
            
        case 15:
        {
            // 注销
            self.logoutButton = (UIButton *)[cell viewWithTag:LogoutButtonTag];
            [self.logoutButton addTarget:self action:@selector(tapLogoutButton) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!k_isLogin && indexPath.row < 5) {
        return 0.f;
    }
    
    if (!k_isLogin && indexPath.row == 15) {
        return 0.f;
    }
    
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            // 修改头像
            break;
        }
        case 2:
        {
            // 修改昵称
            break;
        }
        case 3:
        {
            // 修改邮箱
            break;
        }
        case 4:
        {
            // 修改密码
            break;
        }
        case 6:
        {
            // 评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id477652209?mt=8"]];
            break;
        }
        case 7:
        {
            // 分享给微信好友
            break;
        }
        case 8:
        {
            // 分享至朋友圈
            break;
        }
        case 9:
        {
            // 关注我们的新浪微博
            break;
        }
        case 11:
        {
            // 应用推荐
            NSLog(@"应用推荐");
            break;
        }
        case 12:
        {
            // 意见反馈
            NSLog(@"意见反馈");
            break;
        }
        case 13:
        {
            // 清除图片缓存
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否清除图片缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认清除", nil];
            [alertView show];
            break;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [BBProgressHUD showSuccessWithText:@"清除完成"];
        }];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (k_isLogin) {
        self.logoutButton.hidden = NO;
    } else {
        self.logoutButton.hidden = YES;
    }
    
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO

- (void)addObserver
{
    if (k_isLogin) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogout) name:GKUserWillLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:GKUserDidLogoutNotification object:nil];
        
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:GKUserDidLoginNotification object:nil];
    }
}

- (void)removeObserver
{
    if ([Passport sharedInstance].user.observationInfo) {
        [[Passport sharedInstance].user removeObserver:self forKeyPath:@"avatarURL"];
        [[Passport sharedInstance].user removeObserver:self forKeyPath:@"nickname"];
        [[Passport sharedInstance].user removeObserver:self forKeyPath:@"email"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"avatarURL"]) {
        GKUser *user = (GKUser *)object;
        [self.avatarImageView setImageWithURL:user.avatarURL_s];
    } else if ([keyPath isEqualToString:@"nickname"]) {
        GKUser *user = (GKUser *)object;
        self.nicknameLabel.text = user.nickname;
    } else if ([keyPath isEqualToString:@"email"]) {
        GKUser *user = (GKUser *)object;
        self.emailLabel.text = user.email;
    }
}

- (void)dealloc
{
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
