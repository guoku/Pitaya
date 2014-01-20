//
//  GKPurchase.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKPurchase.h"

@implementation GKPurchase

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"shop_nick"    : @"shopName",
                             @"buy_link"     : @"buyLink",
                             @"price"        : @"lowestPrice",
                             @"volume"       : @"volume",
                             };
    
    return keyDic;
}

- (void)setBuyLink:(NSURL *)buyLink
{
    if ([buyLink isKindOfClass:[NSURL class]]) {
        _buyLink = buyLink;
    } else if ([buyLink isKindOfClass:[NSString class]]) {
        _buyLink = [NSURL URLWithString:(NSString *)buyLink];
    }
}

+ (NSArray *)banNames
{
    return @[
             @"entity_id",
             @"cid",
             @"item_id",
             @"taobao_id",
             @"soldout",
             @"source",
             @"title",
             ];
}

@end
