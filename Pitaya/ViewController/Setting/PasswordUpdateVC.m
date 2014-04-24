//
//  PasswordUpdateVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "PasswordUpdateVC.h"

@interface PasswordUpdateVC () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic, strong) IBOutlet UITextField *theNewPasswordTextField;
@property (nonatomic, strong) IBOutlet UITextField *verifyPasswordTextField;

@end

@implementation PasswordUpdateVC

#pragma mark - Selector Method

- (IBAction)tapSubmitButton:(id)sender
{
    if (self.oldPasswordTextField.text.length == 0) {
        [BBProgressHUD showText:@"请输入密码"];
        return;
    }
    
    if (self.theNewPasswordTextField.text.length == 0) {
        [BBProgressHUD showText:@"请输入新密码"];
        return;
    }
    
    if (self.verifyPasswordTextField.text.length == 0) {
        [BBProgressHUD showText:@"请确认新密码"];
        return;
    }
    
    if (self.oldPasswordTextField.text.length < 6 ||
        self.theNewPasswordTextField.text.length < 6 ||
        self.verifyPasswordTextField.text.length < 6) {
        [BBProgressHUD showText:@"密码至少6位"];
        return;
    }
    
    if (![self.theNewPasswordTextField.text isEqualToString:self.verifyPasswordTextField.text]) {
        [BBProgressHUD showText:@"两次输入的新密码不一致"];
        return;
    }
    
    [BBProgressHUD show];
    [GKDataManager updateUserProfileWithNickname:nil email:nil password:self.theNewPasswordTextField.text imageData:nil success:^(GKUser *user) {
        [BBProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger stateCode) {
        [BBProgressHUD showErrorWithText:@"修改失败"];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.oldPasswordTextField) {
            [self.theNewPasswordTextField becomeFirstResponder];
        } else if (textField == self.theNewPasswordTextField) {
            [self.verifyPasswordTextField becomeFirstResponder];
        } else if (textField == self.verifyPasswordTextField) {
            [self tapSubmitButton:nil];
        }
    }
    return YES;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.oldPasswordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
