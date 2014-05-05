//
//  NoteDetailHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteDetailHeaderView.h"
#import "GKAttributedLabel.h"

static CGFloat const kNoteLabelTextFontSize = 15.f;

@interface NoteDetailHeaderView () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) IBOutlet UIButton *categoryButton;
@property (nonatomic, strong) IBOutlet GKAttributedLabel *noteLabel;
@property (nonatomic, strong) IBOutlet UIButton *pokeButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation NoteDetailHeaderView

- (void)setNote:(GKNote *)note
{
    _note = note;
    
    CGSize noteLabelSize = [note.text sizeWithFont:[UIFont systemFontOfSize:kNoteLabelTextFontSize] constrainedToSize:CGSizeMake(CGRectGetWidth(self.noteLabel.bounds), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.deFrameHeight = noteLabelSize.height + 130.f;
    
    [self setNeedsLayout];
}

#pragma mark - Selecotr Method

- (IBAction)tapCategoryButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectCategory:)]) {
        GKEntityCategory *category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(self.note.categoryId)}];
        [self.delegate headerView:self didSelectCategory:category];
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectTag:fromUser:)]) {
        [self.delegate headerView:self didSelectTag:phoneNumber fromUser:self.note.creator];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    GKUser *user = self.note.creator;
    GKNote *note = self.note;
    GKEntity *entity = [GKEntity modelFromDictionary:@{@"entityId":self.note.entityId}];
    GKEntityCategory *category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(entity.categoryId)}];
    
    [self.avatarButton setImageWithURL:user.avatarURL_s forState:UIControlStateNormal];

    self.nicknameLabel.text = user.nickname;
    
    [self.categoryButton setTitle:[NSString stringWithFormat:@"「%@」", [category.categoryName componentsSeparatedByString:@"-"].firstObject] forState:UIControlStateNormal];
    
    self.noteLabel.numberOfLines = 0;
    self.noteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noteLabel.textColor = UIColorFromRGB(0x666666);
    self.noteLabel.font = [GKAttributedLabel fontOfSize:kNoteLabelTextFontSize];
    self.noteLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.noteLabel.minimumLineHeight = 17.f;
    self.noteLabel.plainText = note.text;
    
    [self.pokeButton setTitle:@(self.note.pokeCount).stringValue forState:UIControlStateNormal];
    
    self.dateLabel.text = [note.createdDate stringWithDefaultFormat];
}

@end
