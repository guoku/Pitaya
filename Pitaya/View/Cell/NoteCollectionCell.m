//
//  NoteCollectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteCollectionCell.h"
#import "GKAttributedLabel.h"

static CGFloat const kNoteCollectionCellTextFontSize = 15.f;

@interface NoteCollectionCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UIButton *nicknameButton;
@property (nonatomic, strong) IBOutlet UIButton *categoryButton;
@property (nonatomic, strong) IBOutlet UIView *entityBackView;
@property (nonatomic, strong) IBOutlet UIImageView *entityImageView;
@property (nonatomic, strong) IBOutlet UILabel *brandLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *likeCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, strong) IBOutlet GKAttributedLabel *noteLabel;
@property (nonatomic, strong) IBOutlet UIButton *pokeButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) UITapGestureRecognizer *entityTapGesture;

@end

@implementation NoteCollectionCell

+ (CGSize)sizeForCellWithNote:(GKNote *)note
{
    CGSize noteLabelSize = [note.text sizeWithFont:[UIFont systemFontOfSize:kNoteCollectionCellTextFontSize] constrainedToSize:CGSizeMake(608.f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    ;
    return CGSizeMake(668.f, noteLabelSize.height + 200.f);
}

#pragma mark - Getter And Setter

- (void)setEntity:(GKEntity *)entity
{
    if (_entity && _note) {
        [self removeObserver];
    }
    
    _entity = entity;
    
    [self addObserver];
    [self setNeedsLayout];
}

- (void)setNote:(GKNote *)note
{
    if (_entity && _note) {
        [self removeObserver];
    }
    
    _note = note;
    
    [self addObserver];
    [self setNeedsLayout];
}

#pragma mark - Selector Method

- (void)tapEntityBackView
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCollectionCell:didSelectEntity:note:)]) {
        [self.delegate noteCollectionCell:self didSelectEntity:self.entity note:self.note];
    }
}

- (IBAction)tapAvatarButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCollectionCell:didSelectUser:)]) {
        [self.delegate noteCollectionCell:self didSelectUser:self.note.creator];
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
    if (_delegate && [_delegate respondsToSelector:@selector(noteCollectionCell:didSelectTag:)]) {
        [self.delegate noteCollectionCell:self didSelectTag:phoneNumber];
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 头像
    [self.avatarButton setImageWithURL:self.note.creator.avatarURL_s forState:UIControlStateNormal];
    
    // 昵称
    [self.nicknameButton setTitle:self.note.creator.nickname forState:UIControlStateNormal];
    
    // 分类
    GKEntityCategory *category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(self.note.categoryId)}];
    NSString *title = [category.categoryName componentsSeparatedByString:@"-"].firstObject;
    [self.categoryButton setTitle:[NSString stringWithFormat:@"「%@」", title] forState:UIControlStateNormal];
    self.categoryButton.tag = category.categoryId;
    
    // 商品点击手势
    if (!self.entityTapGesture) {
        _entityTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEntityBackView)];
        [self.entityBackView addGestureRecognizer:self.entityTapGesture];
    }
    
    // 商品图
    [self.entityImageView setImageWithURL:self.entity.imageURL_240x240];
    
    // 品牌 名称
    if (self.entity.brand.length > 0) {
        self.brandLabel.text = self.entity.brand;
        self.titleLabel.text = self.entity.title;
    } else {
        self.brandLabel.text = self.entity.title;
        self.titleLabel.text = @"";
    }
    
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.entity.lowestPrice];
    
    // 点评内容
    self.noteLabel.numberOfLines = 0;
    self.noteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noteLabel.textColor = UIColorFromRGB(0x666666);
    self.noteLabel.font = [GKAttributedLabel fontOfSize:kNoteCollectionCellTextFontSize];
    self.noteLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.noteLabel.minimumLineHeight = 17.f;
    self.noteLabel.plainText = self.note.text;
    
    // 喜爱数量
    self.likeCountLabel.text = @(self.entity.likeCount).stringValue;
    
    // 评论数量
    self.commentCountLabel.text = @(self.note.commentCount).stringValue;
    
    // 赞
    self.pokeButton.highlighted = self.note.isPoked;
    
    // 点评时间
    self.dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.note.createdTime] stringWithDefaultFormat];
}

#pragma mark - KVO

- (void)addObserver
{
    [self.note addObserver:self forKeyPath:@"poked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"noteCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.note removeObserver:self forKeyPath:@"poked"];
    [self.entity removeObserver:self forKeyPath:@"likeCount"];
    [self.entity removeObserver:self forKeyPath:@"noteCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"poked"]) {
        self.pokeButton.selected = self.note.isPoked;
    } else if ([keyPath isEqualToString:@"likeCount"]) {
        self.likeCountLabel.text = @(self.entity.likeCount).stringValue;
    } else if ([keyPath isEqualToString:@"noteCount"]) {
        self.commentCountLabel.text = @(self.note.commentCount).stringValue;
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
