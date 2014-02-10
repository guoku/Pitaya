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
    
    self.titleLabel.textColor = self.selected ? UIColorFromRGB(0x5E90C8) : UIColorFromRGB(0x666666);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setNeedsLayout];
}

@end
