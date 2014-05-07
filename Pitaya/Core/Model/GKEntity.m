//
//  GKEntity.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKEntity.h"
#import "GKPurchase.h"
#import "GKNote.h"

@implementation GKEntity

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"entity_id"        : @"entityId",
                             @"entity_hash"      : @"entityHash",
                             @"category_id"      : @"categoryId",
                             @"brand"            : @"brand",
                             @"title"            : @"title",
                             @"intro"            : @"introduction",
                             @"chief_image"      : @"imageURL",
                             @"detail_images"    : @"imageURLArray",
                             @"remark_list"      : @"remarkArray",
                             @"avg_score"        : @"avgScore",
                             @"total_score"      : @"totalScore",
                             @"score_count"      : @"scoreUserNum",
                             @"item_list"        : @"purchaseArray",
                             @"price"            : @"lowestPrice",
                             @"like_already"     : @"liked",
                             @"score_already"    : @"score",
                             @"created_time"     : @"createdTime",
                             @"updated_time"     : @"updatedTime",
                             @"like_count"       : @"likeCount",
                             @"note_count"       : @"noteCount",
                             @"status"           : @"status",
                             @"mark"             : @"mark"
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"entityId"];
}

+ (NSArray *)banNames
{
    return @[
             @"item_id_list",
             @"note_id_list",
             @"weight",
             @"old_category_id",
             @"creator_id",
             ];
}

- (void)setImageURL:(NSURL *)imageURL
{
    if ([imageURL isKindOfClass:[NSURL class]]) {
        _imageURL = imageURL;
    } else if ([imageURL isKindOfClass:[NSString class]]) {
        _imageURL = [NSURL URLWithString:(NSString *)imageURL];
    }
}

- (void)setImageURLArray:(NSArray *)imageURLArray
{
    id obj = imageURLArray.firstObject;
    
    if ([obj isKindOfClass:[NSURL class]]) {
        _imageURLArray = imageURLArray;
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSMutableArray *urlArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in imageURLArray) {
            if ([urlString isEqual:[NSNull null]]) {
                
            }
            else
            {
                NSURL *imageURL = [NSURL URLWithString:urlString];
                [urlArray addObject:imageURL];
            }
        }
        _imageURLArray = urlArray;
    }
}

- (void)setPurchaseArray:(NSArray *)purchaseArray
{
    id obj = purchaseArray.firstObject;
    
    if ([obj isKindOfClass:[GKPurchase class]]) {
        _purchaseArray = purchaseArray;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *purchaseModelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *purchaseDict in purchaseArray) {
            GKPurchase *purchase = [[GKPurchase alloc] initWithDictionary:purchaseDict];
            [purchaseModelArray addObject:purchase];
        }
        _purchaseArray = purchaseModelArray;
    }
}

- (NSDate *)createdDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.createdTime];
}

- (NSDate *)updatedDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.updatedTime];
}

- (NSURL *)imageURL_640x640
{
    return [NSURL URLWithString:[self.imageURL.absoluteString stringByAppendingString:@"_640x640.jpg"]];
}

- (NSURL *)imageURL_240x240
{
    return [NSURL URLWithString:[self.imageURL.absoluteString stringByAppendingString:@"_240x240.jpg"]];
}

- (NSURL *)imageURL_310x310
{
    return [NSURL URLWithString:[self.imageURL.absoluteString stringByAppendingString:@"_310x310.jpg"]];
}

@end
