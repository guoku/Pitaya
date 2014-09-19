//
//  RecommendEntityCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-13.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "RecommendEntityCell.h"

@interface RecommendEntityCell ()

@property (nonatomic, strong) IBOutlet UIView *backView;

@end

@implementation RecommendEntityCell

- (void)setEntityArray:(NSMutableArray *)entityArray
{
    _entityArray = entityArray;
    
    [self setNeedsLayout];
}

- (void)tapRecommendEntityButton:(UIButton *)button
{
    GKEntity *entity = self.entityArray[button.tag];
    
    if (_delegate && [_delegate respondsToSelector:@selector(recommendEntityCell:didSelectedEntity:)]) {
        [self.delegate recommendEntityCell:self didSelectedEntity:entity];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.backView.subviews.count > 1) {
        return;
    }
    
    for (UIView *subView in self.backView.subviews) {
        if ([subView isKindOfClass:UIButton.class]) {
            [subView removeFromSuperview];
        }
    }
    
    for (NSUInteger i = 0; (i < 6) && i < self.entityArray.count; i++) {
        GKEntity *entity = self.entityArray[i];
        
        CGRect frame;
        frame.origin.x = (i % 3) * (210.f + 19.f);
        frame.origin.y = 35.f + 15.f + (i / 3) * (210.f + 19.f);
        frame.size.width = 210.f;
        frame.size.height = 210.f;
        
        UIButton *entityButton = [[UIButton alloc] initWithFrame:frame];
        entityButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        entityButton.layer.borderColor = UIColorFromRGB(0xF1F1F1).CGColor;
        entityButton.layer.borderWidth = 1.f;
        entityButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        entityButton.adjustsImageWhenHighlighted = NO;
        [entityButton sd_setImageWithURL:entity.imageURL_640x640 forState:UIControlStateNormal];
        entityButton.tag = i;
        [entityButton addTarget:self action:@selector(tapRecommendEntityButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:entityButton];
    }
}

@end
