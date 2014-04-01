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
static NSInteger const HighQualityImageSwitchTag = 103;
static NSInteger const HideNoteSwitchTag = 104;
static NSInteger const VersionLabelTag = 105;

@interface SettingVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UISwitch *highQualityImageSwitch;
@property (nonatomic, strong) UISwitch *hideNoteSwitch;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;

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

- (IBAction)tapLogoutButton:(id)sender
{
    if (k_isLogin) {
        [Passport logout];
        self.logoutButton.hidden = YES;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 2;
        case 2:
            return 4;
        case 3:
            return 4;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"SettingCell%d%d", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.section) {
        case 0:
        {
            if (!k_isLogin) {
                break;
            }
            
            GKUser *user = [Passport sharedInstance].user;
            
            switch (indexPath.row) {
                case 0:
                {
                    // 头像
                    self.avatarImageView = (UIImageView *)[cell viewWithTag:AvatarImageViewTag];
                    [self.avatarImageView setImageWithURL:user.avatarURL_s];
                    break;
                }
                    
                case 1:
                {
                    // 昵称
                    self.nicknameLabel = (UILabel *)[cell viewWithTag:NicknameLabelTag];
                    self.nicknameLabel.text = user.nickname;
                    break;
                }
                    
                case 2:
                {
                    // 邮箱
                    self.emailLabel = (UILabel *)[cell viewWithTag:EmailLabelTag];
                    self.emailLabel.text = user.email;
                    break;
                }
            }
            break;
        }
            
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    // 高清图片开关
                    self.highQualityImageSwitch = (UISwitch *)[cell viewWithTag:HighQualityImageSwitchTag];
                    self.highQualityImageSwitch.on = [SettingManager sharedInstance].highQualityImage;
                    break;
                }
                    
                case 1:
                {
                    // 精选点评开关
                    self.hideNoteSwitch = (UISwitch *)[cell viewWithTag:HideNoteSwitchTag];
                    self.hideNoteSwitch.on = [SettingManager sharedInstance].hidesNote;
                    break;
                }
            }
            break;
        }
            
        case 3:
        {
            if (indexPath.row == 3) {
                self.versionLabel = (UILabel *)[cell viewWithTag:VersionLabelTag];
                self.versionLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            }
            break;
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 30.f)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, 100.f, 30.f)];
    titleLabel.font = [UIFont appFontWithSize:15.f bold:YES];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    [view addSubview:titleLabel];
    
    switch (section) {
        case 0:
        {
            if (!k_isLogin) {
                return [UIView new];
            }
            titleLabel.text = @"账号设置";
            break;
        }
        case 1:
        {
            titleLabel.text = @"系统设置";
            break;
        }
        case 2:
        {
            titleLabel.text = @"推荐";
            break;
        }
        case 3:
        {
            titleLabel.text = @"其他";
            break;
        }
        default:
            titleLabel.text = @"";
    }
    
    return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!k_isLogin && indexPath.section == 0) {
        return 0.f;
    }
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!k_isLogin && section == 0) {
        return 0.5f;
    }
    return 30.f;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addObserver
{
    if (k_isLogin) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLogout) name:GKUserWillLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:GKUserDidLogoutNotification object:nil];
        
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [[Passport sharedInstance].user addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        NSLog(@"addObserver willLogout~~~");
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:GKUserDidLoginNotification object:nil];
        NSLog(@"addObserver didLogin");
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
