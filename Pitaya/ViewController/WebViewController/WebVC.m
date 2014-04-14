//
//  WebVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-14.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "WebVC.h"

@interface WebVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardBurron;
@property (nonatomic, strong) UIButton *refreshButton;

@end

@implementation WebVC

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if(self) {
        self.url = url;
    }
    
    return self;
}

- (void)updateButtonState
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardBurron.enabled = self.webView.canGoForward;
    
    if (self.webView.isLoading) {
        [self.refreshButton setImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
    } else {
        [self.refreshButton setImage:[UIImage imageNamed:@"button_icon_Refresh"] forState:UIControlStateNormal];
    }
}

#pragma mark - Selector Method

- (void)tapCloseButton
{
    if(self.webView.isLoading){
        [self.webView stopLoading];
    }
    [BBProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapBackButton
{
    [self.webView goBack];
}

- (void)tapForwardBurron
{
    [self.webView goForward];
}

- (void)tapRefreshButton
{
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    } else {
        [self.webView reload];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [BBProgressHUD show];
    [self updateButtonState];
    [self.refreshButton setImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BBProgressHUD dismiss];
    [self updateButtonState];
    [self.refreshButton setImage:[UIImage imageNamed:@"button_icon_Refresh"] forState:UIControlStateNormal];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BBProgressHUD dismiss];
    [self updateButtonState];
    [self.refreshButton setImage:[UIImage imageNamed:@"button_icon_Refresh"] forState:UIControlStateNormal];
}

#pragma mark - Lefe Cycle

- (void)loadView
{
    [super loadView];
    
    _webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    CGRect buttonFrame = CGRectMake(0.f, 0.f, 50.f, 30.f);
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [closeButton setImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(tapCloseButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    
    _backButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.backButton setImage:[UIImage imageNamed:@"button_icon_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(tapBackButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    _forwardBurron = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.forwardBurron setImage:[UIImage imageNamed:@"button_icon_forward"] forState:UIControlStateNormal];
    [self.forwardBurron addTarget:self action:@selector(tapForwardBurron) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *forwardButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.forwardBurron];
    
    _refreshButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [self.refreshButton setImage:[UIImage imageNamed:@"button_icon_Refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(tapRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
    
    self.navigationItem.rightBarButtonItems = @[refreshButtonItem, forwardButtonItem, backButtonItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0.f];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.f];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.f];
    [self.view addConstraints:@[top, bottom, leading, trailing]];

    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
