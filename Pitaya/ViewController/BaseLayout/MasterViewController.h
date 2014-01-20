//
//  MasterViewController.h
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-6.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterViewController;

@protocol MasterViewControllerDelegate <NSObject>

@optional
- (void)masterViewController:(MasterViewController *)masterVC didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MasterViewController : UIViewController

@property (nonatomic, weak) id<MasterViewControllerDelegate> delegate;

@end
