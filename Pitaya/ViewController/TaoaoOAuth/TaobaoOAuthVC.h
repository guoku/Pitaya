//
//  TaobaoOAuthVC.h
//  Pitaya
//
//  Created by 魏哲 on 14-4-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "BaseViewController.h"

@protocol TaobaoOAuthVCDelegate <NSObject>

@optional
- (void)taobaoAuthorizationDidFinishWithUserInfo:(NSDictionary *)userInfo;
- (void)taobaoAuthorizationDidFailWithError:(NSError *)error;
- (void)taobaoAuthorizationDidCancel;

@end

@interface TaobaoOAuthVC : BaseViewController

@property (nonatomic, weak) id<TaobaoOAuthVCDelegate> delegate;

@end
