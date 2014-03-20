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
    if (self.entity) {
        [self removeObserver];
    }
    _entity = entity;
    [self addObserver];
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

#pragma mark - Selector Method

- (IBAction)tapAvatarButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectionCell:didSelectUser:)]) {
        [self.delegate selectionCell:self didSelectUser:self.note.creator];
    }
}

- (IBAction)tapLikeButton:(id)sender
{
    if (k_isLogin) {
        [BBProgressHUD show];
        [GKDataManager likeEntityWithEntityId:self.entity.entityId isLike:!self.entity.isLiked success:^(BOOL liked) {
            if (liked) {
                [BBProgressHUD showSuccessWithText:@"喜爱成功"];
            } else {
                [BBProgressHUD dismiss];
            }
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showErrorWithText:@"喜爱失败!"];
        }];
    } else {
        [Passport loginWithSuccessBlock:^{
            [GKDataManager likeEntityWithEntityId:self.entity.entityId isLike:!self.entity.isLiked success:^(BOOL liked) {
                if (liked) {
                    [BBProgressHUD showSuccessWithText:@"喜爱成功"];
                } else {
                    [BBProgressHUD dismiss];
                }
            } failure:^(NSInteger stateCode) {
                [BBProgressHUD showErrorWithText:@"喜爱失败!"];
            }];
        }];
    }
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
    self.noteLabel.text = [self.note.text stringByAppendingString:@"\n\n\n\n\n\n\n\n"];
    
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

#pragma mark - KVO

- (void)addObserver
{
    [self.entity addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.entity removeObserver:self forKeyPath:@"liked"];
    [self.entity removeObserver:self forKeyPath:@"likeCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

- (void)dealloc
{
    [self removeObserver];
}

@end
