//
//  EntityCollectionCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-25.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "EntityCollectionCell.h"

@interface EntityCollectionCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation EntityCollectionCell

#pragma mark - Getter And Setter

- (void)setEntity:(GKEntity *)entity
{
    if (self.entity) {
        [self removeObserver];
    }
    _entity = entity;
    [self addObserver];
    [self setNeedsLayout];
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = self.imageView.center;
        [self.contentView addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

#pragma mark - Selector Method

- (IBAction)tapLikeButton:(id)sender
{
    if (k_isLogin) {
        [BBProgressHUD show];
        [GKDataManager likeEntityWithEntityId:self.entity.entityId isLike:!self.entity.isLiked success:^(BOOL liked) {
            if (liked) {
                [BBProgressHUD showSuccessWithText:@"喜爱成功"];
            } else {
                [BBProgressHUD dismiss];
            }
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showErrorWithText:@"喜爱失败!"];
        }];
    } else {
        [Passport loginWithSuccessBlock:^{
            [GKDataManager likeEntityWithEntityId:self.entity.entityId isLike:!self.entity.isLiked success:^(BOOL liked) {
                if (liked) {
                    [BBProgressHUD showSuccessWithText:@"喜爱成功"];
                } else {
                    [BBProgressHUD dismiss];
                }
            } failure:^(NSInteger stateCode) {
                [BBProgressHUD showErrorWithText:@"喜爱失败!"];
            }];
        }];
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderColor = UIColorFromRGB(0xF1F1F1).CGColor;
    
    // 商品图
    [self.activityIndicatorView startAnimating];
    __weak __typeof(self)weakSelf = self;
    [self.imageView sd_setImageWithURL:self.entity.imageURL_310x310 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL * imageURL) {
        [weakSelf.activityIndicatorView stopAnimating];
    }];
    
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.entity.lowestPrice];
    
    // 喜爱按钮
    if (self.entity.isLiked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn_highlighted"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateNormal];
    }
    
    NSString *likeButtonTitle = self.entity.likeCount ? [NSString stringWithFormat:@"喜爱 %d", self.entity.likeCount] : @"喜爱";
    [self.likeButton setTitle:likeButtonTitle forState:UIControlStateNormal];
}

#pragma mark - KVO

- (void)addObserver
{
    [self.entity addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.entity addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.entity removeObserver:self forKeyPath:@"liked"];
    [self.entity removeObserver:self forKeyPath:@"likeCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsLayout];
}

- (void)dealloc
{
    [self removeObserver];
}

@end
