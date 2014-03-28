//
//  MessageCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-25.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MessageCell.h"

static CGFloat labelWidth = 600.f;

@interface MessageCell ()

@property (nonatomic, assign) MessageType type;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *photoImageButton;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MessageCell

#pragma mark - Class Method

+ (MessageType)typeFromMessage:(NSDictionary *)message
{
    MessageType type = MessageTypeDefault;
    
    NSString *typeString = message[@"type"];
    if ([typeString isEqualToString:@"note_comment_reply_message"]) {
        type = MessageType_1;
    } else if ([typeString isEqualToString:@"note_comment_message"]) {
        type = MessageType_2;
    } else if ([typeString isEqualToString:@"user_follow"]) {
        type = MessageType_3;
    } else if ([typeString isEqualToString:@"note_poke_message"]) {
        type = MessageType_4;
    } else if ([typeString isEqualToString:@"entity_note_message"]) {
        type = MessageType_5;
    } else if ([typeString isEqualToString:@"entity_like_message"]) {
        type = MessageType_6;
    } else if ([typeString isEqualToString:@"note_selection_message"]) {
        type = MessageType_7;
    }
    
    return type;
}

+ (CGFloat)heightForMessage:(NSDictionary *)message
{
    CGFloat height = 0.f;
    CGSize size = CGSizeZero;
    NSString *string = nil;
    
    MessageType type = [MessageCell typeFromMessage:message];
    
    switch (type) {
        case MessageType_1:
        {
            GKUser    *user    = message[@"content"][@"user"];
            GKComment *comment = message[@"content"][@"replying_comment"];
            
            string = [NSString stringWithFormat:@"%@回复了你的评论", user.nickname];
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            string = comment.text;
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            height += 200.f;
            break;
        }
            
        case MessageType_2:
        {
            GKNote *note = message[@"content"][@"note"];
            GKComment *comment = message[@"content"][@"comment"];
            GKUser * user = comment.creator;
            
            string = [NSString stringWithFormat:@"%@ 评论了你对 %@ 的点评", user.nickname , note.title];
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            string = comment.text;
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            height += 200.f;
            break;
        }
            
        case MessageType_3:
        {
            height = 80.f;
            break;
        }
            
        case MessageType_4:
        {
            GKNote *note = message[@"content"][@"note"];
            GKUser * user = message[@"content"][@"user"];
            string =  [NSString stringWithFormat:@"%@ 赞了你对 %@ 的点评", user.nickname, note.title];
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            height += 60.f;
            break;
        }
            
        case MessageType_5:
        {
            GKEntity *entity = message[@"content"][@"entity"];
            GKNote   *note   = message[@"content"][@"note"];
            GKUser   *user   = note.creator;
            
            string = [NSString stringWithFormat:@"%@ 点评了你推荐的商品", user.nickname];
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            string = note.text;
            size = [string sizeWithFont:[UIFont appFontWithSize:15.f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            height += size.height;
            
            height += 190.f;
            break;
        }
            
        case MessageType_6:
        {
            height = 150.f;
            break;
        }
            
        case MessageType_7:
        {
            height = 180.f;
            break;
        }
            
        default:
        {
            height = 0.f;
            break;
        }
    }
    
    return height;
}

#pragma mark - Selector Method

- (void)tapPhotoImageButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCell:didSelectEntity:)]) {
        GKEntity *entity = self.message[@"content"][@"entity"];
        [self.delegate messageCell:self didSelectEntity:entity];
    }
}

#pragma mark - Setup Cell

- (void)setupCellForType_1
{
    // 评论被回复
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_note"];
    
    GKUser    *user             = self.message[@"content"][@"user"];
    GKComment *replying_comment = self.message[@"content"][@"replying_comment"];
    
    self.label.text = [NSString stringWithFormat:@"%@回复了你的评论", user.nickname];
    [self.label fixText];
    
    self.contentLabel.text = replying_comment.text;
    [self.contentLabel fixText];
    self.contentLabel.deFrameTop = self.label.deFrameBottom + 10.f;
}

