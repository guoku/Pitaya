//
//  NoteCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteCell.h"
#import "GKAttributedLabel.h"

static CGFloat const kNoteCellTextFontSize = 15.f;

@interface NoteCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UIButton *nicknameButton;
@property (nonatomic, strong) IBOutlet GKAttributedLabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *pokeButton;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIImageView *starImageView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation NoteCell

+ (CGFloat)heightForCellWithNote:(GKNote *)note
{
    CGSize contentLabelSize = [note.text sizeWithFont:[UIFont systemFontOfSize:kNoteCellTextFontSize] constrainedToSize:CGSizeMake(580.f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return contentLabelSize.height + 95.f;
}

#pragma mark - Getter And Setter

- (void)setNote:(GKNote *)note
{
    if (_note) {
        [self removeObserver];
    }
    
    _note = note;
    [self addObserver];
    
    [self setNeedsLayout];
}

#pragma mark - Selector Method

- (IBAction)tapAvatarButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCell:didSelectUser:)]) {
        [self.delegate noteCell:self didSelectUser:self.note.creator];
    }
}

- (IBAction)tapPokeButton:(id)sender
{
    [GKDataManager pokeWithNoteId:self.note.noteId state:!self.pokeButton.isSelected success:nil failure:nil];
    
    if (self.note.isPoked) {
        self.note.pokeCount -= 1;
    } else {
        self.note.pokeCount += 1;
    }
    self.note.poked = !self.note.isPoked;
    
    if (_delegate && [_delegate respondsToSelector:@selector(noteCell:tapPokeButton:)]) {
        [self.delegate noteCell:self tapPokeButton:sender];
    }
}

- (IBAction)tapCommentButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCell:tapCommentButton:)]) {
        [self.delegate noteCell:self tapCommentButton:sender];
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCell:didSelectTag:fromUser:)]) {
        [self.delegate noteCell:self didSelectTag:phoneNumber fromUser:self.note.creator];
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 左右边线
    CALayer *leftLinelayer = [CALayer layer];
    leftLinelayer.backgroundColor = UIColorFromRGB(0xF6F6F6).CGColor;
    leftLinelayer.frame = CGRectMake(0.f, 0.f, 1.f, CGRectGetHeight(self.backView.bounds));
    [self.backView.layer addSublayer:leftLinelayer];
    
    CALayer *rightLinelayer = [CALayer layer];
    rightLinelayer.backgroundColor = UIColorFromRGB(0xF6F6F6).CGColor;
    rightLinelayer.frame = CGRectMake((CGRectGetWidth(self.backView.bounds) - 1.f), 0.f, 1.f, CGRectGetHeight(self.backView.bounds));
    [self.backView.layer addSublayer:rightLinelayer];
    
    // 头像
    [self.avatarButton setImageWithURL:self.note.creator.avatarURL forState:UIControlStateNormal];
    
    // 昵称
    [self.nicknameButton setTitle:self.note.creator.nickname forState:UIControlStateNormal];
    
    // 点评内容
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.textColor = UIColorFromRGB(0x777777);
    self.contentLabel.font = [GKAttributedLabel fontOfSize:kNoteCellTextFontSize];
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.contentLabel.minimumLineHeight = 17.f;
    self.contentLabel.plainText = self.note.text;
    
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

#pragma mark - KVO

- (void)addObserver
{
    [self.note addObserver:self forKeyPath:@"poked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.note addObserver:self forKeyPath:@"pokeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.note addObserver:self forKeyPath:@"commentCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.note removeObserver:self forKeyPath:@"poked"];
    [self.note removeObserver:self forKeyPath:@"pokeCount"];
    [self.note removeObserver:self forKeyPath:@"commentCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"poked"]) {
        self.pokeButton.selected = self.note.isPoked;
    } else if ([keyPath isEqualToString:@"pokeCount"]) {
        [self.pokeButton setTitle:@(self.note.pokeCount).stringValue forState:UIControlStateNormal];
    } else if ([keyPath isEqualToString:@"commentCount"]) {
        [self.commentButton setTitle:@(self.note.commentCount).stringValue forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
