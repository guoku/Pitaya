//
//  NoteCollectionCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-2-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteCollectionCell;

@protocol NoteCollectionCellDelegate <NSObject>

@optional
- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectEntity:(GKEntity *)entity;
- (void)noteCollectionCell:(NoteCollectionCell *)cell didSelectUser:(GKUser *)user;

@end

@interface NoteCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<NoteCollectionCellDelegate> delegate;

@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) GKNote *note;

@end
