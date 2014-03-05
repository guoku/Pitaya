//
//  CategorySectionHeaderView.h
//  Pitaya
//
//  Created by 魏哲 on 14-3-4.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategorySectionHeaderView;

@protocol CategorySectionHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(CategorySectionHeaderView *)headerView didSelectedIndex:(NSInteger)index;

@end

@interface CategorySectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<CategorySectionHeaderViewDelegate> delegate;

@end
