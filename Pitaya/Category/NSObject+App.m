//
//  NSObject+App.m
//  Blueberry
//
//  Created by huiter on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "NSObject+App.h"

@implementation NSObject (App)
/**
 *  从NSUserDefaults中取出model
 *
 *  @param key 存入时使用的key
 *
 *  @return object实例
 */
+ (id)objectFromUserDefaultsByKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return nil;
    }
}

/**
 *  删除NSUserDefaults中存储的数据
 *
 *  @param key 存入时使用的key
 */
+ (void)removeFromUserDefaultsByKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  将自身存入NSUserDefaults
 *
 *  @param key 存入时使用的key
 */
- (void)saveToUserDefaultsForKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
