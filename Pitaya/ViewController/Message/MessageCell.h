//
//  MessageCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-3-25.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageCell;

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, MessageType) {
    /**
     *  默认类型
     */
    MessageTypeDefault = 0,
    /**
     *  评论被回复
     */
    MessageType_1,
    /**
     *  点评被评论
     */
    MessageType_2,
    /**
     *  被关注
     */
    MessageType_3,
    /**
     *  点评被赞
     */
    MessageType_4,
    /**
     *  商品被点评
     */
    MessageType_5,
    /**
     *  商品被喜爱
     */
    MessageType_6,
    /**
     *  点评入精选
     */
    MessageType_7,
};

@protocol MessageCellDelegate <NSObject>

@optional
- (void)messageCell:(MessageCell *)cell didSelectEntity:(GKEntity *)entity;
- (void)messageCell:(MessageCell *)cell didSelectNote:(GKNote *)note;
- (void)messageCell:(MessageCell *)cell didSelectUser:(GKUser *)user;

@end

@interface MessageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<MessageCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary *message;

+ (CGFloat)heightForMessage:(NSDictionary *)message;
+ (MessageType)typeFromMessage:(NSDictionary *)message;

@end
