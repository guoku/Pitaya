//
//  GKDataManager.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-26.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKDataManager.h"
#import "GKAPI.h"

@interface GKDataManager ()

@property (nonatomic, strong) NSArray *categoryGroupArray;
@property (nonatomic, strong) NSArray *fullCategoryGroupArray;
@property (nonatomic, strong) NSArray *allCategoryArray;

@end

@implementation GKDataManager

+ (GKDataManager *)sharedInstance
{
    static GKDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return  sharedInstance;
}

#pragma mark - Network

+ (void)getHomepageWithSuccess:(void (^)(NSArray *bannerArray, NSArray *hotCategoryArray))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getHomepageWithSuccess:^(NSDictionary *settingDict, NSArray *bannerArray, NSArray *hotCategoryArray) {
        
        // 过滤可处理的banner类型
        NSMutableArray *showBannerArray = [NSMutableArray array];
        for (NSDictionary *itemDict in bannerArray) {
            NSString *url = [[itemDict objectForKey:@"url"] lowercaseString];
            if ([url hasPrefix:@"guoku://entity"] ||
                [url hasPrefix:@"guoku://category"] ||
                [url hasPrefix:@"guoku://user"] ||
                [url hasPrefix:@"http://"]) {
                [showBannerArray addObject:itemDict];
            }
        }
        
        if (success) {
            success(showBannerArray, hotCategoryArray);
        }
    } failure:failure];
}

+ (void)getAllCategoryFromNetwork:(BOOL)refresh
                           result:(void (^)(NSArray *categoryGroupArray, NSArray *fullCategoryGroupArray, NSArray *allCategoryArray))result
{
    if (refresh) {
        [GKAPI getAllCategoryWithSuccess:^(NSArray *fullCategoryGroupArray) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableArray *categoryGroupArray = [NSMutableArray array];
                NSMutableArray *allCategoryArray = [NSMutableArray array];
                
                for (NSDictionary *groupDict in fullCategoryGroupArray) {
                    NSArray *categoryArray = groupDict[@"CategoryArray"];
                    
                    NSMutableArray *filteredCategoryArray = [NSMutableArray array];
                    for (GKEntityCategory *category in categoryArray) {
                        [allCategoryArray addObject:category];
                        
                        if (category.status) {
                            [filteredCategoryArray addObject:category];
                        }
                    }
                    NSDictionary *filteredGroupDict = @{@"GroupId"       : groupDict[@"GroupId"],
                                                        @"GroupName"     : groupDict[@"GroupName"],
                                                        @"Status"        : groupDict[@"Status"],
                                                        @"Count"         : @(categoryArray.count),
                                                        @"CategoryArray" : filteredCategoryArray};
                    if ([groupDict[@"Status"] integerValue] > 0) {
                        [categoryGroupArray addObject:filteredGroupDict];
                    }
                }
                [GKDataManager sharedInstance].categoryGroupArray = categoryGroupArray;
                [GKDataManager sharedInstance].fullCategoryGroupArray = fullCategoryGroupArray;
                [GKDataManager sharedInstance].allCategoryArray = allCategoryArray;
                
                [categoryGroupArray saveToUserDefaultsForKey:CategoryGroupArrayWithStatusKey];
                [fullCategoryGroupArray saveToUserDefaultsForKey:CategoryGroupArrayKey];
                [allCategoryArray saveToUserDefaultsForKey:AllCategoryArrayKey];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result) {
                        result(categoryGroupArray, fullCategoryGroupArray, allCategoryArray);
                    }
                });
            });
        } failure:^(NSInteger stateCode) {
            if (result) {
                if (![GKDataManager sharedInstance].categoryGroupArray) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [GKDataManager sharedInstance].categoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayWithStatusKey];
                        [GKDataManager sharedInstance].fullCategoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey];
                        [GKDataManager sharedInstance].allCategoryArray = [NSObject objectFromUserDefaultsByKey:AllCategoryArrayKey];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            result([GKDataManager sharedInstance].categoryGroupArray,
                                   [GKDataManager sharedInstance].fullCategoryGroupArray,
                                   [GKDataManager sharedInstance].allCategoryArray);
                        });
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result([GKDataManager sharedInstance].categoryGroupArray,
                               [GKDataManager sharedInstance].fullCategoryGroupArray,
                               [GKDataManager sharedInstance].allCategoryArray);
                    });
                }
            } else {
                if (![GKDataManager sharedInstance].categoryGroupArray) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [GKDataManager sharedInstance].categoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayWithStatusKey];
                        [GKDataManager sharedInstance].fullCategoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey];
                        [GKDataManager sharedInstance].allCategoryArray = [NSObject objectFromUserDefaultsByKey:AllCategoryArrayKey];
                    });
                }
            }
        }];
    } else {
        if (result) {
            if (![GKDataManager sharedInstance].categoryGroupArray) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [GKDataManager sharedInstance].categoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayWithStatusKey];
                    [GKDataManager sharedInstance].fullCategoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey];
                    [GKDataManager sharedInstance].allCategoryArray = [NSObject objectFromUserDefaultsByKey:AllCategoryArrayKey];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result([GKDataManager sharedInstance].categoryGroupArray,
                               [GKDataManager sharedInstance].fullCategoryGroupArray,
                               [GKDataManager sharedInstance].allCategoryArray);
                    });
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result([GKDataManager sharedInstance].categoryGroupArray,
                           [GKDataManager sharedInstance].fullCategoryGroupArray,
                           [GKDataManager sharedInstance].allCategoryArray);
                });
            }
        } else {
            if (![GKDataManager sharedInstance].categoryGroupArray) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [GKDataManager sharedInstance].categoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayWithStatusKey];
                    [GKDataManager sharedInstance].fullCategoryGroupArray = [NSObject objectFromUserDefaultsByKey:CategoryGroupArrayKey];
                    [GKDataManager sharedInstance].allCategoryArray = [NSObject objectFromUserDefaultsByKey:AllCategoryArrayKey];
                });
            }
        }
    }
}

