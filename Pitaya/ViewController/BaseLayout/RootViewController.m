//
//  RootViewController.m
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-6.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "RootViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "UserVC.h"
#import "SelectionVC.h"

@interface RootViewController () <MasterViewControllerDelegate>

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *horizontalSpace;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *masterWidth;

@property (nonatomic, strong) MasterViewController *masterVC;
@property (nonatomic, strong) DetailViewController *detailVC;

@end

@implementation RootViewController

#pragma mark - MasterViewControllerDelegate

- (void)masterViewController:(MasterViewController *)masterVC didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseNavigationController *nav = self.detailVC.viewControllers[indexPath.row];
    
    if ([nav.viewControllers.firstObject isKindOfClass:[UserVC class]] && k_isLogin) {
        UserVC *vc = nav.viewControllers.firstObject;
        vc.user = [Passport sharedInstance].user;
    }
    
    if (![nav.viewControllers.firstObject isKindOfClass:[SelectionVC class]]) {
        BOOL isSameVC = (self.detailVC.selectedIndex == (NSUInteger)indexPath.row);
        CGFloat duration = isSameVC ? 0.5f : 0.f;
        [nav popToRootViewControllerAnimated:isSameVC];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BaseViewController *rootVC = (BaseViewController *)nav.viewControllers.firstObject;
            for (UIView *subView in rootVC.view.subviews) {
                if ([subView isKindOfClass:UIScrollView.class]) {
                    if (iOS7) {
                        [((UIScrollView *)subView) setContentOffset:CGPointMake(0.f, -64.f) animated:isSameVC];
                    } else {
                        [((UIScrollView *)subView) setContentOffset:CGPointZero animated:isSameVC];
                    }
                    break;
                }
            }
        });
    }
    
    self.detailVC.selectedIndex = indexPath.row;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.masterVC = self.childViewControllers[0];
    self.masterVC.delegate = self;
    self.detailVC = self.childViewControllers[1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2) {
        // 竖屏 左边栏宽60.f
        CGFloat width = 60.f;
        self.horizontalSpace.constant = width - self.masterWidth.constant;
    } else {
        // 横屏
        self.horizontalSpace.constant = 0.f;
    }
}

@end
