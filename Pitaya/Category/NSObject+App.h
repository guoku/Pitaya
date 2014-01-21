//
//  NSObject+App.h
//  Blueberry
//
//  Created by huiter on 13-10-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (App)
/**
 *  从NSUserDefaults中取出model
 *
 *  @param key 存入时使用的key
 *
 *  @return BaseModel实例
 */
+ (id)objectFromUserDefaultsByKey:(NSString *)key;

/**
 *  删除NSUserDefaults中存储的数据
 *
 *  @param key 存入时使用的key
 */
+ (void)removeFromUserDefaultsByKey:(NSString *)key;

/**
 *  将自身存入NSUserDefaults
 *
 *  @param key 存入时使用的key
 */
- (void)saveToUserDefaultsForKey:(NSString *)key;
@end
