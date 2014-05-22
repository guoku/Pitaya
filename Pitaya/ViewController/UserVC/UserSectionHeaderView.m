//
//  UserSectionHeaderView.m
//  Pitaya
//
//  Created by 魏哲 on 14-3-18.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "UserSectionHeaderView.h"

@interface UserSectionHeaderView ()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *genderImageView;
@property (nonatomic, strong) IBOutlet UILabel *bioLabel;
@property (nonatomic, strong) IBOutlet UIButton *friendButton;
@property (nonatomic, strong) IBOutlet UIButton *fanButton;

@end

@implementation UserSectionHeaderView

- (IBAction)tapSegmentControl:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didSelectedIndex:)]) {
        [self.delegate headerView:self didSelectedIndex:self.segmentedControl.selectedSegmentIndex];
    }
}

- (IBAction)tapFanButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didTapedFanButton:)]) {
        [self.delegate headerView:self didTapedFanButton:sender];
    }
}

- (IBAction)tapFriendButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didTapedFriendButton:)]) {
        [self.delegate headerView:self didTapedFriendButton:sender];
    }
}

- (void)setUser:(GKUser *)user
{
    if (_user != user) {
        [self removeObserver];
        _user = user;
        
        [self.avatarImageView setImageWithURL:self.user.avatarURL];
        self.nicknameLabel.text = self.user.nickname;
        self.bioLabel.text = self.user.bio;
        [self.friendButton setTitle:[NSString stringWithFormat:@"%d 关注", self.user.followingCount] forState:UIControlStateNormal];
        [self.fanButton setTitle:[NSString stringWithFormat:@"%d 粉丝", self.user.fanCount] forState:UIControlStateNormal];
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"喜爱 %d", self.user.likeCount] forSegmentAtIndex:0];
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"点评 %d", self.user.noteCount] forSegmentAtIndex:1];
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"标签 %d", self.user.tagCount] forSegmentAtIndex:2];
        [self addObserver];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!iOS7) {
        [self.segmentedControl setupFlat];
    }
}

#pragma mark - KVO

- (void)addObserver
{
    [self.user addObserver:self forKeyPath:@"avatarURL" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"nickname" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"bio" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"followingCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"fanCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"likeCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"noteCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.user addObserver:self forKeyPath:@"tagCount" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{
    [self.user removeObserver:self forKeyPath:@"avatarURL"];
    [self.user removeObserver:self forKeyPath:@"nickname"];
    [self.user removeObserver:self forKeyPath:@"bio"];
    [self.user removeObserver:self forKeyPath:@"followingCount"];
    [self.user removeObserver:self forKeyPath:@"fanCount"];
    [self.user removeObserver:self forKeyPath:@"likeCount"];
    [self.user removeObserver:self forKeyPath:@"noteCount"];
    [self.user removeObserver:self forKeyPath:@"tagCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"avatarURL"]) {
        [self.avatarImageView setImageWithURL:self.user.avatarURL];
    } else if ([keyPath isEqualToString:@"nickname"]) {
        self.nicknameLabel.text = self.user.nickname;
    } else if ([keyPath isEqualToString:@"bio"]) {
        self.bioLabel.text = self.user.bio;
    } else if ([keyPath isEqualToString:@"followingCount"]) {
        [self.friendButton setTitle:[NSString stringWithFormat:@"%d 关注", self.user.followingCount] forState:UIControlStateNormal];
    } else if ([keyPath isEqualToString:@"fanCount"]) {
        [self.fanButton setTitle:[NSString stringWithFormat:@"%d 粉丝", self.user.fanCount] forState:UIControlStateNormal];
    } else if ([keyPath isEqualToString:@"likeCount"]) {
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"喜爱 %d", self.user.likeCount] forSegmentAtIndex:0];
    } else if ([keyPath isEqualToString:@"noteCount"]) {
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"点评 %d", self.user.noteCount] forSegmentAtIndex:1];
    } else if ([keyPath isEqualToString:@"tagCount"]) {
        [self.segmentedControl setTitle:[NSString stringWithFormat:@"标签 %d", self.user.tagCount] forSegmentAtIndex:2];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

@end
