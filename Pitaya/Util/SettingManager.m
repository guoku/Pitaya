//
//  SettingManager.m
//  Blueberry
//
//  Created by 魏哲 on 13-11-13.
//  Copyright (c) 2013年 GuoKu. All rights reserved.
//

#import "SettingManager.h"


/**
 *  跳转到淘宝
 */
#define HighQualityImage @"highQualityImage"
/**
 *  隐藏他人点评
 */
#define HidesNoteKey @"HidesNote"
/**
 *  跳转到淘宝
 */
#define JumpToTaobaoKey @"JumpToTaobao"

/**
 *   组织淘宝JS跳转次数
 */
#define TaobaoBanCountKey @"TaobaoBanCount"

@implementation SettingManager

+ (instancetype)sharedInstance
{
    static SettingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return  sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.highQualityImage = [[[NSUserDefaults standardUserDefaults] objectForKey:HighQualityImage] boolValue];
        self.hidesNote = [[[NSUserDefaults standardUserDefaults] objectForKey:HidesNoteKey] boolValue];
        self.jumpToTaobao = [[[NSUserDefaults standardUserDefaults] objectForKey:JumpToTaobaoKey] boolValue];
        self.taobaoBanCount = [[[NSUserDefaults standardUserDefaults] objectForKey:JumpToTaobaoKey] boolValue];
    }
    return self;
}

- (void)setHidesNote:(BOOL)hidesNote
{
    _hidesNote = hidesNote;
    [[NSUserDefaults standardUserDefaults] setValue:@(self.hidesNote) forKey:HidesNoteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setJumpToTaobao:(BOOL)jumpToTaobao
{
    _jumpToTaobao = jumpToTaobao;
    [[NSUserDefaults standardUserDefaults] setValue:@(self.jumpToTaobao) forKey:JumpToTaobaoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setHighQualityImage:(BOOL)highQualityImage
{
    _highQualityImage = highQualityImage;
    [[NSUserDefaults standardUserDefaults] setValue:@(self.highQualityImage) forKey:HighQualityImage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTaobaoBanCount:(int)taobaoBanCount
{
    _taobaoBanCount = taobaoBanCount;
    [[NSUserDefaults standardUserDefaults] setValue:@(self.taobaoBanCount) forKey:TaobaoBanCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
