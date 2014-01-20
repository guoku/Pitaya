//
//  Config.h
//  Pitaya
//
//  Created by 魏哲 on 14-1-20.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

// Network
#define kBaseURL @"http://api.guoku.com/mobile/v3/"
//#define kBaseURL @"http://10.0.1.109:8000/mobile/v3/"
//#define kBaseURL @"http://114.113.154.47:8000/mobile/v3/"

#define kApiKey @"0b19c2b93687347e95c6b6f5cc91bb87"
#define kApiSecret @"47b41864d64bd46"

#define kAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#ifndef iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif