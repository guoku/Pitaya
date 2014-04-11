//
//  CommentCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentCell;

@protocol CommentCellDelegate <NSObject>

@optional
- (void)commentCell:(CommentCell *)cell didSelectUser:(GKUser *)user;
- (void)commentCell:(CommentCell *)cell didSelectTag:(NSString *)tag;
- (void)commentCell:(CommentCell *)cell replyComment:(GKComment *)comment;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<CommentCellDelegate> delegate;

@property (nonatomic, assign) GKComment *comment;

+ (CGFloat)heightForCellWithComment:(GKComment *)comment;

@end
