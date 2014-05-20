//
//  MasterTableViewCell.m
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MasterTableViewCell.h"

@interface MasterTableViewCell ()

@property (nonatomic, strong) UIImageView *countImageView;

@end

@implementation MasterTableViewCell

- (UIImageView *)countImageView
{
    if (!_countImageView) {
        _countImageView = [[UIImageView alloc] initWithFrame:CGRectMake(41.f, 20.f, 6.f, 6.f)];
        _countImageView.backgroundColor = UIColorFromRGB(0x427EC0);
        _countImageView.layer.cornerRadius = 3.f;
        _countImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_countImageView];
    }
    return _countImageView;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = self.isSelected ? UIColorFromRGB(0x427EC0) : UIColorFromRGB(0xAAAAAA);
    
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
    
    if ([self.titleLabel.text isEqualToString:@"精选"]) {
        self.countImageView.hidden = (self.count == 0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setNeedsLayout];
}

@end
