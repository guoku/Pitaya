//
//  CategoryCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *verticalCenter;

@end

@implementation CategoryCell

#pragma mark - Getter And Setter

- (void)setCategory:(GKEntityCategory *)category
{
    if (_category != category) {
        _category = category;
        [self setNeedsLayout];
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView sd_setImageWithURL:self.category.iconURL];
    self.titleLabel.text = [self.category.categoryName componentsSeparatedByString:@"-"].firstObject;
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.category.iconURL) {
        self.verticalCenter.priority = 899;
    } else {
        self.verticalCenter.priority = 901;
    }
}

@end
