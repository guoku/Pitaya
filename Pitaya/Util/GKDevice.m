//
//  GKDevice.m
//  Grape
//
//  Created by 谢 家欣 on 13-4-24.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKDevice.h"
//#import "UIDevice-Hardware.h"

@implementation GKDevice

+ (BOOL)isRetinaScreen
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return YES;
    } else {
        // non-Retina display
        return NO;
    }
}
+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleVersion"];
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary]valueForKeyPath:@"CFBundleDisplayName"];
}

+ (NSString *)platform
{
    return [[UIDevice currentDevice] hardwareDescription];
}

+ (NSString *)modle
{
    return [[UIDevice currentDevice] hwmodel];
}

+ (UIDeviceOrientation)Orientation
{
    return [[UIDevice currentDevice] orientation];
}

+ (NSString *)uuid
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

@end
