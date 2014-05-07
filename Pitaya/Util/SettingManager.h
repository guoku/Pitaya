//
//  SettingManager.h
//  Blueberry
//
//  Created by 魏哲 on 13-11-13.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingManager : NSObject


@property (nonatomic, assign) BOOL highQualityImage;
@property (nonatomic, assign) BOOL hidesNote;
@property (nonatomic, assign) BOOL jumpToTaobao;
@property (nonatomic, assign) int  taobaoBanCount;
@property (nonatomic, strong) NSMutableArray * urlBanList;

+ (instancetype)sharedInstance;

@end
