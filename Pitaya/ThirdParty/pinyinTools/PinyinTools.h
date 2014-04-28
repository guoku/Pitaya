//
//  PinyinTools.h
//  IUClient
//
//  Created by bisw on 11-7-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface PinyinTools : NSObject {
@private
    
}

+(BOOL)ifPinyinContains:(NSString *)hanziWord :(NSString *)pinyinInput;

+(BOOL)ifNameString:(NSString *)nameStr SearchString:(NSString *)searchStr;

@end
