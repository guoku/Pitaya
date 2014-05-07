//
//  GKComment.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"
@class GKUser;

/**
 *  评论
 */
@interface GKComment : GKBaseModel

/**
 *  评论ID
 */
@property (nonatomic, assign) NSUInteger commentId;

/**
 *  点评ID
 */
@property (nonatomic, assign) NSUInteger noteId;

/**
 *  商品ID
 */
@property (nonatomic, strong) NSString *entityId;

/**
 *  评论创建者
 */
@property (nonatomic, strong) GKUser *creator;

/**
 *  评论内容
 */
@property (nonatomic, strong) NSString *text;

/**
 *  本评论回复哪条评论
 */
@property (nonatomic, assign) NSUInteger repliedCommentId;

/**
 *  被回复的用户
 */
@property (nonatomic, strong) GKUser *repliedUser;

/**
 *  评论创建时间
 */
@property (nonatomic, assign) NSTimeInterval createdTime;

/**
 *  评论创建时间
 */
@property (nonatomic, weak) NSDate *createdDate;

@end
