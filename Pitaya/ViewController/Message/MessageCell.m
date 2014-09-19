//
//  MessageCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-25.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MessageCell.h"
#import "RTLabel.h"

static CGFloat labelWidth = 600.f;

@interface MessageCell () <RTLabelDelegate>

@property (nonatomic, assign) MessageType type;

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *photoImageButton;
@property (nonatomic, strong) RTLabel *label;
@property (nonatomic, strong) RTLabel *contentLabel;
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
            
            height += 180.f;
            break;
        }
            
        case MessageType_5:
        {
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
        if (self.type == MessageType_2 || self.type == MessageType_4) {
            GKNote *note = self.message[@"content"][@"note"];
            entity = [GKEntity modelFromDictionary:@{@"entityId":note.entityId}];
        }
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
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14>回复了你的评论</font>", user.userId, user.nickname];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>“ %@ ”</font>", replying_comment.text];
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.label.deFrameBottom + 10.f;
    self.contentLabel.hidden = NO;
}

- (void)setupCellForType_2
{
    // 点评被评论
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_note"];
    
    GKUser    *user    = self.message[@"content"][@"user"];
    GKNote    *note    = self.message[@"content"][@"note"];
    GKComment *comment = self.message[@"content"][@"comment"];
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14>评论了你对 </font><a href='entity:%@'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^777777' size=14> 的点评</font>", user.userId, user.nickname ,note.entityId,note.title];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    [self.photoImageButton sd_setImageWithURL:note.entityChiefImage forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    self.photoImageButton.hidden = NO;
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>“ %@ ”</font>", comment.text];
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.photoImageButton.deFrameBottom + 10.f;
    self.contentLabel.hidden = NO;
}

- (void)setupCellForType_3
{
    // 被关注
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_follow"];
    
    GKUser *user = self.message[@"content"][@"user"];
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14>关注了你</font>", user.userId, user.nickname];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
}

- (void)setupCellForType_4
{
    // 点评被赞
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_poke"];
    
    GKUser *user = self.message[@"content"][@"user"];
    GKNote *note = self.message[@"content"][@"note"];
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14>赞了你对 </font><a href='entity:%@'><font face='Helvetica-Bold' color='^555555' size=14>%@</font></a><font face='Helvetica' color='^777777' size=14> 的点评</font>", user.userId, user.nickname ,note.entityId,note.title];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    [self.photoImageButton sd_setImageWithURL:note.entityChiefImage forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    self.photoImageButton.hidden = NO;
}

- (void)setupCellForType_5
{
    // 商品被点评
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_note"];
    
    GKEntity *entity = self.message[@"content"][@"entity"];
    GKNote   *note   = self.message[@"content"][@"note"];
    GKUser   *user   = note.creator;
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14>点评了你推荐的商品</font>", user.userId, user.nickname];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    [self.photoImageButton sd_setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    self.photoImageButton.hidden = NO;
    
    self.contentLabel.text = [NSString stringWithFormat:@"<font face='Helvetica' color='^777777' size=14>%@</font>", note.text];
    self.contentLabel.deFrameHeight = self.contentLabel.optimumSize.height + 5.f;
    self.contentLabel.deFrameTop = self.photoImageButton.deFrameBottom + 10.f;
    self.contentLabel.hidden = NO;
}

