//
//  LoginVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-13.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "LoginVC.h"
#import "TaobaoOAuthVC.h"

@interface LoginVC () <TaobaoOAuthVCDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) IBOutlet UIButton *sinaLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *taobaoLoginButton;

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginVC

- (IBAction)tapCloseButton:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapLoginButton:(id)sender
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (!email || email.length == 0) {
        [BBProgressHUD showText:@"请输入邮箱"];
        return;
    }
    
    if (![email isValidEmail]) {
        [BBProgressHUD showText:@"请输入正确格式的邮箱"];
        return;
    }
    
    if (!password || password.length == 0) {
        [BBProgressHUD showText:@"请输入密码"];
        return;
    }
    
    [BBProgressHUD show];
    __weak __typeof(&*self)weakSelf = self;
    [GKDataManager loginWithEmail:email password:password success:^(GKUser *user, NSString *session) {
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [BBProgressHUD dismiss];
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:GKUserDidLoginNotification object:nil];
    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        switch (stateCode) {
            case 500:
            {
                [BBProgressHUD showText:@"服务器出错!"];
                break;
            }
                
            default:
                [BBProgressHUD dismiss];
                break;
        }
        
        if ([type isEqualToString:@"email"]) {
            [BBProgressHUD showErrorWithText:@"该邮箱不存在!"];
        } else if ([type isEqualToString:@"password"]) {
            [BBProgressHUD showErrorWithText:@"邮箱与密码不匹配!"];
        }
    }];
}

- (IBAction)tapSinaLoginButton:(id)sender
{
    
}

- (IBAction)tapTaobaoLoginButton:(id)sender
{
    TaobaoOAuthVC *vc = [[TaobaoOAuthVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tapRegisterButton:(id)sender
{
    UITableViewController *registerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - TaobaoOAuthVCDelegate

- (void)taobaoAuthorizationDidFinishWithUserInfo:(NSDictionary *)userInfo
{
    [Passport sharedInstance].taobaoId = userInfo[@"taobao_user_id"];
    [Passport sharedInstance].taobaoToken = userInfo[@"access_token"];
    [Passport sharedInstance].screenName = userInfo[@"taobao_user_nick"];
    
    [self.navigationController popViewControllerAnimated:NO];
    [self tapRegisterButton:nil];
    
    NSLog(@"%@", userInfo);
}

- (void)taobaoAuthorizationDidFailWithError:(NSError *)error
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [BBProgressHUD showErrorWithText:@"登录失败"];
}

- (void)taobaoAuthorizationDidCancel
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [BBProgressHUD showErrorWithText:@"登录失败"];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *titleColor = [UIColor redColor];
    
    if (iOS7) {
        self.rightBarButtonItem.tintColor = titleColor;
    } else {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 30.f)];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0.f, -22.f, 0.f, 0.f);
        [leftButton setImage:[UIImage imageNamed:@"nav_back_btn"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(tapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 30.f)];
        [rightButton setTitleColor:titleColor forState:UIControlStateNormal];
        [rightButton setTitle:@"注册" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(tapRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
