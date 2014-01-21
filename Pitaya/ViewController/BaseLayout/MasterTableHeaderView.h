//
//  MasterTableHeaderView.h
//  Pitaya
//
//  Created by 魏哲 on 14-1-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterTableHeaderView : UIView

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *nicknameLabel;

 - (IBAction)tapAvatarButton:(UIButton *)button;

@end
