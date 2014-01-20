//
//  NSDate+App.m
//  Blueberry
//
//  Created by 魏哲 on 13-10-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "NSDate+App.h"

static NSDateFormatter *dateFormatter;

@implementation NSDate (App)

+ (NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)format
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringWithDefaultFormat
{
    NSTimeInterval minutes = - [self timeIntervalSinceNow] / 60;
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%.0f分钟前", minutes];
    } else if (minutes < 60 * 24) {
        return [NSString stringWithFormat:@"%.0f小时前", minutes / 60];
    } else if (minutes < 60 * 24 * 2) {
        return [NSString stringWithFormat:@"%.0f天前", minutes / 60 / 24];
    } else {
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
        }
        return [dateFormatter stringFromDate:self];
    }
}

@end
