//
//  DetailViewController.m
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-6.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Private Method

- (void)makeTabBarHidden:(BOOL)hide
{
    if (!iOS7) {
        for (UIView *contentView in self.view.subviews) {
            if ([contentView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
                CGRect frame = self.view.bounds;
                if (!hide) {
                    frame.size.height -= CGRectGetHeight(self.tabBar.frame);
                }
                contentView.frame = frame;
            }
        }
    }
    
    self.tabBar.hidden = hide;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeTabBarHidden:YES];
    
    self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.view.layer.shadowOpacity = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
