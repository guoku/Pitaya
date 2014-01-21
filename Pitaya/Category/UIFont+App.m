//
//  UIFont+App.m
//  Blueberry
//
//  Created by guoku on 13-9-10.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "UIFont+App.h"

@implementation UIFont (App)

+ (UIFont *)appFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Helvetica" size:size];
}

+ (UIFont *)appFontWithSize:(CGFloat)size bold:(BOOL)bold
{
    if (bold) {
        return [UIFont fontWithName:@"Helvetica-Bold" size:size];
    } else {
        return [UIFont fontWithName:@"Helvetica" size:size];
    }
}

@end
