//
//  AppDelegate.h
//  Pitaya
//
//  Created by 魏哲 on 14-1-20.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNode.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (nonatomic, strong) DTNode *trackNode;

@end
