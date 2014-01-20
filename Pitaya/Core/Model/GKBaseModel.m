//
//  GKBaseModel.m
//
//  Created by 魏哲 on 13-9-11.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "GKBaseModel.h"
#import <objc/runtime.h>

/**
 *  基本数据模型
 */
@implementation GKBaseModel

/**
 *  使用Dictionary来获取一个Model对象
 *
 *  @param dictionary 包含Model对象<属性名> - <值>的字典。
 *
 *  @return Model对象
 */
+ (instancetype)modelFromDictionary:(NSDictionary *)dictionary
{
    GKBaseModel *model;
    NSArray *keyNameArray = [self keyNames];
    if (keyNameArray && keyNameArray.count > 0) {
        NSMutableArray *dictKeyArray = [[NSMutableArray alloc] init];
        
        for (NSString *keyName in keyNameArray) {
            if (![dictionary valueForKey:keyName]) {
                NSArray *keys = [[[self class] dictionaryForServerAndClientKeys] allKeysForObject:keyName];
                NSString *serverKeyName = keys.firstObject;
                if (serverKeyName) {
                    [dictKeyArray addObject:serverKeyName];
                } else {
                    #ifdef DDLogError
                        DDLogWarn(@"%@ 属性对照表没有 %@", [self class], keyName);
                    #endif
                }
            } else {
                [dictKeyArray addObject:keyName];
            }
        }
        
        NSMutableString *centerKey = [[NSMutableString alloc] initWithString:NSStringFromClass([self class])];
        
        [keyNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *keyName = obj;
            [centerKey appendString:[NSString stringWithFormat:@".%@.%@", keyName, [dictionary valueForKey:dictKeyArray[idx]]]];
        }];
        
        model = [[GKBaseModelCenter sharedInstance].modelDictionary valueForKey:centerKey];
        if (model) {
            [model setValuesForKeysWithDictionary:dictionary];
        } else {
            model = [[[self class] alloc] initWithDictionary:dictionary];
            [model saveToCenter];
        }
    } else {
        model = [[[self class] alloc] initWithDictionary:dictionary];
    }
    return model;
}

/**
 *  使用Model对象来获取一个Dictionary
 *
 *  @param model Model对象。
 *
 *  @return 包含Model对象<属性名> - <值>的字典
 */
+ (NSDictionary *)dictionaryFromModel:(GKBaseModel *)model
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            [mutableDic setValue:[model valueForKey:propertyName] forKey:propertyName];
        }
    }
    free(properties);
    return mutableDic;
}

/**
 *  需要具体的Model子类来覆写，可以实现使用服务器端的字段名来进行赋值操作。
 *
 *  @return 获取包含<服务器字段名> - <Model属性名>的字典
 */
+ (NSDictionary *)dictionaryForServerAndClientKeys
{
    #ifdef DDLogError
        DDLogError(@"%@ 没有实现 %@ 方法，不能使用服务器端的属性名对Model进行赋值。", NSStringFromClass([self class]), THIS_METHOD);
    #endif
    return nil;
}

/**
 *  需要具体的Model子类来覆写，确定该类的主键属性名，用来实现Model的KVO。
 *
 *  @return 该类的主键属性名数组
 */
+ (NSArray *)keyNames
{
    #ifdef DDLogError
        DDLogError(@"%@ 没有覆写 %@ 方法，不能使用KVO。", NSStringFromClass([self class]), THIS_METHOD);
    #endif
    return nil;
}

/**
 *  需要具体的Model子类来覆写，确定该类要忽略的属性名。
 *
 *  @return 该类要忽略的属性名数组
 */
+ (NSArray *)banNames
{
    return nil;
}

/**
 *  通过服务端的字段名来获取Model的属性名，如果找不到则返回nil。
 *
 *  @param serverKey 服务端的字段名
 *
 *  @return Model的属性名
 */
+ (NSString *)clientKeyFromServerKey:(NSString *)serverKey
{
    __block NSString *clientKey = nil;
    NSDictionary *dic = [[self class] dictionaryForServerAndClientKeys];
    NSString *tempKey = [dic valueForKey:serverKey];
    if (tempKey) {
        clientKey = tempKey;
    } else {
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isEqualToString:serverKey]) {
                clientKey = serverKey;
            }
        }];
    }
    
    return clientKey;
}

/**
 *  使用Dictionary来获取一个Model对象
 *
 *  @param dictionary 包含Model对象<属性名> - <值>的字典。
 *
 *  @return Model对象
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

/**
 *  将model存储到Center中，用来实现KVO。
 */
- (void)saveToCenter
{
    NSArray *subKeyArray = [[self class] keyNames];
    if (subKeyArray && subKeyArray.count > 0) {
        NSMutableString *centerKey = [[NSMutableString alloc] initWithString:NSStringFromClass([self class])];
        for (NSString *subKey in subKeyArray) {
            [centerKey appendString:[NSString stringWithFormat:@".%@.%@", subKey, [self valueForKey:subKey]]];
        }
        __weak __typeof (&*self)weakSelf = self;
        [[GKBaseModelCenter sharedInstance].modelDictionary setValue:weakSelf forKey:centerKey];
    } else {
        #ifdef DDLogError
        DDLogWarn(@"%@ 没有成功存储到Center!\n%@", NSStringFromClass([self class]), [[self class] dictionaryFromModel:self]);
        #endif
    }
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSString *clientKey = [[self class] clientKeyFromServerKey:key];
    
    NSString *selString = [NSString stringWithFormat:@"is%@%@", [[clientKey substringToIndex:1] uppercaseString], [clientKey substringFromIndex:1]];
    
    // 这里需要判断为is开头的属性名，比如liked需要判断isLiked。如果都不存在，则说明该类没有此属性。
    if (clientKey && ([self respondsToSelector:NSSelectorFromString(clientKey)] || [self respondsToSelector:NSSelectorFromString(selString)])) {
        if (value) {
            [super setValue:value forKey:clientKey];
        }
    } else {
        if (![[[self class] banNames] containsObject:key]) {
            #ifdef DDLogWarn
            DDLogWarn(@"%@ 没有 %@ 属性", NSStringFromClass([self class]), key);
            #endif
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            [coder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        
        for(i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName) {
                NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
                [self setValue:[decoder decodeObjectForKey:propertyName] forKey:propertyName];
            }
        }
        free(properties);
    }
    
    NSArray *keyNameArray = [[self class] keyNames];
    if (keyNameArray && keyNameArray.count > 0) {
        NSMutableString *centerKey = [[NSMutableString alloc] initWithString:NSStringFromClass([self class])];
        
        [keyNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *keyName = obj;
            [centerKey appendString:[NSString stringWithFormat:@".%@.%@", keyName, [self valueForKey:keyNameArray[idx]]]];
        }];
        
        GKBaseModel *model = [[GKBaseModelCenter sharedInstance].modelDictionary valueForKey:centerKey];
        if (model) {
            return model;
        } else {
            [[GKBaseModelCenter sharedInstance].modelDictionary setObject:self forKey:centerKey];
        }
    }
    
    return self;
}

@end

#pragma mark - GKBaseModelCenter Class

/**
 *  全局的ModelCenter，用来存储model，实现KVO。
 */
@implementation GKBaseModelCenter

/**
 *  获取GKBaseModelCenter单例
 *
 *  @return GKBaseModelCenter单例
 */
+ (GKBaseModelCenter *)sharedInstance
{
    static GKBaseModelCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return  sharedInstance;
}

/**
 *  初始化GKBaseModelCenter
 *
 *  @return GKBaseModelCenter
 */
- (id)init
{
    self = [super init];
    if (self) {
        _modelDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
