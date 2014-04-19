//
//  Config.h
//  Pitaya
//
//  Created by 魏哲 on 14-1-20.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#pragma mark - Network

#define kBaseURL @"http://api.guoku.com/mobile/v3/"
//#define kBaseURL @"http://10.0.1.109:8000/mobile/v3/"
//#define kBaseURL @"http://114.113.154.47:8000/mobile/v3/"

#pragma mark - Vendor

#define kApiKey @"0b19c2b93687347e95c6b6f5cc91bb87"
#define kApiSecret @"47b41864d64bd46"

// Weibo
#ifndef kWeiboAPPKey
#define kWeiboAPPKey @"1459383851"
#endif

#ifndef kWeiboSecret
#define kWeiboSecret @"bfb2e43c3fa636f102b304c485fa2110"
#endif

#ifndef kWeiboRedirectURL
#define kWeiboRedirectURL @"http://www.guoku.com/sina/auth"
#endif

// Taobao
#ifndef kTaobaoAppKey
#define kTaobaoAppKey @"12313170"
#endif

#pragma mark - Helper

// Screen Height
#ifndef kScreenHeight
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

// Screen Width
#ifndef kScreenWidth
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

// Status Bar Height
#ifndef kStatusBarHeight
#define kStatusBarHeight 20.f
#endif

// Navigation Bar Height
#ifndef kNavigationBarHeight
#define kNavigationBarHeight 44.f
#endif

// Tool Bar Height
#ifndef kToolBarHeight
#define kToolBarHeight 44.f
#endif

// Tab Bar Height
#ifndef kTabBarHeight
#define kTabBarHeight 49.f
#endif

#define kAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#ifndef k_isLogin
#define k_isLogin [Passport sharedInstance].user
#endif

#ifndef iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - Setting

// 每次刷新数据个数
#ifndef kRequestSize
#define kRequestSize 30
#endif
