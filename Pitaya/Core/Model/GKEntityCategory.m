//
//  GKEntityCategory.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKEntityCategory.h"

@implementation GKEntityCategory

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"category_id"         : @"categoryId",
                             @"category_title"      : @"categoryName",
                             @"category_icon_large" : @"iconURL",
                             @"category_icon_small" : @"iconURL_s",
                             @"status"              : @"status",
                             @"like_count"          : @"likeCount",
                             @"note_count"          : @"noteCount",
                             @"entity_count"        : @"entityCount",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"categoryId"];
}

+ (NSArray *)banNames
{
    return @[
             @"group_id",
             @"category_icon",
             @"title",
             ];
}

@end
