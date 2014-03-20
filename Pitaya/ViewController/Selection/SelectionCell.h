//
//  SelectionCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-2-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectionCell;

@protocol SelectionCellDelegate <NSObject>

@optional
- (void)selectionCell:(SelectionCell *)cell didSelectUser:(GKUser *)user;

@end

@interface SelectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet id<SelectionCellDelegate> delegate;

@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) GKNote *note;
@property (nonatomic, strong) NSDate *date;

@end
