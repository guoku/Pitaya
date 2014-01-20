//
//  UILabel+App.m
//  Blueberry
//
//  Created by 魏哲 on 13-9-29.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "UILabel+App.h"

@implementation UILabel (App)

- (void)fixText
{
    CGFloat originWidth = CGRectGetWidth(self.bounds);
    CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(originWidth, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode];
    self.deFrameSize = newSize;
    self.deFrameWidth = originWidth;
}

- (void)fixTextChangeWidth
{
    CGSize newSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode];
    self.deFrameSize = newSize;
}
@end
