//
//  SettingVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SettingVC.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
#import "UMTableViewController.h"

static NSInteger const AvatarImageViewTag = 100;
static NSInteger const NicknameLabelTag = 101;
static NSInteger const EmailLabelTag = 102;
static NSInteger const VersionLabelTag = 103;
static NSInteger const LogoutButtonTag = 999;

@interface SettingVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIPopoverController *popover;

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

- (void)showImagePickerFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.delegate = self;
        imagePickerVC.navigationBar.opaque = YES;
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerVC];
        self.popover.popoverContentSize = CGSizeMake(300.f, 400.f);
        [self.popover presentPopoverFromRect:CGRectMake(self.avatarImageView.frame.origin.x + CGRectGetWidth(self.avatarImageView.frame)/2, self.avatarImageView.frame.origin.y + CGRectGetHeight(self.avatarImageView.frame), 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)showImagePickerToTakePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerVC.delegate = self;
        [kAppDelegate.alertWindow makeKeyAndVisible];
        [kAppDelegate.alertWindow.rootViewController presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)updateAvatarWithImage:(UIImage *)image
{
    [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [GKDataManager updateUserProfileWithNickname:nil email:nil password:nil imageData:[image imageData] success:^(GKUser *user) {
        [self.tableView reloadData];
        [BBProgressHUD showSuccessWithText:@"更新成功"];
    } failure:^(NSInteger stateCode) {
        [BBProgressHUD showErrorWithText:@"更新失败"];
    }];
}

- (void)followGuoku
{
    [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[Passport sharedInstance].weiboInstance requestWithURL:@"friendships/create.json" params:[@{@"uid":@"2179686555"} mutableCopy] httpMethod:@"POST" delegate:self];
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
    return 14;
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
        // 其他
        case 8:
            CellIdentifier = @"SettingCell20";
            break;
        case 9:
            CellIdentifier = @"SettingCell21";
            break;
        case 10:
            CellIdentifier = @"SettingCell22";
            break;
        case 11:
            CellIdentifier = @"SettingCell23";
            break;
        case 12:
            CellIdentifier = @"SettingCell24";
            break;
        // 注销登录
        case 13:
            CellIdentifier = @"SettingCell30";
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!iOS7) {
        UIView *separatorView = [cell viewWithTag:111];
        if (!separatorView) {
            CGRect frame = CGRectMake(15.f, 49.f, 758.f, 1.f);
            if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 13) {
                frame.origin.y += 10.f;
            }
            separatorView = [[UIView alloc] initWithFrame:frame];
            separatorView.tag = 111;
            separatorView.backgroundColor = UIColorFromRGB(0xf6f6f6);
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
            
        case 12:
        {
            // 版本
            self.versionLabel = (UILabel *)[cell viewWithTag:VersionLabelTag];
            self.versionLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            break;
        }
            
        case 13:
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
    
    if (!k_isLogin && indexPath.row == 13) {
        return 0.f;
    }
    
    if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 13) {
        // section header or logout button
        return 60.f;
    } else {
        // cell
        return 50.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            // 修改头像
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
            [actionSheet showInView:self.view];
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
            // 关注我们的新浪微博
            if (![Passport sharedInstance].weiboInstance) {
                SinaWeibo *weiboInstance = [[SinaWeibo alloc] initWithAppKey:kWeiboAPPKey appSecret:kWeiboSecret appRedirectURI:kWeiboRedirectURL andDelegate:self];
                [Passport sharedInstance].weiboInstance = weiboInstance;
            }
            
            if (![Passport sharedInstance].weiboInstance.isLoggedIn) {
                [[Passport sharedInstance].weiboInstance logIn];
            } else {
                [self followGuoku];
            }
            
            break;
        }
        case 9:
        {
            // 应用推荐
            UMTableViewController *controller = [[UMTableViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 10:
        {
            // 意见反馈
            UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
            feedbackViewController.appkey = UMENG_APPKEY;
            [self.navigationController pushViewController:feedbackViewController animated:YES];
            
            break;
        }
        case 11:
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 修改头像
    switch (buttonIndex) {
        case 0:
        {
            // 拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self showImagePickerToTakePhoto];
            }
            break;
        }
            
        case 1:
        {
            // 照片库
            [self showImagePickerFromPhotoLibrary];
            break;
        }
    }
}

#pragma mark- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [kAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.window.hidden = YES;
    }];
    
    [self updateAvatarWithImage:image];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if([info count] > 0) {
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self updateAvatarWithImage:editedImage];
    }
    
    [self.popover dismissPopoverAnimated:YES];
    
    [kAppDelegate.alertWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [kAppDelegate.alertWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [kAppDelegate.window makeKeyAndVisible];
        kAppDelegate.alertWindow.hidden = YES;
    }];
}

#pragma mark - SinaWeiboDelegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [Passport sharedInstance].sinaUserID = sinaweibo.userID;
    [Passport sharedInstance].sinaToken = sinaweibo.accessToken;
    [Passport sharedInstance].sinaExpirationDate = sinaweibo.expirationDate;
    
    [self followGuoku];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    if(error.code == 21332)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"授权过期，需要重新登录新浪微博" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [BBProgressHUD dismiss];
    if((error.code == 21315)||(error.code == 10006)) {
        [[Passport sharedInstance].weiboInstance logIn];
    } else if(error.code == 20506) {
        [BBProgressHUD showSuccessWithText:@"已关注果库\U0001F603"];
    } else {
        [BBProgressHUD showErrorWithText:[NSString  stringWithFormat:@"网络错误,错误代码%d", error.code]];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [BBProgressHUD dismiss];
    [BBProgressHUD showSuccessWithText:@"成功关注果库\U0001F603" ];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"设置页";
    
    if (!iOS7) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
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
