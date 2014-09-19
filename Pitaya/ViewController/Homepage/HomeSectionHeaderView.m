//
//  HomeSectionHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-21.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "HomeSectionHeaderView.h"
#import "iCarousel.h"

#define kHotCategoryButtonTag 100

@interface HomeSectionHeaderView () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *banner;
@property (nonatomic, strong) IBOutlet UIView *hotCategoryView;
@property (nonatomic, strong) UIButton *allCategoryButton;

@end

@implementation HomeSectionHeaderView

- (void)setBannerArray:(NSMutableArray *)bannerArray
{
    _bannerArray = bannerArray;
    [self.banner reloadData];
    [self setNeedsLayout];
}

- (void)setHotCategoryArray:(NSMutableArray *)hotCategoryArray
{
    _hotCategoryArray = hotCategoryArray;
    [self.hotCategoryView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *hotCategoryButton = (UIButton *)[self viewWithTag:kHotCategoryButtonTag + idx];
        [hotCategoryButton removeFromSuperview];
    }];
    
    [self.hotCategoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < 9) {
            CGRect frame;
            frame.origin.x = (110.f + 28.f) * (idx % 5);
            frame.origin.y = (110.f + 28.f) * (idx / 5);
            frame.size = CGSizeMake(110.f, 110.f);
            
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            button.backgroundColor = UIColorFromRGB(0xF8F8F8);
            button.imageEdgeInsets = UIEdgeInsetsMake(20.f, 32.5f, 45.f, 32.5f);
            button.titleEdgeInsets = UIEdgeInsetsMake(80.f, -87.5f, 10.f, 0.f);
            button.tag = kHotCategoryButtonTag + idx;
            GKEntityCategory *category = self.hotCategoryArray[idx];
            
            [button setImage:nil forState:UIControlStateNormal];
            [button sd_setImageWithURL:category.iconURL forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont appFontWithSize:14.f];
            [button setTitleColor:UIColorFromRGB(0xA9A9A9) forState:UIControlStateNormal];
            NSString *categoryName = [category.categoryName componentsSeparatedByString:@"-"].firstObject;;
            [button setTitle:categoryName forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapHotCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.hotCategoryView addSubview:button];
        }
        
        if (idx == self.hotCategoryArray.count - 1 || idx == 8) {
            *stop = YES;
            idx++;
            CGRect frame;
            frame.origin.x = (110.f + 28.f) * (idx % 5);
            frame.origin.y = (110.f + 28.f) * (idx / 5);
            frame.size = CGSizeMake(110.f, 110.f);
            
            if (!self.allCategoryButton) {
                _allCategoryButton = [[UIButton alloc] init];
                self.allCategoryButton.backgroundColor = UIColorFromRGB(0xF8F8F8);
                self.allCategoryButton.imageEdgeInsets = UIEdgeInsetsMake(25.f, 39.f, 45.f, 39.f);
                self.allCategoryButton.titleEdgeInsets = UIEdgeInsetsMake(80.f, -29.f, 10.f, 0.f);
                self.allCategoryButton.titleLabel.font = [UIFont appFontWithSize:14.f];
                [self.allCategoryButton setTitleColor:UIColorFromRGB(0xA9A9A9) forState:UIControlStateNormal];
                [self.allCategoryButton setTitle:@"更多品类" forState:UIControlStateNormal];
                [self.allCategoryButton setImage:[UIImage imageNamed:@"icon_homepage_more"] forState:UIControlStateNormal];
                [self.allCategoryButton addTarget:self action:@selector(tapHotCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.hotCategoryView addSubview:self.allCategoryButton];
            }
            self.allCategoryButton.frame = frame;
        }
    }];
    [self setNeedsLayout];
}

#pragma mark - Selector Method

- (void)tapHotCategoryButton:(UIButton *)button
{
#if EnableDataTracking
    [self findViewControllerAndSaveStateWithEventName:@"CATEGORY"];
#endif
    
    GKEntityCategory *category = nil;
    if (button != self.allCategoryButton) {
        category = self.hotCategoryArray[button.tag - kHotCategoryButtonTag];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectCategory:)]) {
        [self.delegate headerView:self didSelectCategory:category];
    }
}

#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.bannerArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 630.f/1.5, 280.f/1.5)];
        view.backgroundColor = UIColorFromRGB(0xF6F6F6);
        //UIView设置阴影
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowRadius = 10.f;
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowColor = UIColorFromRGB(0x999999).CGColor;
    }
    
    NSURL *imageURL = self.bannerArray[index][@"img"];
    [((UIImageView *)view) sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:UIColorFromRGB(0xF6F6F6) andSize:view.frame.size]];
    
    return view;
}

#pragma mark - iCarouselDelegate

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
#if EnableDataTracking
    [self findViewControllerAndSaveStateWithEventName:@"BANNER"];
#endif
    
    NSString *urlString = self.bannerArray[index][@"url"];
    
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (url) {
            if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectUrl:)]) {
                [self.delegate headerView:self didSelectUrl:url];
            }
        }
    } else if ([urlString hasPrefix:@"guoku://entity/"]) {
        NSString *entityId = [urlString substringFromIndex:15];
        GKEntity *entity = [GKEntity modelFromDictionary:@{@"entityId":entityId}];
        if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectEntity:)]) {
            [self.delegate headerView:self didSelectEntity:entity];
        }
    } else if ([urlString hasPrefix:@"guoku://category/"]) {
        NSInteger categoryId = [[urlString substringFromIndex:17] integerValue];
        GKEntityCategory *category = [GKEntityCategory modelFromDictionary:@{@"categoryId":@(categoryId)}];
        if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectCategory:)]) {
            [self.delegate headerView:self didSelectCategory:category];
        }
    }
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.banner reloadData];
    

}

@end
