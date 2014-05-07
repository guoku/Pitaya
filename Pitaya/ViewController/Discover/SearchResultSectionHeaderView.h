//
//  SearchResultSectionHeaderView.h
//  Pitaya
//
//  Created by 魏哲 on 14-4-28.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultSectionHeaderView;

@protocol SearchResultSectionHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(SearchResultSectionHeaderView *)headerView didSelectedIndex:(NSInteger)index;

@end

@interface SearchResultSectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<SearchResultSectionHeaderViewDelegate> delegate;

- (void)setEntityCount:(NSInteger)entityCount likeCount:(NSInteger)likeCount;

@end
