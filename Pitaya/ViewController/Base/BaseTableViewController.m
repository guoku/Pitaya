//
//  BaseTableViewController.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-14.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

#pragma mark - Selector Method

- (void)tapBackButton
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!iOS7 && self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 30.f)];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, -22.f, 0.f, 0.f)];
        [backButton setImage:[UIImage imageNamed:@"nav_back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(tapBackButton) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ((BaseNavigationController *)self.navigationController).backGesture.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
