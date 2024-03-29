//
//  DiscoverHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-23.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "DiscoverSectionHeaderView.h"

@implementation DiscoverSectionHeaderView

#pragma mark - Getter And Setter

- (void)setGroupDict:(NSDictionary *)groupDict
{
    _groupDict = groupDict;
    
    [self setNeedsLayout];
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.groupDict) {
        self.titleLabel.text = self.groupDict[GroupNameKey];
        self.categoryCountLabel.text = [NSString stringWithFormat:@"%d个品类", [self.groupDict[@"Count"] integerValue]];
    }
}

@end