+ (void)getCategoryStatByCategoryId:(NSUInteger)categoryId
                            success:(void (^)(NSInteger likeCount, NSInteger noteCount, NSInteger entityCount))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getCategoryStatByCategoryId:categoryId success:^(NSInteger likeCount, NSInteger noteCount, NSInteger entityCount) {
        GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(categoryId)}];
        category.entityCount = entityCount;
        category.noteCount = noteCount;
        category.likeCount = likeCount;
        if (success) {
            success(likeCount,noteCount,entityCount);
        }
    } failure:^(NSInteger stateCode) {
        if (failure) {
            failure(stateCode);
        }
    }];
}

+ (void)getEntityListWithCategoryId:(NSUInteger)categoryId
                               sort:(NSString *)sort
                            reverse:(BOOL)reverse
                             offset:(NSInteger)offset
                              count:(NSInteger)count
                            success:(void (^)(NSArray *entityArray))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getEntityListWithCategoryId:categoryId sort:sort reverse:reverse offset:offset count:count success:success failure:failure];
}

+ (void)getLikeEntityListWithCategoryId:(NSUInteger)categoryId
                                 userId:(NSUInteger)userId
                                   sort:(NSString *)sort
                                reverse:(BOOL)reverse
                                 offset:(NSInteger)offset
                                  count:(NSInteger)count
                                success:(void (^)(NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getLikeEntityListWithCategoryId:categoryId userId:userId sort:sort reverse:reverse offset:offset count:count success:success failure:failure];
}

+ (void)getNoteListWithCategoryId:(NSUInteger)categoryId
                             sort:(NSString *)sort
                          reverse:(BOOL)reverse
                           offset:(NSInteger)offset
                            count:(NSInteger)count
                          success:(void (^)(NSArray *dataArray))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getNoteListWithCategoryId:categoryId sort:sort reverse:reverse offset:offset count:count success:success failure:failure];
}

+ (void)getShareListWithCategoryId:(NSUInteger)categoryId
                              sort:(NSString *)sort
                           reverse:(BOOL)reverse
                            offset:(NSInteger)offset
                             count:(NSInteger)count
                           success:(void (^)(NSArray *noteArray))success
                           failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getShareListWithCategoryId:categoryId sort:sort reverse:reverse offset:offset count:count success:success failure:failure];
}

+ (void)getEntityDetailWithEntityId:(NSString *)entityId
                            success:(void (^)(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getEntityDetailWithEntityId:entityId success:success failure:failure];
}

