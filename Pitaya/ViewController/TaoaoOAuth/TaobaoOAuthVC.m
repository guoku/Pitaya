//
//  TaobaoOAuthVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "TaobaoOAuthVC.h"

@interface TaobaoOAuthVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation TaobaoOAuthVC

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [BBProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BBProgressHUD dismiss];
    
    if ([webView.request.URL.path isEqualToString:@"/oauth2"]) {
        NSString *urlString = webView.request.URL.absoluteString;
        NSString *queryString = [urlString substringFromIndex:41];
        NSArray *pairArray = [queryString componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
        
        for (NSString *pair in pairArray) {
            NSArray *bits = [pair componentsSeparatedByString:@"="];
            
            NSString *key = [bits.firstObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [bits.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [parameterDict setObject:value forKey:key];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(taobaoAuthorizationDidFinishWithUserInfo:)]) {
            [self.delegate taobaoAuthorizationDidFinishWithUserInfo:parameterDict];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BBProgressHUD dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taobaoAuthorizationDidFailWithError:)]) {
        [self.delegate taobaoAuthorizationDidFailWithError:error];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0.f];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.f];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.f];
    [self.view addConstraints:@[top, bottom, leading, trailing]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://oauth.taobao.com/authorize?response_type=token&client_id=%@&scope=item&view=wap", kTaobaoAppKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
