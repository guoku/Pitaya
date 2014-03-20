//
//  NoteCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteCell.h"

@interface NoteCell ()

@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UIButton *nicknameButton;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *pokeButton;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIImageView *starImageView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation NoteCell

#pragma mark - Getter And Setter

- (void)setNote:(GKNote *)note
{
    _note = note;
    
    [self setNeedsLayout];
}

#pragma mark - Selector Method

- (IBAction)tapAvatarButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCell:didSelectUser:)]) {
        [self.delegate noteCell:self didSelectUser:self.note.creator];
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 左右边线
    CALayer *leftLinelayer = [CALayer layer];
    leftLinelayer.backgroundColor = UIColorFromRGB(0xE9E9E9).CGColor;
    leftLinelayer.frame = CGRectMake(0.f, 0.f, 1.f, CGRectGetHeight(self.backView.bounds));
    [self.backView.layer addSublayer:leftLinelayer];
    
    CALayer *rightLinelayer = [CALayer layer];
    rightLinelayer.backgroundColor = UIColorFromRGB(0xE9E9E9).CGColor;
    rightLinelayer.frame = CGRectMake((CGRectGetWidth(self.backView.bounds) - 1.f), 0.f, 1.f, CGRectGetHeight(self.backView.bounds));
    [self.backView.layer addSublayer:rightLinelayer];
    
    // 头像
    [self.avatarButton setImageWithURL:self.note.creator.avatarURL_s forState:UIControlStateNormal];
    
    // 昵称
    [self.nicknameButton setTitle:self.note.creator.nickname forState:UIControlStateNormal];
    
    // 点评内容
    self.contentLabel.text = self.note.text;
    
    // 赞按钮
    self.pokeButton.selected = self.note.isPoked;
    [self.pokeButton setTitle:@(self.note.pokeCount).stringValue forState:UIControlStateNormal];
    
    // 评论按钮
    [self.commentButton setTitle:@(self.note.commentCount).stringValue forState:UIControlStateNormal];
    
    // 时间
    self.dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.note.createdTime] stringWithDefaultFormat];
    
    // 精选星星标识
    self.starImageView.hidden = !self.note.isMarked;
}

@end
