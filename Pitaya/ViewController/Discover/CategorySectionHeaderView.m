//
//  CategorySectionHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-4.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "CategorySectionHeaderView.h"

@interface CategorySectionHeaderView ()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation CategorySectionHeaderView

- (IBAction)tapSegmentControl:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [self.delegate headerView:self didSelectedIndex:self.segmentedControl.selectedSegmentIndex];
    }
}

- (void)setEntityCount:(NSInteger)entityCount noteCount:(NSInteger)noteCount likeCount:(NSInteger)likeCount
{
    NSString *entityTitle = @"商品";
    NSString *noteTitle = @"点评";
    NSString *likeTitle = @"喜爱";
    
    if (entityCount) {
        entityTitle = [NSString stringWithFormat:@"商品 %ld", (long)entityCount];
    }
    if (noteCount) {
        noteTitle = [NSString stringWithFormat:@"点评 %ld", (long)noteCount];
    }
    if (likeCount) {
        likeTitle = [NSString stringWithFormat:@"喜爱 %ld", (long)likeCount];
    }
    
    [self.segmentedControl setTitle:entityTitle forSegmentAtIndex:0];
    [self.segmentedControl setTitle:noteTitle forSegmentAtIndex:1];
    [self.segmentedControl setTitle:likeTitle forSegmentAtIndex:2];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!iOS7) {
        [self.segmentedControl setupFlat];
    }
}

@end
