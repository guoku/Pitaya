//
//  NSString+App.h
//  Blueberry
//
//  Created by 魏哲 on 13-10-12.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (App)

- (NSString *)md5;

- (NSString *)encodedUrl;

- (BOOL)isValidEmail;

@end
