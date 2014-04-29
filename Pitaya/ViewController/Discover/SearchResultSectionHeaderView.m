//
//  SearchResultSectionHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-28.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "SearchResultSectionHeaderView.h"

@interface SearchResultSectionHeaderView ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation SearchResultSectionHeaderView

- (IBAction)tapSegmentControl:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [self.delegate headerView:self didSelectedIndex:self.segmentedControl.selectedSegmentIndex];
    }
}

- (void)setEntityCount:(NSInteger)entityCount likeCount:(NSInteger)likeCount
{
    NSString *entityTitle = @"所有";
    NSString *likeTitle = @"喜爱";
    
    if (entityCount) {
        entityTitle = [NSString stringWithFormat:@"所有 %ld", (long)entityCount];
    }
    if (likeCount) {
        likeTitle = [NSString stringWithFormat:@"喜爱 %ld", (long)likeCount];
    }
    
    [self.segmentedControl setTitle:entityTitle forSegmentAtIndex:0];
    [self.segmentedControl setTitle:likeTitle forSegmentAtIndex:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!iOS7) {
        [self.segmentedControl setupFlat];
    }
}

@end
