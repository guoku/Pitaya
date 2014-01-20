//
//  GKEntity.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"
@class GKPurchase;
@class GKNote;

/**
 *  商品
 */
@interface GKEntity : GKBaseModel

/**
 *  商品ID
 */
@property (nonatomic, strong) NSString *entityId;

/**
 *  商品Hash
 */
@property (nonatomic, strong) NSString *entityHash;

/**
 *  商品类别ID
 */
@property (nonatomic, assign) NSUInteger categoryId;

/**
 *  商品品牌
 */
@property (nonatomic, strong) NSString *brand;

/**
 *  商品标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  商品介绍
 */
@property (nonatomic, strong) NSString *introduction;

/**
 *  商品主图
 */
@property (nonatomic, strong) NSURL *imageURL;

/**
 *  商品主图（640 * 640）
 */
@property (nonatomic, weak) NSURL *imageURL_640x640;

/**
 *  商品主图（310 * 310）
 */
@property (nonatomic, weak) NSURL *imageURL_310x310;

/**
 *  商品主图（240 * 240）
 */
@property (nonatomic, weak) NSURL *imageURL_240x240;

/**
 *  商品图片数组（多图）
 */
@property (nonatomic, strong) NSArray *imageURLArray;

/**
 *  标记数组（类似tag）
 */
@property (nonatomic, strong) NSArray *remarkArray;

/**
 *  平均打分
 */
@property (nonatomic, assign) float avgScore;

/**
 *  总分数
 */
@property (nonatomic, assign) float totalScore;

/**
 *  总打分人数
 */
@property (nonatomic, assign) NSInteger scoreUserNum;

/**
 *  购买链接数组
 */
@property (nonatomic, strong) NSArray *purchaseArray;

/**
 *  最低价格
 */
@property (nonatomic, assign) float lowestPrice;

/**
 *  当前用户是否喜爱此商品
 */
@property (nonatomic, assign, getter = isLiked) BOOL liked;

/**
 *  当前用户对此商品的打分，没打分为0
 */
@property (nonatomic, assign) NSInteger score;

/**
 *  商品创建时间戳
 */
@property (nonatomic, assign) NSTimeInterval createdTime;

/**
 *  商品更新时间戳
 */
@property (nonatomic, assign) NSTimeInterval updatedTime;

/**
 *  商品创建时间
 */
@property (nonatomic, weak) NSDate *createdDate;

/**
 *  商品更新时间
 */
@property (nonatomic, weak) NSDate *updatedDate;

/**
 *  总喜爱数
 */
@property (nonatomic, assign) NSInteger likeCount;

/**
 *  总点评数
 */
@property (nonatomic, assign) NSInteger noteCount;

/**
 *  商品权重
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  商品标记
 */
@property (nonatomic, strong) NSString *mark;

@end
