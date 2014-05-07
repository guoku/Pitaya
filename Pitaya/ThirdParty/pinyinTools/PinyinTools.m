//
//  PinyinTools.m
//  IUClient
//
//  Created by bisw on 11-7-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PinyinTools.h"



@implementation PinyinTools

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(BOOL)ifPinyinContains:(NSString *)hanziWord :(NSString *)pinyinInput
{
    NSString *fullPinyin = @"";
    
    //获取汉字的拼音全拼
    for (NSUInteger i=0; i<[hanziWord length]; i++) {
        fullPinyin = [fullPinyin stringByAppendingFormat:@"%s",getFullPinyinCode([hanziWord characterAtIndex:i])];
    }
    
    //重第一个输入字母计算是否包含
    NSString *input = [pinyinInput lowercaseString];
    for (NSUInteger i=0; i<[input length]; i++)
    {
        if (fullPinyin == nil) {
            return NO;
        }
        
        NSRange currCheck;
        currCheck.location = i;
        currCheck.length = 1;
        
        NSString *currCheckString = [input substringWithRange:currCheck];
        NSRange currRange = [fullPinyin rangeOfString:currCheckString];
        
        if (currRange.location == NSNotFound) 
        {
            return NO;
        }
        
        //从当前包含的位置截取
        fullPinyin = [fullPinyin substringFromIndex:currRange.location];
    }
    
    //全部输入判断完成，返回包含
    return YES;
}

+(BOOL)ifNameString:(NSString *)nameStr SearchString:(NSString *)searchStr{
    
    //DLog(DT_all, @"前 ＝ %@ 后 ＝ %@", [nameStr lowercaseString],[searchStr lowercaseString]);
    //DLog(DT_all, @"searchStr = %@,nameStr = %@ %d %d", searchStr,nameStr,[nameStr hasSuffix:searchStr],[nameStr hasPrefix:searchStr]);
    NSString *name = [nameStr lowercaseString];
    NSString *search = [searchStr lowercaseString];
    
    if ([PinyinTools ifPinyinContains:nameStr :searchStr]) {
        
        return YES;
        
    }
    else{
        
        NSArray *array = [name componentsSeparatedByString:search];
        
        if ([name hasSuffix:search] || [name hasPrefix:search] || [array count] > 1) {
            return YES;
        }
        else{
            return NO;
        }
        
    }
    
}


@end