+ (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
                 nickname:(NSString *)nickname
                imageData:(NSData *)imageData
               sinaUserId:(NSString *)sinaUserId
                sinaToken:(NSString *)sinaToken
             taobaoUserId:(NSString *)taobaoUserId
              taobaoToken:(NSString *)taobaoToken
               screenName:(NSString *)screenName
                  success:(void (^)(GKUser *user, NSString *session))success
                  failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    [GKAPI registerWithEmail:email password:password nickname:nickname imageData:imageData sinaUserId:sinaUserId sinaToken:sinaToken taobaoUserId:taobaoUserId taobaoToken:taobaoToken screenName:screenName success:^(GKUser *user, NSString *session) {
        [GKDataManager postDeviceInfoWithSuccess:nil failure:nil];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        
        if (success) {
            success(user, session);
        }
    } failure:failure];
}

+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(GKUser *user, NSString *session))success
               failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    [GKAPI loginWithEmail:email password:password success:^(GKUser *user, NSString *session) {
        [GKDataManager postDeviceInfoWithSuccess:nil failure:nil];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        
        if (success) {
            success(user, session);
        }
    } failure:failure];
}

+ (void)loginWithSinaUserId:(NSString *)sinaUserId
                  sinaToken:(NSString *)sinaToken
                    success:(void (^)(GKUser *user, NSString *session))success
                    failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    [GKAPI loginWithSinaUserId:sinaUserId sinaToken:sinaToken success:^(GKUser *user, NSString *session) {
        [GKDataManager postDeviceInfoWithSuccess:nil failure:nil];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        
        if (success) {
            success(user, session);
        }
    } failure:failure];
}

+ (void)loginWithTaobaoUserId:(NSString *)taobaoUserId
                  taobaoToken:(NSString *)taobaoToken
                      success:(void (^)(GKUser *user, NSString *session))success
                      failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure
{
    [GKAPI loginWithTaobaoUserId:taobaoUserId taobaoToken:taobaoToken success:^(GKUser *user, NSString *session) {
        [GKDataManager postDeviceInfoWithSuccess:nil failure:nil];
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        
        if (success) {
            success(user, session);
        }
    } failure:failure];
}

+ (void)logoutWithSuccess:(void (^)())success
                  failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI logoutWithSuccess:success failure:failure];
}

+ (void)forgetPasswordWithEmail:(NSString *)email
                        success:(void (^)(BOOL success))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI forgetPasswordWithEmail:email success:success failure:failure];
}

+ (void)getUserInfoWithSession:(NSString *)session
                       success:(void (^)(GKUser *user))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserInfoWithSession:session success:^(GKUser *user) {
        [Passport sharedInstance].user = user;
        [Passport sharedInstance].session = session;
        
        if (success) {
            success(user);
        }
    } failure:failure];
}

+ (void)likeEntityWithEntityId:(NSString *)entityId
                        isLike:(BOOL)isLike
                       success:(void (^)(BOOL liked))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI likeEntityWithEntityId:entityId isLike:isLike success:^(BOOL liked) {
        GKEntity *entity = [GKEntity modelFromDictionary:@{@"entityId":entityId}];
        GKEntityCategory * category = [GKEntityCategory modelFromDictionary:@{@"categoryId" : @(entity.categoryId)}];
        if (entity.isLiked != liked) {
            if (liked) {
                [Passport sharedInstance].user.likeCount += 1;
                entity.likeCount +=1;
                category.likeCount +=1;
            } else {
                [Passport sharedInstance].user.likeCount -= 1;
                entity.likeCount -= 1;
                category.likeCount -=1;
            }
            entity.liked = liked;
        }
        
        if (success) {
            success(liked);
        }
    } failure:failure];
}

+ (void)postNoteWithEntityId:(NSString *)entityId
                     content:(NSString *)content
                       score:(NSInteger)score
                   imageData:(NSData *)imageData
                     success:(void (^)(GKNote *note))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI postNoteWithEntityId:entityId content:content score:score imageData:imageData success:success failure:failure];
}

+ (void)updateNoteWithNoteId:(NSUInteger)noteId
                     content:(NSString *)content
                       score:(NSInteger)score
                   imageData:(NSData *)imageData
                     success:(void (^)(GKNote *note))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI updateNoteWithNoteId:noteId content:content score:score imageData:imageData success:success failure:failure];
}

+ (void)deleteNoteByNoteId:(NSUInteger)noteId
                   success:(void (^)())success
                   failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI deleteNoteByNoteId:noteId success:success failure:failure];
}

