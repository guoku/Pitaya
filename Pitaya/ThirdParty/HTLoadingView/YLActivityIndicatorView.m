//
//  YLActivityIndicatorView.m
//  YLActivityIndicator
//
//  Created by Eric Yuan on 13-1-15.
//  Copyright (c) 2013年 jimu.tv. All rights reserved.
//

#import "YLActivityIndicatorView.h"

@implementation YLActivityIndicatorView

@synthesize hidesWhenStopped = _hidesWhenStopped;
@synthesize dotCount = _dotCount;
@synthesize duration = _duration;

- (void)setDefaultProperty
{
    _currentStep = 0;
    _dotCount = 9;
    _isAnimating = NO;
    _duration = 0.1f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultProperty];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    return self;
}

#pragma mark - public
- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration
                                              target:self
                                            selector:@selector(repeatAnimation)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self repeatAnimation];
    _isAnimating = YES;
    
    if (_hidesWhenStopped) {
        self.hidden = NO;
    }
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
}

- (BOOL)isAnimating
{
    return _isAnimating;
}

#pragma mark - drawing
- (UIColor*)currentInnerColor:(NSInteger)index
{
    UIColor *color;
    switch (index) {
        case 9:
            color = [UIColor colorWithRed:66.0f / 255.0f green:126.0f / 255.0f blue:192.0 / 255.0f alpha:((0.2+0.2*_currentStep)>1)?((0.2+0.2*_currentStep)-1):(0.2+0.2*_currentStep)];
            break;
        case 7: case 8:
            color = [UIColor colorWithRed:66.0f / 255.0f green:126.0f / 255.0f blue:192.0 / 255.0f alpha:((0.4+0.2*_currentStep)>1)?((0.4+0.2*_currentStep)-1):(0.4+0.2*_currentStep)];
            break;
        case 4: case 5: case 6:
            color = [UIColor colorWithRed:66.0f / 255.0f green:126.0f / 255.0f blue:192.0 / 255.0f alpha:((0.6+0.2*_currentStep)>1)?((0.6+0.2*_currentStep)-1):(0.6+0.2*_currentStep)];
            break;
        case 2: case 3:
            color = [UIColor colorWithRed:66.0f / 255.0f green:126.0f / 255.0f blue:192.0 / 255.0f alpha:((0.8+0.2*_currentStep)>1)?((0.8+0.2*_currentStep)-1):(0.8+0.2*_currentStep)];
            break;
        case 1:
            color = [UIColor colorWithRed:66.0f / 255.0f green:126.0f / 255.0f blue:192.0 / 255.0f alpha:((1+0.2*_currentStep)>1)?((1+0.2*_currentStep)-1):(1+0.2*_currentStep)];
            break;
            
        default:
            break;
    }
    return color;
}

- (CGPoint)currentCenter:(NSInteger)index
{
    CGFloat width = 6;
    CGFloat padding = 2;
    CGFloat halfwidth = width/2;
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    switch (index) {
        case 1:
            point.y = point.y -halfwidth - padding -halfwidth ;
            break;
        case 2: case 3:
            point.y = point.y - halfwidth -padding/2;
            break;
        case 4: case 5: case 6:
            point.y = point.y;
            break;
        case 7: case 8:
            point.y = point.y +halfwidth +padding/2;
            break;
        case 9:
            point.y = point.y +halfwidth +padding+halfwidth;
            break;
            
        default:
            break;
    }
    switch (index) {
        case 4:
            point.x = point.x -halfwidth - padding -halfwidth ;
            break;
        case 2: case 7:
            point.x = point.x -halfwidth - padding/2;
            break;
        case 1: case 5: case 9:
            point.x = point.x ;
            break;
        case 3: case 8:
            point.x = point.x +halfwidth +padding/2;
            break;
        case 6:
            point.x = point.x+halfwidth +padding+halfwidth;
            break;
            
        default:
            break;
    }
    return point;
}

- (void)repeatAnimation
{
    _currentStep = ++_currentStep % 5;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();

   
       
        [[self currentBorderColor:i] setStroke];
         [[self currentInnerColor:i] setFill];
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rect1 = [self currentRect:i];
        CGPathAddRect(path, NULL, rect1);
        
        CGContextBeginPath(context);
        CGContextAddPath(context, path);
        CGContextSetLineWidth(context, 1);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextTranslateCTM(context, self.frame.size.width/_dotCount, 0);
        CGPathRelease(path);
   */
    for (int i = 1; i <= _dotCount; i++) {
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    [[self currentInnerColor:i] setFill];
    CGMutablePathRef path1 = CGPathCreateMutable();
        CGPoint center = [self currentCenter:i];
        CGFloat width = 3;
    CGPathMoveToPoint(path1, NULL, center.x , center.y - width);
    CGPathAddLineToPoint(path1, NULL,center.x + width, center.y);
    CGPathAddLineToPoint(path1, NULL,center.x, center.y + width);
    CGPathAddLineToPoint(path1, NULL,center.x - width, center.y);
    CGPathAddLineToPoint(path1, NULL,center.x, center.y - width);
    CGPathCloseSubpath(path1);
    CGContextAddPath(ctx1, path1);
    CGContextFillPath(ctx1);
    CGPathRelease(path1);
    }   
}

@end
