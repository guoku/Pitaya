//
//  BBProgressHUD.m
//  Blueberry
//
//  Created by 魏哲 on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "BBProgressHUD.h"

@implementation BBProgressHUD

+ (void)showText:(NSString *)text
{
    [SVProgressHUD showImage:nil status:text];
}

+ (void)showSuccessWithText:(NSString *)text
{
    [SVProgressHUD showSuccessWithStatus:text];
}

+ (void)showErrorWithText:(NSString *)text
{
    [SVProgressHUD showErrorWithStatus:text];
}

@end
