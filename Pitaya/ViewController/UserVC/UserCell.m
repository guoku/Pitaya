//
//  UserCell.m
//  Pitaya
//
//  Created by 魏哲 on 14-5-3.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "UserCell.h"

@interface UserCell ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fanCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *friendCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

@end

@implementation UserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

#pragma mark - Private Method

- (void)refreshFollowButtonState
{
    switch (self.user.relation) {
        case GKUserRelationTypeNone:
        {
            self.followButton.backgroundColor = UIColorFromRGB(0x427ec0);
            [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeFollowing:
        {
            self.followButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [self.followButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
            [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeFan:
        {
            self.followButton.backgroundColor = UIColorFromRGB(0x427ec0);
            [self.followButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeBoth:
        {
            self.followButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [self.followButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
            [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
            break;
        }
            
        case GKUserRelationTypeSelf:
        {
            self.followButton.backgroundColor = UIColorFromRGB(0xf1f1f1);
            [self.followButton setTitleColor:UIColorFromRGB(0x427ec0) forState:UIControlStateNormal];
            [self.followButton setTitle:@"自己" forState:UIControlStateNormal];
            break;
        }
        default:
        {
            [self.followButton setTitle:@"" forState:UIControlStateNormal];
            [self.followButton setImage:nil forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark - Getter And Setter

- (void)setUser:(GKUser *)user
{
    if (_user == user) {
        return;
    }
    
    [self removeObserver];
    _user = user;
    [self addObserver];
    
    [self setNeedsLayout];
}

#pragma mark - Selector Method

- (IBAction)tapFollowButtom:(id)sender
{
    if (k_isLogin) {
        BOOL state;
        
        switch (self.user.relation) {
            case GKUserRelationTypeNone:
            {
                state = YES;
                break;
            }
                
            case GKUserRelationTypeFollowing:
            {
                state = NO;
                break;
            }
                
            case GKUserRelationTypeFan:
            {
                state = YES;
                break;
            }
                
            case GKUserRelationTypeBoth:
            {
                state = NO;
                break;
            }
                
            case GKUserRelationTypeSelf:
            {
                return;
            }
        }
        
        GKUserRelationType oldRelation = self.user.relation;
        
        [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [GKDataManager followUserId:self.user.userId state:state success:^(GKUserRelationType relation) {
            self.user.relation = relation;
            if (oldRelation%2 != relation%2) {
                if (relation%2 == 1) {
                    [Passport sharedInstance].user.followingCount += 1;
                    self.user.fanCount += 1;
                } else {
                    [Passport sharedInstance].user.followingCount -= 1;
                    self.user.fanCount -= 1;
                }
            }
            [BBProgressHUD dismiss];
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD dismiss];
        }];
    } else {
        [Passport loginWithSuccessBlock:nil];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avatarImageView setImageWithURL:self.user.avatarURL_s];
    
    self.nicknameLabel.text = self.user.nickname;
    
    self.fanCountLabel.text = [NSString stringWithFormat:@"粉丝 %d", self.user.fanCount];
    
    self.friendCountLabel.text = [NSString stringWithFormat:@"关注 %d", self.user.followingCount];
    
    [self refreshFollowButtonState];
}

#pragma mark - KVO

- (void)addObserver
{
    [self.user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"followingCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"fanCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"relation" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.user removeObserver:self forKeyPath:@"avatarURL"];
    [self.user removeObserver:self forKeyPath:@"nickname"];
    [self.user removeObserver:self forKeyPath:@"followingCount"];
    [self.user removeObserver:self forKeyPath:@"fanCount"];
    [self.user removeObserver:self forKeyPath:@"relation"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"avatarURL"]) {
        [self.avatarImageView setImageWithURL:self.user.avatarURL];
    } else if ([keyPath isEqualToString:@"nickname"]) {
        self.nicknameLabel.text = self.user.nickname;
    } else if ([keyPath isEqualToString:@"followingCount"]) {
        self.friendCountLabel.text = [NSString stringWithFormat:@"关注 %d", self.user.followingCount];
    } else if ([keyPath isEqualToString:@"fanCount"]) {
        self.fanCountLabel.text = [NSString stringWithFormat:@"粉丝 %d", self.user.fanCount];
    } else if ([keyPath isEqualToString:@"relation"]) {
        [self refreshFollowButtonState];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
