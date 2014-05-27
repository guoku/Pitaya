//
//  NoteDetailHeaderView.h
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteDetailHeaderView;

@protocol NoteDetailHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(NoteDetailHeaderView *)headerView didSelectUser:(GKUser *)user;
- (void)headerView:(NoteDetailHeaderView *)headerView didSelectTag:(NSString *)tag fromUser:(GKUser *)user;
- (void)headerView:(NoteDetailHeaderView *)headerView didSelectCategory:(GKEntityCategory *)category;

@end

@interface NoteDetailHeaderView : UIView

@property (nonatomic, weak) IBOutlet id<NoteDetailHeaderViewDelegate> delegate;

@property (nonatomic, strong) GKNote *note;

@end
