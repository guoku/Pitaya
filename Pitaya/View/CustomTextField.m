//
//  CustomTextField.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-13.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10.f, 0.f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10.f, 0.f);
}

@end
