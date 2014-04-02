//
//  NoteDetailHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteDetailHeaderView.h"
#import "STTweetLabel.h"

@interface NoteDetailHeaderView ()

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) IBOutlet UIButton *categoryButton;
@property (nonatomic, strong) IBOutlet STTweetLabel *noteLabel;
@property (nonatomic, strong) IBOutlet UIButton *pokeButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation NoteDetailHeaderView

- (void)setNote:(GKNote *)note
{
    _note = note;
    
    self.noteLabel.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        // TODO: push TagVC
        NSLog(@"push TagVC :%@ hotWord:%d", string, hotWord);
    };
    [self.noteLabel setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666), NSFontAttributeName:self.noteLabel.font}];
    [self.noteLabel setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x427EC0), NSFontAttributeName:self.noteLabel.font} hotWord:STTweetHandle];
    [self.noteLabel setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x427EC0), NSFontAttributeName:self.noteLabel.font} hotWord:STTweetHashtag];
    [self.noteLabel setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x427EC0), NSFontAttributeName:self.noteLabel.font} hotWord:STTweetLink];
    CGSize size = [self.noteLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:CGRectGetWidth(self.noteLabel.bounds)];
    self.deFrameHeight = size.height + 160.f;
    
    [self setNeedsLayout];
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
    
    [self.categoryButton setTitle:[NSString stringWithFormat:@"⎡%@⎦", category.categoryName] forState:UIControlStateNormal];
    self.noteLabel.text = note.text;
    
    [self.pokeButton setTitle:@(self.note.pokeCount).stringValue forState:UIControlStateNormal];
    
    self.dateLabel.text = [note.createdDate stringWithDefaultFormat];
}

@end
