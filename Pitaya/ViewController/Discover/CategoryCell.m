//
//  CategoryCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

#pragma mark - Getter And Setter

- (void)setCategory:(GKEntityCategory *)category
{
    _category = category;
    
    [self setNeedsLayout];
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setImageWithURL:self.category.iconURL];
    self.titleLabel.text = [self.category.categoryName componentsSeparatedByString:@"-"].firstObject;
}

@end
