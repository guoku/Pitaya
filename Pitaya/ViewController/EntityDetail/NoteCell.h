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
- (void)noteCell:(NoteCell *)cell didSelectTag:(NSString *)tag fromUser:(GKUser *)user;
- (void)noteCell:(NoteCell *)cell tapPokeButton:(UIButton *)pokeButton;
- (void)noteCell:(NoteCell *)cell tapCommentButton:(UIButton *)noteButton;

@end

@interface NoteCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<NoteCellDelegate> delegate;

@property (nonatomic, strong) GKNote *note;

+ (CGFloat)heightForCellWithNote:(GKNote *)note;

@end
