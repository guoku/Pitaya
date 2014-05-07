//
//  GKNote.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"
@class GKUser;

/**
 *  点评
 */
@interface GKNote : GKBaseModel

/**
 *  点评ID
 */
@property (nonatomic, assign) NSUInteger noteId;

/**
 *  商品ID
 */
@property (nonatomic, strong) NSString *entityId;

/**
 *  商品主图
 */
@property (nonatomic, strong) NSURL *entityChiefImage;

/**
 *  是否被加精
 */
@property (nonatomic, assign, getter = isMarked) BOOL marked;

/**
 *  点评创建者
 */
@property (nonatomic, strong) GKUser *creator;

/**
 *  点评内容
 */
@property (nonatomic, strong) NSString *text;

/**
 *  用户晒图
 */
@property (nonatomic, strong) NSURL *image;

/**
 *  当前用户对此商品的打分
 */
@property (nonatomic, assign) NSInteger score;

/**
 *  创建者是否喜爱此商品
 */
@property (nonatomic, assign) BOOL creatorLiked;

/**
 *  创建者对此商品的打分
 */
@property (nonatomic, assign) NSUInteger creatorScore;

/**
 *  点评被赞的次数
 */
@property (nonatomic, assign) NSUInteger pokeCount;

/**
 *  点评被评论的次数
 */
@property (nonatomic, assign) NSUInteger commentCount;

/**
 *  点评创建时间
 */
@property (nonatomic, assign) NSTimeInterval createdTime;

/**
 *  点评更新时间
 */
@property (nonatomic, assign) NSTimeInterval updatedTime;

/**
 *  当前用户对此点评是否赞过
 */
@property (nonatomic, assign, getter = isPoked) BOOL poked;

/**
 *  当前用户对此点评是否评论过
 */
@property (nonatomic, assign, getter = isCommented) BOOL commented;

/**
 *  当前用户对此Candidate是否求过链接
 */
@property (nonatomic, assign, getter = isAsked) BOOL asked;

/**
 *  商品创建时间
 */
@property (nonatomic, weak) NSDate *createdDate;

/**
 *  商品更新时间
 */
@property (nonatomic, weak) NSDate *updatedDate;

/**
 *  商品品牌
 */
@property (nonatomic, strong) NSString *brand;

/**
 *  商品标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  分类ID
 */
@property (nonatomic, assign) NSUInteger categoryId;
/**
 *  candidateId
 */
@property (nonatomic, assign) NSUInteger candidateId;
/**
 *  category_text
 */
@property (nonatomic, strong) NSString *categoryName;

@end
