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

@end
