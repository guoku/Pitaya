//
//  GKUser.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"

/**
 *  用户关系类型
 */
typedef NS_ENUM(NSInteger, GKUserRelationType) {
    /**
     *  没有关系
     */
    GKUserRelationTypeNone,
    /**
     *  关注
     */
    GKUserRelationTypeFollowing,
    /**
     *  粉丝
     */
    GKUserRelationTypeFan,
    /**
     *  互相关注
     */
    GKUserRelationTypeBoth,
    /**
     *  自己
     */
    GKUserRelationTypeSelf,
};

/**
 *  用户
 */
@interface GKUser : GKBaseModel

/**
 *  用户ID
 */
@property (nonatomic, assign) NSUInteger userId;

/**
 *  用户昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 *  微博昵称
 */
@property (nonatomic, strong) NSString *sinaScreenName;

/**
 *  用户邮箱
 */
@property (nonatomic, strong) NSString *email;

/**
 *  头像URL
 */
@property (nonatomic, strong) NSURL *avatarURL;

/**
 *  头像URL（小）
 */
@property (nonatomic, strong) NSURL *avatarURL_s;

/**
 *  是否认证
 */
@property (nonatomic, assign, getter = isVerified) BOOL verified;

/**
 *  认证类型
 */
@property (nonatomic, strong) NSString *verifiedType;

/**
 *  认证原因
 */
@property (nonatomic, strong) NSString *verifiedReason;

/**
 *  性别（M:男、F:女、O:未知）
 */
@property (nonatomic, strong) NSString *gender;

/**
 *  用户签名
 */
@property (nonatomic, strong) NSString *bio;

/**
 *  关注数
 */
@property (nonatomic, assign) NSInteger followingCount;

/**
 *  粉丝数
 */
@property (nonatomic, assign) NSInteger fanCount;

/**
 *  买下全部商品需要的money
 */
@property (nonatomic, assign) float totalMoney;

/**
 *  喜爱数
 */
@property (nonatomic, assign) NSInteger likeCount;

/**
 *  点评数
 */
@property (nonatomic, assign) NSInteger noteCount;

/**
 *  标签数
 */
@property (nonatomic, assign) NSInteger tagCount;

/**
 *  共同关注
 */
@property (nonatomic, strong) NSArray *sameFollowArray;

/**
 *  用户每个分类下的喜爱统计 （每个元素字典的结构<categoryId> - <count>）
 */
@property (nonatomic, strong) NSArray *likeStatisticsArray;

/**
 *  用户每个分类下的点评统计 （每个元素字典的结构<categoryId> - <count>）
 */
@property (nonatomic, strong) NSArray *expertStatisticsArray;

/**
 *  当前用户与此用户的关注关系
 */
@property (nonatomic, assign) GKUserRelationType relation;

@end
