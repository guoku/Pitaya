//
//  CommentCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CommentCell.h"
#import "STTweetLabel.h"

@interface CommentCell ()

@property (nonatomic, strong) IBOutlet IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) IBOutlet IBOutlet UILabel *replyLabel;
@property (nonatomic, strong) IBOutlet IBOutlet UILabel *replyNicknameLabel;
@property (nonatomic, strong) IBOutlet IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IBOutlet IBOutlet STTweetLabel *commentLabel;
@property (nonatomic, strong) IBOutlet IBOutlet UILabel *dateLabel;

@end

@implementation CommentCell

+ (CGFloat)heightForComment:(GKComment *)comment
{
    STTweetLabel *label = [[STTweetLabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 620.f, 0.f)];
    label.font = [UIFont appFontWithSize:15.f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = comment.text;
    CGSize size = [label suggestedFrameSizeToFitEntireStringConstraintedToWidth:CGRectGetWidth(label.bounds)];
    return size.height + 100.f;
}

- (void)setComment:(GKComment *)comment
{
    _comment = comment;
    
    [self setNeedsLayout];
}

- (IBAction)tapAvatarButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentCell:didSelectUser:)]) {
        [self.delegate commentCell:self didSelectUser:self.comment.creator];
    }
}

- (IBAction)tapReplyButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentCell:replyComment:)]) {
        [self.delegate commentCell:self replyComment:self.comment];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    GKUser *user = self.comment.creator;
    
    [self.avatarButton setImageWithURL:user.avatarURL_s forState:UIControlStateNormal];
    
    self.nicknameLabel.text = user.nickname;
    
    if (self.comment.repliedUser) {
        self.replyLabel.hidden = NO;
        self.replyNicknameLabel.text = self.comment.repliedUser.nickname;
    } else {
        self.replyLabel.hidden = YES;
        self.replyNicknameLabel.text = nil;
    }
    
    self.commentLabel.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        // TODO: push TagVC
        NSLog(@"push TagVC :%@ hotWord:%d", string, hotWord);
    };
    self.commentLabel.text = self.comment.text;
    
    self.dateLabel.text = [self.comment.createdDate stringWithDefaultFormat];
}

@end
