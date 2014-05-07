//
//  UIView+DataTracking.m
//  Blueberry
//
//  Created by 魏哲 on 14-1-14.
//  Copyright (c) 2014年 GuoKu. All rights reserved.
//

#import "UIView+DataTracking.h"

@implementation UIView (DataTracking)

- (void)findViewControllerAndSaveStateWithEventName:(NSString *)eventName
{
    
    UIResponder *nextResponder = self.superview;
    while (nextResponder) {
        if ([nextResponder isKindOfClass:[BaseViewController class]]) {
            break;
        } else {
            nextResponder = nextResponder.nextResponder;
        }
    }
    
    if (nextResponder) {
        BaseViewController *vc = (BaseViewController *)nextResponder;
        if ([vc respondsToSelector:@selector(saveStateWithEventName:)]) {
            [vc saveStateWithEventName:eventName];
        }
    }
}

@end
