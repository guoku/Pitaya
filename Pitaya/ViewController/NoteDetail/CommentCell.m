//
//  CommentCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CommentCell.h"
#import "GKAttributedLabel.h"
#import "TagVC.h"

static CGFloat const kCommentCellTextFontSize = 15.f;

@interface CommentCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) IBOutlet UILabel *replyLabel;
@property (nonatomic, strong) IBOutlet UILabel *replyNicknameLabel;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IBOutlet GKAttributedLabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation CommentCell

+ (CGFloat)heightForCellWithComment:(GKComment *)comment
{
    CGSize contentLabelSize = [comment.text sizeWithFont:[UIFont systemFontOfSize:kCommentCellTextFontSize] constrainedToSize:CGSizeMake(620.f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return contentLabelSize.height + 100.f;
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

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentCell:didSelectTag:fromUser:)]) {
        [self.delegate commentCell:self didSelectTag:phoneNumber fromUser:self.comment.creator];
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    GKUser *user = self.comment.creator;
    
    [self.avatarButton sd_setImageWithURL:user.avatarURL_s forState:UIControlStateNormal];
    
    self.nicknameLabel.text = user.nickname;
    
    if (self.comment.repliedUser) {
        self.replyLabel.hidden = NO;
        self.replyNicknameLabel.text = self.comment.repliedUser.nickname;
    } else {
        self.replyLabel.hidden = YES;
        self.replyNicknameLabel.text = nil;
    }
    
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentLabel.textColor = UIColorFromRGB(0x666666);
    self.commentLabel.font = [GKAttributedLabel fontOfSize:kCommentCellTextFontSize];
    self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.commentLabel.minimumLineHeight = 17.f;
    self.commentLabel.plainText = self.comment.text;
    
    self.dateLabel.text = [self.comment.createdDate stringWithDefaultFormat];
}

@end
