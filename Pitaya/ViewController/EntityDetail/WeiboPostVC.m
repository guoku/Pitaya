//
//  WeiboPostVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-5-4.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "WeiboPostVC.h"
#import "UIView+App.h"

@interface WeiboPostVC () <UITextViewDelegate, SinaWeiboRequestDelegate>

@property (nonatomic, weak) IBOutlet UIButton *postButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textCountLabel;

@end

@implementation WeiboPostVC

#pragma mark - Selector

- (UIView *)shareViewForEntity:(GKEntity *)entity noteArray:(NSArray *)noteArray
{
    UIView *entityView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 640, 0.f)];
    entityView.backgroundColor = [UIColor whiteColor];
    
    // 品牌
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 20.f, 600.f, 0.f)];
    brandLabel.backgroundColor = [UIColor clearColor];
    brandLabel.font = [UIFont appFontWithSize:28.f];
    brandLabel.textAlignment = NSTextAlignmentLeft;
    brandLabel.textColor = [UIColor darkGrayColor];
    [entityView addSubview:brandLabel];
    if (entity.brand && entity.brand.length > 0) {
        brandLabel.text = entity.brand;
        brandLabel.deFrameHeight = 30.f;
    }
    
    // 名称
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, brandLabel.deFrameBottom + 10.f, 600.f, 0.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont appFontWithSize:28.f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor darkGrayColor];
    [entityView addSubview:titleLabel];
    if (entity.title) {
        titleLabel.text = entity.title;
        titleLabel.deFrameHeight = 30.f;
    }
    
    // 商品主图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, titleLabel.deFrameBottom + 10.f, 600.f, 600.f)];
    [imageView setImageWithURL:self.entity.imageURL];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [entityView addSubview:imageView];
    
    // 点评列表
    UIView *noteListView = [[UIView alloc] initWithFrame:CGRectZero];
    noteListView.deFrameWidth = entityView.deFrameWidth;
    noteListView.deFrameTop = imageView.deFrameBottom + 20.f;
    [entityView addSubview:noteListView];
    
    CGFloat offsetY = 0.f;
    for (NSUInteger i = 0; i < 3 && i < noteArray.count; i++) {
        GKNote *note = noteArray[i];
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, offsetY, 50.f, 50.f)];
        avatarImageView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        avatarImageView.layer.cornerRadius = CGRectGetWidth(avatarImageView.bounds)/2;
        avatarImageView.layer.masksToBounds = YES;
        [avatarImageView setImageWithURL:note.creator.avatarURL placeholderImage:nil options:SDWebImageRetryFailed ];
        [noteListView addSubview:avatarImageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.deFrameTop = avatarImageView.deFrameTop - 2.f;
        nameLabel.deFrameLeft = avatarImageView.deFrameRight + 20.f;
        nameLabel.deFrameWidth = 600.f - nameLabel.deFrameLeft;
        nameLabel.deFrameHeight = 26.f;
        nameLabel.font = [UIFont appFontWithSize:24.f bold:YES];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.text = note.creator.nickname;
        [noteListView addSubview:nameLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:nameLabel.frame];
        contentLabel.deFrameTop = nameLabel.deFrameBottom + 10.f;
        contentLabel.font = [UIFont appFontWithSize:22.f];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        contentLabel.text = note.text;
        [contentLabel fixText];
        [noteListView addSubview:contentLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(avatarImageView.deFrameLeft, contentLabel.deFrameBottom + 20.f, 600.f, 0.5f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [noteListView addSubview:lineView];
        offsetY = lineView.deFrameBottom + 20.f;
    }
    noteListView.deFrameHeight = offsetY;
    
    // 看看更绝妙的点评
    UIImageView *noteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 448.f, 80.f)];
    noteImageView.image = [UIImage imageNamed:@"sina_share_note"];
    noteImageView.center = entityView.center;
    noteImageView.deFrameTop = noteListView.deFrameBottom + 50.f;
    [entityView addSubview:noteImageView];
    
    entityView.deFrameHeight = noteImageView.deFrameBottom + 50.f;
    
    return entityView;
}

- (NSInteger)countWord:(NSString *)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

#pragma mark - Selector

- (IBAction)tapPostButton:(id)sender
{
    [self.textView resignFirstResponder];
    
    NSString *postContent = [NSString stringWithFormat:@"%@ 详情 http://guoku.com/detail/%@ (分享自@果库) ", self.textView.text, self.entity.entityHash];
    [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    SinaWeibo *sinaweibo = [Passport sharedInstance].weiboInstance;
    
    // 判断是否使用服务器分享
    if (NO) {
        [sinaweibo requestWithURL:@"statuses/upload_url_text.json" params:[@{@"status":postContent, @"url":self.entity.imageURL.absoluteString} mutableCopy] httpMethod:@"POST" delegate:self];
    } else {
        [sinaweibo requestWithURL:@"statuses/upload.json" params:[@{@"status":postContent, @"pic":self.imageView.image} mutableCopy] httpMethod:@"POST" delegate:self];
    }
}

#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [BBProgressHUD dismiss];
    if((error.code == 21315)||(error.code == 10006))
    {
        [request.sinaweibo logIn];
    } else if(error.code == 10007) {
        [BBProgressHUD showErrorWithText:@"图片加载异常，不能进行微博分享"];
    } else {
        [BBProgressHUD showErrorWithText:[NSString stringWithFormat:@"网络错误%u", error.code]];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [BBProgressHUD dismiss];
    [BBProgressHUD showSuccessWithText:@"分享成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.textCountLabel.text = [NSString stringWithFormat:@"还可以输入 %d 字", 140 - [self countWord:self.textView.text] - 30];
    if (110 < [self countWord:self.textView.text])
    {
        self.postButton.enabled = NO;
    } else {
        self.postButton.enabled = YES;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.text = @"果库连这都有，大家看我要来一个不？";
    [self.textView becomeFirstResponder];
    self.imageView.image = [[self shareViewForEntity:self.entity noteArray:self.noteArray] weiboShareImageType:1];
    self.textCountLabel.text = [NSString stringWithFormat:@"还可以输入 %d 字", 140 - [self countWord:self.textView.text] - 30];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
