//
//  EntityCollectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-25.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "EntityCollectionCell.h"

@interface EntityCollectionCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;

@end

@implementation EntityCollectionCell

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
    
    // 商品图
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    [self.imageView setImageWithURL:self.entity.imageURL_310x310];
    
    // 商品品牌+标题
    if (self.entity.brand.length > 0) {
        self.contentLabel.text = [self.entity.brand stringByAppendingFormat:@" - %@\n ", self.entity.title];
    } else {
        self.contentLabel.text = [self.entity.title stringByAppendingFormat:@"\n "];
    }
    
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.entity.lowestPrice];
    
    // 喜爱按钮
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 15.f);
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 10.f);
    if (self.entity.isLiked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn_highlighted"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateNormal];
    }
}

@end
