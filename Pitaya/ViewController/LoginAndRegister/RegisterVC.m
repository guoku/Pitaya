//
//  RegisterVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-15.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation RegisterVC

#pragma mark - Selector Method

- (IBAction)tapAvatarButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"照片库", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)tapRegisterButton:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
