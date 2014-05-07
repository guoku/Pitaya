//
//  GKBaseHTTPClient.m
//  GKCoreCommon
//
//  Created by 魏哲 on 13-11-25.
//  Copyright (c) 2013年 Guoku. All rights reserved.
//

#import "GKBaseHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation GKBaseHTTPClient

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSParameterAssert(path);
    NSParameterAssert(method);
    
    if ([method isEqualToString:@"GET"]) {
        [self getPath:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"POST"]) {
        [self postPath:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"PUT"]) {
        [self putPath:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"DELETE"]) {
        [self deletePath:path parameters:parameters success:success failure:failure];
    } else if ([method isEqualToString:@"PATCH"]) {
        [self patchPath:path parameters:parameters success:success failure:failure];
    }
}

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
     dataParameters:(NSDictionary *)dataParameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSParameterAssert(path);
    NSParameterAssert(method);
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [dataParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [formData appendPartWithFileData:obj name:key fileName:@"fileName" mimeType:@""];
        }];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [responseString objectFromJSONString];
        if (success) {
            success(operation, responseDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

@end
