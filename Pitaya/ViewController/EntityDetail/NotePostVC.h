//
//  NotePostVC.h
//  Pitaya
//
//  Created by 魏哲 on 14-4-8.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "BaseViewController.h"

@interface NotePostVC : BaseViewController

@property (nonatomic, strong) GKEntity *entity;
@property (nonatomic, strong) GKNote *note;
@property (nonatomic, copy) void (^successBlock)(GKNote *);

@end
