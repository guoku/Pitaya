//
//  GKEntityCategory.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"

/**
 *  商品分类
 */
@interface GKEntityCategory : GKBaseModel

/**
 *  分类ID
 */
@property (nonatomic, assign) NSUInteger categoryId;

/**
 *  分类状态
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  分类名称
 */
@property (nonatomic, strong) NSString *categoryName;

/**
 *  分类图标URL
 */
@property (nonatomic, strong) NSURL *iconURL;

/**
 *  分类图标URL（小）
 */
@property (nonatomic, strong) NSURL *iconURL_s;

/**
 *  商品数
 */
@property (nonatomic, assign) NSInteger entityCount;

/**
 *  点评数
 */
@property (nonatomic, assign) NSInteger noteCount;

/**
 *  喜爱数
 */
@property (nonatomic, assign) NSInteger likeCount;

@end
