//
//  DTNode.h
//  Blueberry
//
//  Created by 魏哲 on 14-1-14.
//  Copyright (c) 2014年 GuoKu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTNode : NSObject

@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *featureName;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *xid;
@property (nonatomic, assign) NSInteger tabIndex;

@property (nonatomic, readonly) NSString *trackString;

- (void)clear;

@end
