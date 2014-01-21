//
//  UIView+App.m
//  Blueberry
//
//  Created by 魏哲 on 13-12-13.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "UIView+App.h"

@implementation UIView (App)

- (UIImage *)imageByRenderingView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (UIImage *)weiboShareImage
{
    return [self weiboShareImageType:1];
}

- (UIImage *)weiboShareImageType:(NSInteger)type
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 640.f, 0.f)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(backView.bounds), 140.f)];
    [backView addSubview:topImageView];
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(backView.bounds), 248.f)];
    bottomImageView.image = [UIImage imageNamed:@"sina_share_bottom"];
    [backView addSubview:bottomImageView];
    
    UIImage *topImage;
    if (type) {
        // 商品/点评
        topImage = [UIImage imageNamed:@"sina_share_top"];
    } else {
        // 用户
        topImage = [UIImage imageNamed:@"sina_share_top_user"];
    }
    topImageView.image = topImage;
    
    [backView addSubview:self];
    self.deFrameTop = topImageView.deFrameBottom;
    bottomImageView.deFrameTop = self.deFrameBottom;
    backView.deFrameHeight = bottomImageView.deFrameBottom;
    
    return [backView imageByRenderingView];
}

@end
