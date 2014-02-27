//
//  HotCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-26.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "HotCell.h"

@interface HotCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;

@end

@implementation HotCell

#pragma mark - Getter And Setter

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;

    [self setNeedsLayout];
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;

    if (!self.entity) {
        return;
    }

    // 商品图
    [self.imageView setImageWithURL:self.entity.imageURL_310x310];

    // 喜爱按钮
    [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %d", self.entity.likeCount] forState:UIControlStateNormal];
    if (self.entity.isLiked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn_highlighted"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateNormal];
    }
}

@end
