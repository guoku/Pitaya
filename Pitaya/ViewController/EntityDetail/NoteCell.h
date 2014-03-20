//
//  NoteCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-3-11.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteCell;

@protocol NoteCellDelegate <NSObject>

@optional
- (void)noteCell:(NoteCell *)cell didSelectUser:(GKUser *)user;

@end

@interface NoteCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<NoteCellDelegate> delegate;

@property (nonatomic, strong) GKNote *note;

@end
