//
//  GKComment.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKComment.h"
#import "GKUser.h"

@implementation GKComment

+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    NSDictionary *keyDic = @{
                             @"comment_id"           : @"commentId",
                             @"note_id"              : @"noteId",
                             @"entity_id"            : @"entityId",
                             @"creator"              : @"creator",
                             @"content"              : @"text",
                             @"created_time"         : @"createdTime",
                             @"updated_time"         : @"updatedTime",
                             @"reply_to_comment_id"  : @"repliedCommentId",
                             @"reply_to_user"        : @"repliedUser",
                             };
    
    return keyDic;
}

+ (NSArray *)keyNames
{
    return @[@"entityId", @"noteId", @"commentId"];
}

- (void)setCreator:(GKUser *)creator
{
    if ([creator isKindOfClass:[GKUser class]]) {
        _creator = creator;
    } else if ([creator isKindOfClass:[NSDictionary class]]) {
        _creator = [GKUser modelFromDictionary:(NSDictionary *)creator];
    }
}

- (void)setRepliedUser:(GKUser *)repliedUser
{
    if ([repliedUser isKindOfClass:[GKUser class]]) {
        _repliedUser = repliedUser;
    } else if ([repliedUser isKindOfClass:[NSDictionary class]]) {
        _repliedUser = [GKUser modelFromDictionary:(NSDictionary *)repliedUser];
    }
}

- (NSDate *)createdDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.createdTime];
}

@end
