//
//  CategoryCell.h
//  Pitaya
//
//  Created by 魏哲 on 14-1-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIButton *imageButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

- (IBAction)tap:(UIButton *)button;

@end
