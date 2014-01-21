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
    
    self.titleLabel.textColor = self.selected ? [UIColor blueColor] : [UIColor darkGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setNeedsLayout];
}

@end
