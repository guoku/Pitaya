//
//  MasterTableHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MasterTableHeaderView.h"

@implementation MasterTableHeaderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (k_isLogin) {
        [self.avatarButton setImageWithURL:[Passport sharedInstance].user.avatarURL_s forState:UIControlStateNormal];
        [self.nicknameButton setTitle:[Passport sharedInstance].user.nickname forState:UIControlStateNormal];
    } else {
        [self.avatarButton setImage:[UIImage imageNamed:@"menu_icon_tuzi"] forState:UIControlStateNormal];
        [self.nicknameButton setTitle:@"登陆" forState:UIControlStateNormal];
    }
}

@end