+ (void)getUserLikeEntityListWithUserId:(NSUInteger)userId
                              timestamp:(NSTimeInterval)timestamp
                                  count:(NSInteger)count
                                success:(void (^)(NSTimeInterval timestamp, NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserLikeEntityListWithUserId:userId timestamp:timestamp count:count success:success failure:failure];
}

+ (void)getUserFollowingListWithUserId:(NSUInteger)userId
                                offset:(NSInteger)offset
                                 count:(NSInteger)count
                               success:(void (^)(NSArray *userArray))success
                               failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserFollowingListWithUserId:userId offset:offset count:count success:success failure:failure];
}

+ (void)getUserFanListWithUserId:(NSUInteger)userId
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                         success:(void (^)(NSArray *userArray))success
                         failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserFanListWithUserId:userId offset:offset count:count success:success failure:failure];
}

+ (void)getUserSinaWeiboFriendListWithSinaIds:(NSArray *)sinaIds
                                      success:(void (^)(NSArray *userArray))success
                                      failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserSinaWeiboFriendListWithSinaIds:sinaIds success:success failure:failure];
}

+ (void)getUserNoteListWithUserId:(NSUInteger)userId
                        timestamp:(NSTimeInterval)timestamp
                            count:(NSInteger)count
                          success:(void (^)(NSArray *dataArray))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserNoteListWithUserId:userId timestamp:timestamp count:count success:success failure:failure];
}

+ (void)getTagListWithUserId:(NSUInteger)userId
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(GKUser *user, NSArray *tagArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getTagListWithUserId:userId offset:offset count:count success:^(GKUser *user, NSArray *tagArray) {
        NSMutableArray *newArray = [NSMutableArray array];
        
        for (NSDictionary *tagDict in tagArray) {
            [newArray addObject:@{
                                  @"tagName"     : tagDict[@"tag"],
                                  @"entityCount" : tagDict[@"entity_count"],
                                  }];
        }
        
        if (success) {
            success (user, newArray);
        }
    } failure:failure];
}

+ (void)getEntityListWithUserId:(NSUInteger)userId
                            tag:(NSString *)tag
                         offset:(NSInteger)offset
                          count:(NSInteger)count
                        success:(void (^)(GKUser *user ,NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getEntityListWithUserId:userId tag:tag offset:offset count:count success:success failure:failure];
}

+ (void)searchEntityWithString:(NSString *)string
                          type:(NSString *)type
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(void (^)(NSDictionary *,NSArray *))success
                       failure:(void (^)(NSInteger))failure
{
    [GKAPI searchEntityWithString:string type:type offset:offset count:count success:success failure:failure];
}

+ (void)searchNoteWithString:(NSString *)string
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *noteArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI searchNoteWithString:string offset:offset count:count success:success failure:failure];
}

+ (void)searchUserWithString:(NSString *)string
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *userArray))success
                     failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI searchUserWithString:string offset:offset count:count success:success failure:failure];
}

+ (void)followUserId:(NSUInteger)userId
               state:(BOOL)state
             success:(void (^)(GKUserRelationType relation))success
             failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI followUserId:userId state:state success:success failure:failure];
}



