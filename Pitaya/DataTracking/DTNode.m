//
//  DTNode.m
//  Blueberry
//
//  Created by 魏哲 on 14-1-14.
//  Copyright (c) 2014年 GuoKu. All rights reserved.
//

#import "DTNode.h"

@implementation DTNode

- (void)clear
{
    self.pageName = nil;
    self.featureName = nil;
    self.featureName = nil;
    self.xid = nil;
    self.tabIndex = -1;
}

- (NSString *)trackString
{
    NSString *trackString = nil;
    if ([self.pageName isEqualToString:@"HOMEPAGE"]) {
#pragma mark - 首页VC
        // 首页VC
        if ([self.featureName isEqualToString:@"ENTITY"]) {
            // 首页VC - 新品
            trackString = @"NOVUS";
        } else if ([self.featureName isEqualToString:@"BANNER"]) {
            // 首页VC - banner
            trackString = @"BANNER";
        } else if ([self.featureName isEqualToString:@"SELECTION"]) {
            // 首页VC - 精选
            trackString = @"SELECTION";
        } else if ([self.featureName isEqualToString:@"HOT"]) {
            // 首页VC - 热门
            trackString = @"POPULAR";
        } else if ([self.featureName isEqualToString:@"CATEGORY"]) {
            // 首页VC - 热门品类
            trackString = @"POPULAR_CATEGORY";
        }
    } else if ([self.pageName isEqualToString:@"SELECTION"]) {
#pragma mark - 精选VC
        // 精选VC
        if ([self.featureName isEqualToString:@"ENTITY"]) {
            // 精选VC - 新品
            trackString = @"SELECTION";
        }
    } else if ([self.pageName isEqualToString:@"HOT"]) {
#pragma mark - 热门VC
        // 热门VC
        if (self.tabIndex == 0) {
            // 热门VC - 24小时热门
            trackString = @"POPULAR_DAY";
        } else if (self.tabIndex == 1) {
            // 热门VC - 7天热门
            trackString = @"POPULAR_WEEK";
        }
    } else if ([self.pageName isEqualToString:@"DISCOVER"]) {
#pragma mark - 发现VC
        // 发现VC
        if ([self.featureName isEqualToString:@"CATEGORY"]) {
            // 发现VC - 品类
            trackString = @"DISCOVER";
        } else if ([self.featureName isEqualToString:@"RANDOM"]) {
            // 发现VC - 随机品类
            trackString = @"DISCOVER_RANDOM";
        }
    } else if ([self.pageName isEqualToString:@"GROUP"]) {
#pragma mark - 大分类VC
        // 大分类VC
        if ([self.featureName isEqualToString:@"CATEGORY"]) {
            // 大分类VC - 品类
            trackString = [NSString stringWithFormat:@"DISCOVER_GROUP_%@", self.xid];
        }
    } else if ([self.pageName isEqualToString:@"TAGRECOMMEND"]) {
#pragma mark - 推荐标签VC
        // 推荐标签VC
        if ([self.featureName isEqualToString:@"Entity"]) {
            // 推荐标签VC - 商品
            trackString = [NSString stringWithFormat:@"TAG_RECOMMEND"];
        }
    } else if ([self.pageName isEqualToString:@"FEED"]) {
#pragma mark - 动态VC
        // 动态VC
        if (self.tabIndex == 0) {
            // 好友动态
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 消息VC - 商品
                trackString = @"FEED_FRIEND";
            } else if ([self.featureName isEqualToString:@"NOTE"]) {
                // 消息VC - 点评
                trackString = @"FEED_FRIEND";
            }
        } else if (self.tabIndex == 1) {
            // 社区动态
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 消息VC - 商品
                trackString = @"FEED_SOCIAL";
            } else if ([self.featureName isEqualToString:@"NOTE"]) {
                // 消息VC - 点评
                trackString = @"FEED_SOCIAL";
            }
        }
    } else if ([self.pageName isEqualToString:@"MESSAGE"]) {
#pragma mark - 消息VC
        // 消息VC
        if ([self.featureName isEqualToString:@"ENTITY"]) {
            // 消息VC - 商品
            trackString = @"MESSAGE";
        } else if ([self.featureName isEqualToString:@"NOTE"]) {
            // 消息VC - 点评
            trackString = @"MESSAGE";
        }
    } else if ([self.pageName isEqualToString:@"USER"]) {
#pragma mark - 用户VC
        // 用户VC
        if (self.tabIndex == 0) {
            // 喜爱tab
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 商品
                trackString = [NSString stringWithFormat:@"USER_%@_LIKE", self.xid];
            }
        } else if (self.tabIndex == 1) {
            // 点评tab
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 商品
                trackString = [NSString stringWithFormat:@"USER_%@_NOTE", self.xid];
            } else if ([self.featureName isEqualToString:@"NOTE"]) {
                // 点评
                trackString = [NSString stringWithFormat:@"USER_%@_NOTE", self.xid];
            } else if ([self.featureName isEqualToString:@"CATEGORY"]) {
                // 品类
                trackString = [NSString stringWithFormat:@"USER_%@_NOTE", self.xid];
            }
        } else if (self.tabIndex == 2) {
            // 标签tab
            if ([self.featureName isEqualToString:@"TAG"]) {
                // 标签
                trackString = [NSString stringWithFormat:@"USER_%@_TAG", self.xid];
            }
        }
    } else if ([self.pageName isEqualToString:@"TAG"]) {
#pragma mark - 标签VC
        // 标签VC
        if ([self.featureName isEqualToString:@"ENTITY"]) {
            // 标签VC - 商品
            trackString = [NSString stringWithFormat:@"TAG_%@", self.xid];
        }
    } else if ([self.pageName isEqualToString:@"NOTE"]) {
#pragma mark - 点评VC
        // 点评VC
        if ([self.featureName isEqualToString:@"CATEGORY"]) {
            // 点评VC - 商品
            trackString = [NSString stringWithFormat:@"NOTE_%@", self.xid];
        }
    } else if ([self.pageName isEqualToString:@"ENTITY"]) {
#pragma mark - 商品VC
        // 商品VC
        if ([self.featureName isEqualToString:@"ENTITY"]) {
            // 商品VC - 商品
            trackString = [NSString stringWithFormat:@"ENTITY_%@", self.xid];
        } else if ([self.featureName isEqualToString:@"CATEGORY"]) {
            // 商品VC - 品类
            trackString = [NSString stringWithFormat:@"ENTITY_%@", self.xid];
        }
    } else if ([self.pageName isEqualToString:@"CATEGORY"]) {
#pragma mark - 品类VC
        // 品类VC
        if (self.tabIndex == 0) {
            // 商品tab
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 商品
                trackString = [NSString stringWithFormat:@"CATEGORY_%@_ENTITY", self.xid];
            }
        } else if (self.tabIndex == 1) {
            // 点评tab
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 商品
                trackString = [NSString stringWithFormat:@"CATEGORY_%@_NOTE", self.xid];
            } else if ([self.featureName isEqualToString:@"NOTE"]) {
                // 点评
                trackString = [NSString stringWithFormat:@"CATEGORY_%@_NOTE", self.xid];
            } else if ([self.featureName isEqualToString:@"CATEGORY"]) {
                // 品类
                trackString = [NSString stringWithFormat:@"CATEGORY_%@_NOTE", self.xid];
            }
        } else if (self.tabIndex == 2) {
            // 喜爱tab
            if ([self.featureName isEqualToString:@"ENTITY"]) {
                // 商品
                trackString = [NSString stringWithFormat:@"CATEGORY_%@_LIKE", self.xid];
            }
        }
    } else if ([self.pageName isEqualToString:@"SEARCH"]) {
#pragma mark - 搜索
        // 搜索
        if ([self.featureName isEqualToString:@"CATEGORY"]) {
            // 搜索
            trackString = [NSString stringWithFormat:@"SEARCH_%@", self.keyword];
        } else if ([self.featureName isEqualToString:@"ENTITY"]) {
            // KeywordVC
            if (self.tabIndex == 0) {
                // 所有
                trackString = [NSString stringWithFormat:@"SEARCH_%@_ALL", self.keyword];
            } else if (self.tabIndex == 1) {
                // 喜爱
                trackString = [NSString stringWithFormat:@"SEARCH_%@_LIKE", self.keyword];
            }
        }
    } else if ([self.pageName isEqualToString:@"EXTERNAL"]) {
#pragma mark - 外部
        // 外部
        if ([self.featureName isEqualToString:@"wx"]) {
            // 微信
            trackString = @"EXTERNAL_wx";
        }
    }
    
    return trackString;
}

@end
