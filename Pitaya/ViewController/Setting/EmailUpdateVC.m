//
//  EmailUpdateVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "EmailUpdateVC.h"

@interface EmailUpdateVC ()

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;

@end

@implementation EmailUpdateVC

#pragma mark - Selector Method

- (IBAction)tapSubmitButton:(id)sender
{
    if (self.emailTextField.text.length == 0) {
        [BBProgressHUD showText:@"请输入邮箱"];
        return;
    }
    
    if (![self.emailTextField.text isValidEmail]) {
        [BBProgressHUD showText:@"请输入正确格式的邮箱"];
        return;
    }
    
    if ([self.emailTextField.text isEqualToString:[Passport sharedInstance].user.nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [BBProgressHUD show];
        [GKDataManager updateUserProfileWithNickname:nil email:self.emailTextField.text password:nil imageData:nil success:^(GKUser *user) {
            [BBProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showErrorWithText:@"修改失败"];
        }];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailTextField.text = [Passport sharedInstance].user.email;
    [self.emailTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
