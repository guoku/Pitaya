//
//  GKPurchase.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseModel.h"

/**
 *  购买链接
 */
@interface GKPurchase : GKBaseModel

/**
 *  店铺名称
 */
@property (nonatomic, strong) NSString *shopName;

/**
 *  购买链接
 */
@property (nonatomic, strong) NSURL *buyLink;

/**
 *  最低价格
 */
@property (nonatomic, assign) float lowestPrice;

/**
 *  最近售出数量
 */
@property (nonatomic, assign) NSInteger volume;

@end
