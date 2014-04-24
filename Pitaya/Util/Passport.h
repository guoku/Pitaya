//
//  Passport.h
//  Blueberry
//
//  Created by 魏哲 on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUser.h"
#import "SinaWeibo.h"

// Notification
static NSString *const GKUserWillLoginNotification = @"GKUserWillLoginNotification";
static NSString *const GKUserDidLoginNotification = @"GKUserDidLoginNotification";
static NSString *const GKUserWillLogoutNotification = @"GKUserWillLogoutNotification";
static NSString *const GKUserDidLogoutNotification = @"GKUserDidLogoutNotification";

@interface Passport : NSObject

@property (nonatomic, strong) GKUser *user;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *sinaUserID;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *sinaAvatarURL;
@property (nonatomic, strong) NSString *sinaToken;
@property (nonatomic, strong) NSString *taobaoId;
@property (nonatomic, strong) NSString *taobaoToken;
@property (nonatomic, strong) NSDate *sinaExpirationDate;
@property (nonatomic, strong) SinaWeibo *weiboInstance;

+ (Passport *)sharedInstance;
+ (void)loginWithSuccessBlock:(void (^)())successBlock;
+ (void)logout;

@end