- (void)setupCellForType_6
{
    // 商品被喜爱
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_like"];
    
    GKUser   *user   = self.message[@"content"][@"user"];
    GKEntity *entity = self.message[@"content"][@"entity"];
    
    self.label.text = [NSString stringWithFormat:@"<a href='user:%u'><font face='Helvetica-Bold' color='^555555' size=14>%@ </font></a><font face='Helvetica' color='^777777' size=14>喜爱了你推荐的商品</font>", user.userId, user.nickname];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    [self.photoImageButton sd_setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    self.photoImageButton.hidden = NO;
}

- (void)setupCellForType_7
{
    // 点评入精选
    self.iconImageView.image = [UIImage imageNamed:@"message_icon_selection"];
    
    GKEntity *entity = self.message[@"content"][@"entity"];
    
    self.label.text = [NSString stringWithFormat:@"<font face=\'Helvetica\' color=\'^777777\' size=14>你添加的商品被收录精选</font>"];
    self.label.deFrameHeight = self.label.optimumSize.height + 5.f;
    
    [self.photoImageButton sd_setImageWithURL:entity.imageURL_240x240 forState:UIControlStateNormal];
    self.photoImageButton.deFrameTop = self.label.deFrameBottom + 10.f;
    self.photoImageButton.hidden = NO;
}

#pragma mark - Getter And Setter

- (void)setMessage:(NSDictionary *)message
{
//    [self removeObserver];
    
    _message = message;
    
    _type = [MessageCell typeFromMessage:_message];
    
    [self setNeedsLayout];
}

- (RTLabel *)contentLabel
{
    return _contentLabel;
}

#pragma mark - RTLabelDelegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSArray *array= [url.absoluteString componentsSeparatedByString:@":"];
    NSString *typeString = array.firstObject;
    
    if([typeString isEqualToString:@"user"]) {
        NSUInteger userId = [array.lastObject integerValue];
        GKUser *user = [GKUser modelFromDictionary:@{@"userId":@(userId)}];
        
        if (_delegate && [_delegate respondsToSelector:@selector(messageCell:didSelectUser:)]) {
            [self.delegate messageCell:self didSelectUser:user];
        }
    } else if([typeString isEqualToString:@"entity"]) {
        NSString *entityId = array.lastObject;
        GKEntity *entity = [GKEntity modelFromDictionary:@{@"entityId":entityId}];
        if (_delegate && [_delegate respondsToSelector:@selector(messageCell:didSelectEntity:)]) {
            [self.delegate messageCell:self didSelectEntity:entity];
        }
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.separatorView) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(20.f, 0.f, 1000.f, 1.f)];
        self.separatorView.backgroundColor = UIColorFromRGB(0xF6F6F6);
        [self.contentView addSubview:self.separatorView];
    }
    
    if (!self.iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 15.f, 25.f, 25.f)];
        [self.contentView addSubview:self.iconImageView];
    }
    
    if (!self.label) {
        _label = [[RTLabel alloc] initWithFrame:CGRectMake(65.f, 18.f, labelWidth, 0.f)];
        self.label.paragraphReplacement = @"";
        self.label.lineSpacing = 4.0;
        self.label.delegate = self;
        [self.contentView addSubview:self.label];
    }
    
    if (!self.photoImageButton) {
        _photoImageButton = [[UIButton alloc] initWithFrame:CGRectMake(65.f, 0.f, 100.f, 100.f)];
        self.photoImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.photoImageButton addTarget:self action:@selector(tapPhotoImageButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.photoImageButton];
    }
    
    if (!self.contentLabel) {
        _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(65.f, 0.f, labelWidth, 0.f)];
        self.contentLabel.paragraphReplacement = @"";
        self.contentLabel.lineSpacing = 4.0;
        self.contentLabel.delegate = self;
        [self.contentView addSubview:self.contentLabel];
    }
    
    if (!self.timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.f, 0.f, 200.f, 15.f)];
        self.timeLabel.font = [UIFont appFontWithSize:12.f];
        self.timeLabel.textColor = UIColorFromRGB(0x999999);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
    }
    
    self.photoImageButton.hidden = YES;
    self.contentLabel.hidden = YES;
    
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

//#pragma mark - KVO
//
//- (void)addObserver
//{
//    [self.photoImageButton addObserver:self forKeyPath:@"imageView.image" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//    [self.contentLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//}
//
//- (void)removeObserver
//{
//    [self.photoImageButton removeObserver:self forKeyPath:@"imageView.image"];
//    [self.contentLabel removeObserver:self forKeyPath:@"text"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    ((UIView *)object).hidden = NO;
//}
//
//- (void)dealloc
//{
//    [self removeObserver];
//}

@end
