//
//  BaseNavigationController.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-20.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *backGesture;

@end

@implementation BaseNavigationController

- (void)backSwape
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwape)];
    self.backGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.backGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
