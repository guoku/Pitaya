//
//  UIView+App.h
//  Blueberry
//
//  Created by 魏哲 on 13-12-13.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (App)

- (UIImage *)imageByRenderingView;

- (UIImage *)weiboShareImage;

- (UIImage *)weiboShareImageType:(NSInteger)type;

@end
