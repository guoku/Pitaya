//
//  NoteCollectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-2-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteCollectionCell.h"

@implementation NoteCollectionCell

#pragma mark - Getter And Setter

- (void)setEntity:(GKEntity *)entity
{
    _entity = entity;
    
    [self setNeedsLayout];
}

- (void)setNote:(GKNote *)note
{
    _note = note;
    
    [self setNeedsLayout];
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
