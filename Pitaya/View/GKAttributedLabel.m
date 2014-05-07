//
//  GKAttributedLabel.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-10.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "GKAttributedLabel.h"

static inline NSRegularExpression * TagRegularExpression() {
    static NSRegularExpression *tagRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tagRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"#\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return tagRegularExpression;
}

@implementation GKAttributedLabel

+ (UIFont *)fontOfSize:(CGFloat)size
{
    if (iOS7) {
        return [UIFont appFontWithSize:size];
    } else {
        return [UIFont fontWithName:@"STHeitiJ-Light" size:size];

    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonConfig];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonConfig];
    }
    return self;
}

- (void)commonConfig
{
    CGColorRef linkTextColor = UIColorFromRGB(0x427EC0).CGColor;
    CGColorRef activeLinkTextColor = linkTextColor;
    CGColorRef activeLinkTextBackgroundFillColor = [UIColor colorWithRed:0.259 green:0.494 blue:0.753 alpha:0.1].CGColor;
    
    self.linkAttributes = @{(NSString *)kCTForegroundColorAttributeName:(__bridge id)linkTextColor};
    self.activeLinkAttributes = @{
                                  (NSString *)kCTForegroundColorAttributeName:(__bridge id)activeLinkTextColor,
                                  (NSString *)kTTTBackgroundFillColorAttributeName:(__bridge id)activeLinkTextBackgroundFillColor,
                                  (NSString *)kTTTBackgroundLineWidthAttributeName:@(0.f),
                                  (NSString *)kTTTBackgroundCornerRadiusAttributeName:@(0.f),
                                  };
}

- (void)setPlainText:(id)plainText
{
    _plainText = plainText;
    self.text = plainText;
    
    __weak __typeof(&*self)weakSelf = self;
    [TagRegularExpression() enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [weakSelf addLinkToPhoneNumber:[weakSelf.text substringWithRange:result.range] withRange:result.range];
    }];
}

@end
