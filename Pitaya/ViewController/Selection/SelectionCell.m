//
//  SelectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SelectionCell.h"

@interface SelectionCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation SelectionCell

#pragma mark - Getter And Setter

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    [self setNeedsLayout];
}

- (void)setNote:(GKNote *)note
{
    _note = note;
    
    [self setNeedsLayout];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    [self setNeedsLayout];
}

#pragma mark - Life Cycle

- (void)setNeedsLayout
{
    if (_entity && _note && _date) {
        [super setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    
    if (!(self.entity && self.note && self.date)) {
        return;
    }
    
    // 商品图
    [self.imageView setImageWithURL:self.entity.imageURL_310x310];
    
    // 点评内容
    self.noteLabel.text = self.note.text;
    
    // 喜爱按钮
    [self.likeButton setTitle:[NSString stringWithFormat:@"喜爱 %d", self.entity.likeCount] forState:UIControlStateNormal];
    if (self.entity.isLiked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn_highlighted"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateNormal];
    }
    
    // 用户头像
    [self.avatarButton setImageWithURL:self.note.creator.avatarURL_s forState:UIControlStateNormal];
    
    // 时间
    self.dateLabel.text = [self.date stringWithDefaultFormat];
}

@end
