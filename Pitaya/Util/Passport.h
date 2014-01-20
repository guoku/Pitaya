//
//  Passport.h
//  Blueberry
//
//  Created by 魏哲 on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKUser.h"

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

+ (Passport *)sharedInstance;
+ (void)logout;

@end
