//
//  NSDate+App.h
//  Blueberry
//
//  Created by 魏哲 on 13-10-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDateFormat_mm_dd_HH_mm @"MM-dd HH:mm"
#define kDateFormat_yyyy_mm_dd_HH_mm @"YYYY-MM-dd HH:mm"
#define kDateFormat_yyyy_mm_dd @"YYYY-MM-dd"
#define kDateFormat_mm_dd @"MM-dd"
#define kDateFormat_mm_dd_SimpleChinese @"MM月dd日"

@interface NSDate (App)

+ (NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)format;

- (NSString *)stringWithFormat:(NSString *)format;

- (NSString *)stringWithDefaultFormat;

@end
