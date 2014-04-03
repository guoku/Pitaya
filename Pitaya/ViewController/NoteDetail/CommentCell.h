//
//  CommentCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic, assign) GKComment *comment;

+ (CGFloat)heightForComment:(GKComment *)comment;

@end