/**
 *  获取好友动态
 *
 *  @param timestamp 时间戳
 *  @param type      返回的实体类型(entity/candidate)
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getFriendFeedWithTimestamp:(NSTimeInterval)timestamp
                              type:(NSString *)type
                           success:(void (^)(NSArray *dataArray))success
                           failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getFeedWithTimestamp:timestamp type:type scale:@"friend" success:success failure:failure];
}

/**
 *  获取社区动态
 *
 *  @param timestamp 时间戳
 *  @param type      返回的实体类型(entity/candidate)
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getAllFeedWithTimestamp:(NSTimeInterval)timestamp
                           type:(NSString *)type
                        success:(void (^)(NSArray *dataArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getFeedWithTimestamp:timestamp type:type scale:@"all" success:success failure:failure];
}

+ (void)getNoteDetailWithNoteId:(NSUInteger)noteId
                        success:(void (^)(GKNote *note, GKEntity *entity, NSArray *commentArray, NSArray *pokerArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getNoteDetailWithNoteId:noteId success:success failure:failure];
}

+ (void)pokeWithNoteId:(NSUInteger)noteId
                 state:(BOOL)state
               success:(void (^)(NSString *entityId, NSUInteger noteId, BOOL state))success
               failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI pokeWithNoteId:noteId state:state success:^(NSString *entityId, NSUInteger noteId, BOOL state) {
//        GKNote * note = [GKNote modelFromDictionary:@{@"noteId":@(noteId)}];
//        if (note.isPoked != state) {
//            if (state) {
//                note.pokeCount += 1;
//            } else {
//                note.pokeCount -= 1;
//            }
//            note.poked = state;
//        }
        if (success) {
            success(entityId, noteId, state);
        }
    } failure:failure];
}

+ (void)getUserDetailWithUserId:(NSUInteger)userId
                        success:(void (^)(GKUser *user, GKEntity *lastLikeEntity, GKNote *lastNote))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUserDetailWithUserId:userId success:success failure:failure];
}

+ (void)updateUserProfileWithNickname:(NSString *)nickname
                                email:(NSString *)email
                             password:(NSString *)password
                            imageData:(NSData *)imageData
                              success:(void (^)(GKUser *user))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI updateUserProfileWithNickname:nickname email:email password:password imageData:imageData success:^(GKUser *user) {
        [Passport sharedInstance].user = user;
        
        if (success) {
            success(user);
        }
    } failure:failure];
}

+ (void)getNewEntityListWithTimestamp:(NSTimeInterval)timestamp
                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *entityArray))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getNewEntityListWithTimestamp:timestamp cateId:cateId count:count success:success failure:failure];
}

+ (void)postCommentWithNoteId:(NSUInteger)noteId
                      content:(NSString *)content
                      success:(void (^)(GKComment *comment))success
                      failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI postCommentWithNoteId:noteId content:content success:success failure:failure];
}

+ (void)replyCommentWithNoteId:(NSUInteger)noteId
                     commentId:(NSUInteger)commentId
              commentCreatorId:(NSUInteger)commentCreatorId
                       content:(NSString *)content
                       success:(void (^)(GKComment *comment))success
                       failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI replyCommentWithNoteId:noteId commentId:commentId commentCreatorId:commentCreatorId content:content success:success failure:failure];
}

+ (void)deleteCommentByNoteId:(NSUInteger)noteId
                    commentId:(NSUInteger)commentId
                      success:(void (^)())success
                      failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI deleteCommentByNoteId:noteId commentId:commentId success:^() {
        GKNote *note = [GKNote modelFromDictionary:@{@"noteId":@(noteId)}];
        note.commentCount -= 1;
        
        if (success) {
            success();
        }
    } failure:failure];
}

+ (void)getMessageListWithTimestamp:(NSTimeInterval)timestamp
                              count:(NSInteger)count
                            success:(void (^)(NSArray *messageArray))success
                            failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getMessageListWithTimestamp:timestamp count:count success:success failure:failure];
}

+ (void)getSelectionListWithTimestamp:(NSTimeInterval)timestamp
                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *dataArray))success
                              failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getSelectionListWithTimestamp:timestamp cateId:cateId count:count success:success failure:failure];
}

+(void)getHotEntityListWithType:(NSString *)type
                        success:(void (^)(NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getHotEntityListWithType:type success:success failure:failure];
}

+ (void)getRandomEntityListByCategoryId:(NSUInteger)categoryId
                                  count:(NSInteger)count
                                success:(void (^)(NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getRandomEntityListByCategoryId:categoryId count:count success:success failure:failure];
}

+ (void)reportEntityId:(NSString *)entityId
               comment:(NSString *)comment
               success:(void (^)(BOOL success))success
               failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI reportEntityId:entityId comment:comment success:success failure:failure];
}

+ (void)reportNoteId:(NSUInteger)noteId
             comment:(NSString *)comment
             success:(void (^)(BOOL success))success
             failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI reportNoteId:noteId comment:comment success:success failure:failure];
}

+ (void)postDeviceInfoWithSuccess:(void (^)())success
                          failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI postDeviceInfoWithSuccess:success failure:failure];
}
+ (void)getUnreadCountWithSuccess:(void (^)(NSDictionary *dictionary))success
                          failure:(void (^)(NSInteger stateCode))failure
{
    [GKAPI getUnreadCountWithSuccess:success failure:failure];
}

+ (void)cancelAllHTTPOperations
{
    [GKAPI cancelAllHTTPOperations];
}

#pragma mark - Local

@end
