//
//  RegisterVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-15.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation RegisterVC

#pragma mark - Selector Method

- (IBAction)tapAvatarButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)tapAgreementButton:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://guoku.com/agreement/"]];
}

- (IBAction)tapRegisterButton:(id)sender
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *nickname = self.nicknameTextField.text;
    
    if (!nickname || nickname.length == 0) {
        [BBProgressHUD showText:@"请输入昵称"];
        return;
    }
    
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
    
    if (password.length < 6) {
        [BBProgressHUD showText:@"密码至少6位"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [GKDataManager registerWithEmail:email password:password nickname:nickname imageData:[self.avatarButton.imageView.image imageData] sinaUserId:[Passport sharedInstance].sinaUserID sinaToken:[Passport sharedInstance].sinaToken                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    taobaoUserId:[Passport sharedInstance].taobaoId taobaoToken:[Passport sharedInstance].taobaoToken screenName:[Passport sharedInstance].screenName success:^(GKUser *user, NSString *session) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GKUserDidLoginNotification object:nil];
        [BBProgressHUD dismiss];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSInteger stateCode, NSString *type, NSString *message) {
        switch (stateCode) {
            case 409:
            {
                if ([type isEqualToString:@"email"]) {
                    [BBProgressHUD showText:@"该邮箱已被占用!"];
                } else if ([type isEqualToString:@"nickname"]) {
                    [BBProgressHUD showText:@"该昵称已被占用!"];
                } else if ([type isEqualToString:@"sina_id"]) {
                    [BBProgressHUD showText:@"该新浪微博帐号已被占用!"];
                } else if ([type isEqualToString:@"taobao_id"]) {
                    [BBProgressHUD showText:@"该淘宝帐号已被占用!"];
                }
                break;
            }
                
            case 500:
            {
                [BBProgressHUD showText:@"服务器出错!"];
                break;
            }
                
            default:
                [BBProgressHUD dismiss];
                break;
        }
    }];
}

- (void)colsePhotoLibrary
{
    [self.popover dismissPopoverAnimated:YES];
}

#pragma mark - Private Method

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
        [self.popover presentPopoverFromRect:CGRectMake(self.avatarButton.frame.origin.x + CGRectGetWidth(self.avatarButton.frame)/2, self.avatarButton.frame.origin.y + CGRectGetHeight(self.avatarButton.frame), 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.nicknameTextField) {
            [self.emailTextField becomeFirstResponder];
        } else if (textField == self.emailTextField) {
            [self.passwordTextField becomeFirstResponder];
        } else if (textField == self.passwordTextField) {
            [self tapRegisterButton:nil];
        }
        return NO;
    }
    
    return YES;
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
    
    [self.avatarButton setImage:image forState:UIControlStateNormal];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if([info count] > 0) {
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.avatarButton setImage:editedImage forState:UIControlStateNormal];
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

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([Passport sharedInstance].screenName) {
        self.nicknameTextField.text = [Passport sharedInstance].screenName;
        if ([Passport sharedInstance].sinaAvatarURL) {
            [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:[Passport sharedInstance].sinaAvatarURL] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (!k_isLogin) {
        [self.avatarButton setImage:[UIImage imageNamed:@"login_icon_avatar"] forState:UIControlStateNormal];
        self.nicknameTextField.text = nil;
        self.emailTextField.text = nil;
        self.passwordTextField.text = nil;
        
        [Passport sharedInstance].sinaUserID = nil;
        [Passport sharedInstance].sinaToken = nil;
        [Passport sharedInstance].sinaAvatarURL = nil;
        [Passport sharedInstance].taobaoId = nil;
        [Passport sharedInstance].taobaoToken = nil;
        [Passport sharedInstance].screenName = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
