//
//  SelectionLayout.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-27.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SelectionLayout.h"

@implementation SelectionLayout

- (CGFloat)minimumLineSpacing
{
    return 22.f;
}

- (CGFloat)minimumInteritemSpacing
{
    return 22.f;
}

- (CGSize)itemSize
{
    return CGSizeMake(320.f, 435.f);
}

@end
