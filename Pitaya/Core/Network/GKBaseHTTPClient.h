//
//  GKBaseHTTPClient.h
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "AFHTTPClient.h"

@interface GKBaseHTTPClient : AFHTTPClient

/**
 *  发起网络请求
 *
 *  @param path       请求接口URI
 *  @param method     请求类型(GET/POST)
 *  @param parameters API参数字典
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发起网络请求(带二进制数据)
 *
 *  @param path           请求接口URI
 *  @param method         请求类型(GET/POST)
 *  @param parameters     API参数字典
 *  @param dataParameters Data参数字典
 *  @param success        成功block
 *  @param failure        失败block
 */
- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
     dataParameters:(NSDictionary *)dataParameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
