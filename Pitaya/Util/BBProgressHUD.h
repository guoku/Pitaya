//
//  BBProgressHUD.h
//  Blueberry
//
//  Created by 魏哲 on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SVProgressHUD.h"

@interface BBProgressHUD : SVProgressHUD

+ (void)showText:(NSString *)text;
+ (void)showSuccessWithText:(NSString *)text;
+ (void)showErrorWithText:(NSString *)text;

@end
