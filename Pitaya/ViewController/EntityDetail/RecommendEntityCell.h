//
//  RecommendEntityCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-3-13.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendEntityCell;

@protocol RecommendEntityCellDelegate <NSObject>

- (void)recommendEntityCell:(RecommendEntityCell *)cell didSelectedEntity:(GKEntity *)entity;

@end

@interface RecommendEntityCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<RecommendEntityCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *entityArray;

@end