- (void)setupCellForType_2
{
    // 点评被评论
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_note"];
    
    GKUser    *user    = self.message[@"content"][@"user"];
    GKNote    *note    = self.message[@"content"][@"note"];
    GKComment *comment = self.message[@"content"][@"comment"];
    
    self.label.text = [NSString stringWithFormat:@"%@ 评论了你对 %@ 的点评", user.nickname, note.title];
    [self.label fixText];
    
    [self.photoImageButton setImageWithURL:note.entityChiefImage forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    
    self.contentLabel.text = comment.text;
    [self.contentLabel fixText];
    self.contentLabel.deFrameTop = self.photoImageButton.deFrameBottom + 10.f;
}

- (void)setupCellForType_3
{
    // 被关注
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_follow"];
    
    GKUser *user = self.message[@"content"][@"user"];
    
    self.label.text = [NSString stringWithFormat:@"%@ 关注了你", user.nickname];
    [self.label fixText];
}

- (void)setupCellForType_4
{
    // 点评被赞
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_poke"];
    
    GKUser *user = self.message[@"content"][@"user"];
    GKNote *note = self.message[@"content"][@"note"];
    
    self.label.text = [NSString stringWithFormat:@"%@ 赞了你对 %@ 的点评", user.nickname, note.title];
    [self.label fixText];
}

- (void)setupCellForType_5
{
    // 商品被点评
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_note"];
    
    GKEntity *entity = self.message[@"content"][@"entity"];
    GKNote   *note   = self.message[@"content"][@"note"];
    GKUser   *user   = note.creator;
    
    self.label.text = [NSString stringWithFormat:@"%@ 点评了你推荐的商品", user.nickname];
    [self.label fixText];
    
    [self.photoImageButton setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    
    self.contentLabel.text = note.text;
    self.contentLabel.deFrameTop = self.photoImageButton.deFrameBottom + 10.f;
    [self.contentLabel fixText];
}

- (void)setupCellForType_6
{
    // 商品被喜爱
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_like"];
    
    GKUser   *user   = self.message[@"content"][@"user"];
    GKEntity *entity = self.message[@"content"][@"entity"];
    
    self.label.text = [NSString stringWithFormat:@"%@ 喜爱了你推荐的商品", user.nickname];
    [self.label fixText];
    
    [self.photoImageButton setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
}

- (void)setupCellForType_7
{
    // 点评入精选
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_selection"];
    
    GKEntity *entity = self.message[@"content"][@"entity"];
    
    self.label.text = @"你添加的商品被收录精选";
    [self.label fixText];
    
    [self.photoImageButton setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
}

#pragma mark - Getter And Setter

- (void)setMessage:(NSDictionary *)message
{
    _message = message;
    
    _type = [MessageCell typeFromMessage:_message];
    
    [self setNeedsLayout];
}

#pragma mark - Life Cycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (UIView *subView in self.contentView.subviews) {
        subView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 15.f, 25.f, 25.f)];
        [self.contentView addSubview:self.iconImageView];
        
        [self.iconImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(65.f, 18.f, labelWidth, 0.f)];
        self.label.font = [UIFont appFontWithSize:15.f];
        self.label.textColor = UIColorFromRGB(0x666666);
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
        
        [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.photoImageButton) {
        _photoImageButton = [[UIButton alloc] initWithFrame:CGRectMake(65.f, 0.f, 100.f, 100.f)];
        [self.photoImageButton addTarget:self action:@selector(tapPhotoImageButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.photoImageButton];
        
        [self.photoImageButton addObserver:self forKeyPath:@"imageView.image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.f, 0.f, labelWidth, 0.f)];
        self.contentLabel.font = [UIFont appFontWithSize:15.f];
        self.contentLabel.textColor = UIColorFromRGB(0x666666);
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!self.timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.f, 0.f, 200.f, 15.f)];
        self.timeLabel.font = [UIFont appFontWithSize:12.f];
        self.timeLabel.textColor = UIColorFromRGB(0x666666);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    switch (self.type) {
        case MessageType_1:
        {
            [self setupCellForType_1];
            break;
        }
            
        case MessageType_2:
        {
            [self setupCellForType_2];
            break;
        }
            
        case MessageType_3:
        {
            [self setupCellForType_3];
            break;
        }
            
        case MessageType_4:
        {
            [self setupCellForType_4];
            break;
        }
            
        case MessageType_5:
        {
            [self setupCellForType_5];
            break;
        }
            
        case MessageType_6:
        {
            [self setupCellForType_6];
            break;
        }
            
        case MessageType_7:
        {
            [self setupCellForType_7];
            break;
        }
            
        default:
            break;
    }
    
    NSTimeInterval timestamp = [self.message[@"time"] doubleValue];
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:timestamp] stringWithDefaultFormat];
    [self.timeLabel fixText];
    self.timeLabel.deFrameBottom = self.contentView.deFrameBottom - 10.f;
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - KVO

- (void)dealloc
{
    [self.label removeObserver:self forKeyPath:@"text"];
    [self.photoImageButton removeObserver:self forKeyPath:@"image"];
    [self.contentLabel removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ((UIView *)object).hidden = NO;
}

@end
