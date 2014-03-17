//
//  NoteCollectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteCollectionCell.h"

@interface NoteCollectionCell ()

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
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;
@property (nonatomic, strong) IBOutlet UIButton *pokeButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) UITapGestureRecognizer *entityTapGesture;

@end

@implementation NoteCollectionCell

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

#pragma mark - Selector Method

- (void)tapEntityBackView
{
    if (_delegate && [_delegate respondsToSelector:@selector(noteCollectionCell:didSelectEntity:)]) {
        [self.delegate noteCollectionCell:self didSelectEntity:self.entity];
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
    [self.categoryButton setTitle:[NSString stringWithFormat:@"[%@]", category.categoryName] forState:UIControlStateNormal];
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
    self.noteLabel.text = self.note.text;
    
    // 喜爱数量
    self.likeCountLabel.text = @(self.entity.likeCount).stringValue;
    
    // 评论数量
    self.commentCountLabel.text = @(self.note.commentCount).stringValue;
    
    // 赞
    self.pokeButton.highlighted = self.note.isPoked;
    
    // 点评时间
    self.dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.note.createdTime] stringWithDefaultFormat];
}

@end
