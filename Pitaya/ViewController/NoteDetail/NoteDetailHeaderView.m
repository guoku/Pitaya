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
    if (_note) {
        [self removeObserver];
    }
    
    _note = note;
    
    CGSize noteLabelSize = [note.text sizeWithFont:[UIFont systemFontOfSize:kNoteLabelTextFontSize] constrainedToSize:CGSizeMake(CGRectGetWidth(self.noteLabel.bounds), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.deFrameHeight = noteLabelSize.height + 130.f;
    
    [self addObserver];
    [self setNeedsLayout];
}

#pragma mark - Selecotr Method

- (IBAction)tapAvatarButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectUser:)]) {
        [self.delegate headerView:self didSelectUser:self.note.creator];
    }
}

- (IBAction)tapCategoryButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectCategory:)]) {
        GKEntityCategory *category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(self.note.categoryId)}];
        [self.delegate headerView:self didSelectCategory:category];
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

#pragma mark - KVO

- (void)addObserver
{
    [self.note addObserver:self forKeyPath:@"poked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.note addObserver:self forKeyPath:@"pokeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.note removeObserver:self forKeyPath:@"poked"];
    [self.note removeObserver:self forKeyPath:@"pokeCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"poked"]) {
        self.pokeButton.selected = self.note.isPoked;
    } else if ([keyPath isEqualToString:@"pokeCount"]) {
        if (self.note.pokeCount) {
            [self.pokeButton setTitle:@(self.note.pokeCount).stringValue forState:UIControlStateNormal];
        } else {
            [self.pokeButton setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
