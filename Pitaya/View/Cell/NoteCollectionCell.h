//
//  NoteCollectionCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-2-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCollectionCell : UICollectionViewCell

@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) GKNote *note;

@end
