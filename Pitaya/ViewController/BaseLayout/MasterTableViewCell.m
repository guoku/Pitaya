//
//  MasterTableViewCell.m
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MasterTableViewCell.h"

@implementation MasterTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = self.isSelected ? UIColorFromRGB(0x5E90C8) : UIColorFromRGB(0x666666);
    
    NSDictionary *dict = @{
                           @"首页":@"menu_icon_homepage",
                           @"精选":@"menu_icon_selection",
                           @"热门":@"menu_icon_hot",
                           @"发现":@"menu_icon_search",
                           @"动态":@"menu_icon_activity",
                           @"消息":@"menu_icon_message",
                           @"设置":@"menu_icon_setting",
                           };
    
    NSString *imageName = dict[self.titleLabel.text];
    if (self.isSelected) {
        imageName = [imageName stringByAppendingString:@"_press"];
    }
    self.iconImageView.image = [UIImage imageNamed:imageName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setNeedsLayout];
}

@end
