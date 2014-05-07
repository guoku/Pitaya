//
//  GKRotateLoadingView.h
//  MMM
//
//  Created by huiter on 13-7-10.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKRotateLoadingView : UIView {
    BOOL      _isAnimating;
    NSTimer*  _timer;
    BOOL      _hidesWhenStopped;
    CGFloat   _duration;
}

@property (nonatomic, assign)BOOL hidesWhenStopped;
@property (nonatomic, assign)CGFloat duration;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (id)init;

@end
