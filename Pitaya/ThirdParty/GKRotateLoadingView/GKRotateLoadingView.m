//
//  GKRotateLoadingView.m
//  MMM
//
//  Created by huiter on 13-7-10.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKRotateLoadingView.h"

@implementation GKRotateLoadingView
{
@private
    UIImageView * one;    
}
@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize duration = _duration;

- (void)setDefaultProperty
{
    _isAnimating = NO;
    _duration = 1.0f;
    _hidesWhenStopped = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultProperty];
        self.backgroundColor = [UIColor clearColor];
        
        one = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading.png"]];
        one.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self addSubview:one];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 15, 15)];
    
    return self;
}

#pragma mark - public
- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    [self repeatAnimation];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration
                                              target:self
                                            selector:@selector(repeatAnimation)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _isAnimating = YES;
    
    self.hidden = NO;
    
}

- (void)stopAnimating
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
    [self reset];
}

- (BOOL)isAnimating
{
    return _isAnimating;
}
- (void)repeatAnimation
{
  /*
    [UIView animateWithDuration:_duration
            animations:^{
                one.transform = CGAffineTransformRotate(one.transform, 3.14/4);
            }];
   */
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = _duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    [one.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
 
}
- (void)reset
{
    
}


@end
