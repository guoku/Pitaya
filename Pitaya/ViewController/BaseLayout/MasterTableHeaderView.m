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
    
    [self.avatarButton setImageWithURL:[Passport sharedInstance].user.avatarURL forState:UIControlStateNormal];
    self.nicknameLabel.text = [Passport sharedInstance].user.nickname;
}

@end
