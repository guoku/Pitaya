//
//  UserSectionHeaderView.h
//  Pitaya
//
//  Created by 魏哲 on 14-3-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserSectionHeaderView;

@protocol UserSectionHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(UserSectionHeaderView *)headerView didSelectedIndex:(NSInteger)index;
- (void)headerView:(UserSectionHeaderView *)headerView didTapedFanButton:(UIButton *)fanButton;
- (void)headerView:(UserSectionHeaderView *)headerView didTapedFriendButton:(UIButton *)friendButton;

@end

@interface UserSectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<UserSectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) GKUser *user;

@end
