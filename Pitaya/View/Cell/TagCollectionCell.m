//
//  TagCollectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-20.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "TagCollectionCell.h"

@interface TagCollectionCell ()

@property (nonatomic, strong) IBOutlet UILabel *tagNameLabel;

@end

@implementation TagCollectionCell

- (void)setTagName:(NSString *)tagName
{
    _tagName = tagName;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tagNameLabel.text = [NSString stringWithFormat:@"#%@", self.tagName];
}

@end
