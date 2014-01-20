//
//  GKDevice.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-24.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKDevice : NSObject
+ (BOOL)isRetinaScreen;
+ (NSString *)systemVersion;
+ (NSString *)appVersion;
+ (NSString *)appName;
+ (NSString *)platform;
+ (NSString *)modle;
+ (UIDeviceOrientation)Orientation;
+ (NSString *)uuid;
@end
