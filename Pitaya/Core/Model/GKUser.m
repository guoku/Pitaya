//
//  GKUser.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKUser.h"

@implementation GKUser
@synthesize avatarURL = _avatarURL;
@synthesize avatarURL_s = _avatarURL_s;

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"user_id"          : @"userId",
                             @"nickname"         : @"nickname",
                             @"sina_screen_name" : @"sinaScreenName",
                             @"avatar_large"     : @"avatarURL",
                             @"avatar_small"     : @"avatarURL_s",
                             @"verified"         : @"verified",
                             @"verified_type"    : @"verifiedType",
                             @"verified_reason"  : @"verifiedReason",
                             @"gender"           : @"gender",
                             @"bio"              : @"bio",
                             @"following_count"  : @"followingCount",
                             @"fan_count"        : @"fanCount",
                             @"money_i_need"     : @"totalMoney",
                             @"like_count"       : @"likeCount",
                             @"entity_note_count": @"noteCount",
                             @"tag_count"        : @"tagCount",
                             @"same_follow"      : @"sameFollowArray",
                             @"like_statistics"  : @"likeStatisticsDic",
                             @"expert_statistics": @"expertStatisticsDic",
                             @"relation"         : @"relation",
                             @"email"            : @"email",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"userId"];
}

+ (NSArray *)banNames
{
    return @[
             @"likeStatisticsArray",
             @"expertStatisticsArray",
             ];
}


- (void)setAvatarURL:(NSURL *)avatarURL
{
    if ([avatarURL isKindOfClass:[NSURL class]]) {
        _avatarURL = avatarURL;
    } else if ([avatarURL isKindOfClass:[NSString class]]) {
        _avatarURL = [NSURL URLWithString:(NSString *)avatarURL];
    }
}

- (void)setAvatarURL_s:(NSURL *)avatarURL_s
{
    if ([avatarURL_s isKindOfClass:[NSURL class]]) {
        _avatarURL_s = avatarURL_s;
    } else if ([avatarURL_s isKindOfClass:[NSString class]]) {
        _avatarURL_s = [NSURL URLWithString:(NSString *)avatarURL_s];
    }
}

- (NSURL *)avatarURL_s
{
    NSRange range =[[_avatarURL_s absoluteString] rangeOfString:@"avatar/default"];
    if (range.location != NSNotFound) {
        if ([_gender isEqualToString:@"M"]) {
            return [NSURL URLWithString:@"http://guoku.oss-cn-hangzhou.aliyuncs.com/avatar_f.png"];
        }
        if ([_gender isEqualToString:@"F"]) {
            return [NSURL URLWithString:@"http://guoku.oss-cn-hangzhou.aliyuncs.com/avatar_m.png"];
        }
        if ([_gender isEqualToString:@"O"]) {
            return [NSURL URLWithString:@"http://guoku.oss-cn-hangzhou.aliyuncs.com/avatar_o.png"];
        }
    }
    return _avatarURL_s;

}

- (NSURL *)avatarURL
{
    NSRange range =[[_avatarURL absoluteString] rangeOfString:@"avatar/default"];
    if (range.location != NSNotFound) {
        if ([_gender isEqualToString:@"M"]) {
            return [NSURL URLWithString:@"http://guoku.oss-cn-hangzhou.aliyuncs.com/avatar_f%402x.png"];
        }
        if ([_gender isEqualToString:@"F"]) {
            return [NSURL URLWithString:@"http://guoku.oss-cn-hangzhou.aliyuncs.com/avatar_m%402x.png"];
        }
        if ([_gender isEqualToString:@"O"]) {
            return [NSURL URLWithString:@"http://guoku.oss-cn-hangzhou.aliyuncs.com/avatar_o%402x.png"];
        }
    }
    return _avatarURL;

}



@end
