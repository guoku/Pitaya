//
//  UserListVC.h
//  Pitaya
//
//  Created by 魏哲 on 14-5-3.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, UserListType) {
    UserListTypeFans,
    UserListTypeFriends,
};

@interface UserListVC : BaseViewController

@property (nonatomic, strong) GKUser *user;
@property (nonatomic, assign) UserListType type ;

@end
