//
//  UIView+DataTracking.h
//  Blueberry
//
//  Created by 魏哲 on 14-1-14.
//  Copyright (c) 2014年 GuoKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DataTracking)

- (void)findViewControllerAndSaveStateWithEventName:(NSString *)eventName;

@end
