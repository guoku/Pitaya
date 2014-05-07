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
@property (nonatomic, strong) IBOutlet UILabel *entityCountLabel;

@end

@implementation TagCollectionCell

- (void)setTagName:(NSString *)tagName
{
    _tagName = tagName;
    
    [self setNeedsLayout];
}

- (void)setEntityCount:(NSInteger)entityCount
{
    _entityCount = entityCount;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tagNameLabel.text = [NSString stringWithFormat:@"#%@", self.tagName];
    
    self.entityCountLabel.text = [NSString stringWithFormat:@"%d件商品", self.entityCount];
}

@end
