//
//  GKEntity+ImageURLFixes.m
//  Blueberry
//
//  Created by 魏哲 on 13-12-9.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "GKEntity+ImageURLFixes.h"
#import <objc/runtime.h>

@implementation GKEntity (ImageURLFixes)

+ (void)load
{
    Method m1 = class_getInstanceMethod(self, @selector(setImageURL:));
    Method m2 = class_getInstanceMethod(self, @selector(setOriginImageURL:));
    method_exchangeImplementations(m1, m2);
}

// 处理原图已经带有"310x310.jpg"的URL
- (void)setOriginImageURL:(NSURL *)originImageURL
{
    [self setOriginImageURL:originImageURL];
    
    NSString *urlString = self.imageURL.absoluteString;
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".([0-9]+)x([0-9]+).jpg" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *originImageURLString = [urlString substringToIndex:(urlString.length - rangeOfFirstMatch.length)];
        [self setOriginImageURL:[NSURL URLWithString:originImageURLString]];
    }
}

@end
