//
//  UISegmentedControl+Flat.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-28.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "UISegmentedControl+Flat.h"

@implementation UISegmentedControl (Flat)

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

- (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

- (UIImage *)buttonImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    UIColor *shadowColor = [UIColor clearColor];
    UIEdgeInsets shadowInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIImage *topImage = [self imageWithColor:color cornerRadius:cornerRadius];
    UIImage *bottomImage = [self imageWithColor:shadowColor cornerRadius:cornerRadius];
    CGFloat totalHeight = edgeSizeFromCornerRadius(cornerRadius) + shadowInsets.top + shadowInsets.bottom;
    CGFloat totalWidth = edgeSizeFromCornerRadius(cornerRadius) + shadowInsets.left + shadowInsets.right;
    CGFloat topWidth = edgeSizeFromCornerRadius(cornerRadius);
    CGFloat topHeight = edgeSizeFromCornerRadius(cornerRadius);
    CGRect topRect = CGRectMake(shadowInsets.left, shadowInsets.top, topWidth, topHeight);
    CGRect bottomRect = CGRectMake(0, 0, totalWidth, totalHeight);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(totalWidth, totalHeight), NO, 0.0f);
    if (!CGRectEqualToRect(bottomRect, topRect)) {
        [bottomImage drawInRect:bottomRect];
    }
    [topImage drawInRect:topRect];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIEdgeInsets resizeableInsets = UIEdgeInsetsMake(cornerRadius + shadowInsets.top,
                                                     cornerRadius + shadowInsets.left,
                                                     cornerRadius + shadowInsets.bottom,
                                                     cornerRadius + shadowInsets.right);
    UIGraphicsEndImageContext();
    return [buttonImage resizableImageWithCapInsets:resizeableInsets];
    
}

- (void)setupFlat
{
    UIColor *normalColor = [UIColor whiteColor];
    UIColor *selectedColor = UIColorFromRGB(0x007AFF);
    UIFont *font = [UIFont systemFontOfSize:13.f];
    CGFloat cornerRadius = 4.f;
    
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = selectedColor.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
    UIImage *selectedBackgroundImage = [self buttonImageWithColor:selectedColor cornerRadius:cornerRadius];
    UIImage *deselectedBackgroundImage = [self buttonImageWithColor:normalColor cornerRadius:cornerRadius];
    UIImage *disabledBackgroundImage = [self buttonImageWithColor:normalColor cornerRadius:cornerRadius];
    
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:deselectedBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    
    UIImage *dividerImage = [UIImage imageWithColor:selectedColor];
    [self setDividerImage:dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setDividerImage:dividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setDividerImage:dividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setDividerImage:dividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    NSDictionary *selectedAttributesDictionary = @{
                                                   UITextAttributeTextColor:normalColor,
                                                   UITextAttributeTextShadowColor:[UIColor clearColor],
                                                   UITextAttributeFont:font,
                                                   };
    [self setTitleTextAttributes:selectedAttributesDictionary forState:UIControlStateSelected];
    
    NSDictionary *normalAttributesDictionary = @{
                                                 UITextAttributeTextColor:selectedColor,
                                                 UITextAttributeTextShadowColor:[UIColor clearColor],
                                                 UITextAttributeFont:font,
                                                 };
    [self setTitleTextAttributes:normalAttributesDictionary forState:UIControlStateNormal];
}

@end
