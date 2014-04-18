//
//  HomeSectionHeaderView.h
//  Pitaya
//
//  Created by 魏哲 on 14-3-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeSectionHeaderView;

@protocol HomeSectionHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(HomeSectionHeaderView *)headerView didSelectUrl:(NSURL *)url;
- (void)headerView:(HomeSectionHeaderView *)headerView didSelectEntity:(GKEntity *)entity;
- (void)headerView:(HomeSectionHeaderView *)headerView didSelectCategory:(GKEntityCategory *)category;

@end

@interface HomeSectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<HomeSectionHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *hotCategoryArray;

@end
