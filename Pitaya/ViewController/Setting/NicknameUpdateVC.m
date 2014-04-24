//
//  NicknameUpdateVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NicknameUpdateVC.h"

@interface NicknameUpdateVC ()

@property (nonatomic, strong) IBOutlet UITextField *nicknameTextField;

@end

@implementation NicknameUpdateVC

#pragma mark - Selector Method

- (IBAction)tapSubmitButton:(id)sender
{
    if (self.nicknameTextField.text.length == 0) {
        [BBProgressHUD showText:@"请输入昵称"];
        return;
    }
    
    if ([self.nicknameTextField.text isEqualToString:[Passport sharedInstance].user.nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [BBProgressHUD show];
        [GKDataManager updateUserProfileWithNickname:self.nicknameTextField.text email:nil password:nil imageData:nil success:^(GKUser *user) {
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
    
    self.nicknameTextField.text = [Passport sharedInstance].user.nickname;
    [self.nicknameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
