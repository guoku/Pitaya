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

@end

@implementation SettingVC

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
    return 30.f;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
