//
//  MessageVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-22.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MessageVC.h"
#import "SVPullToRefresh.h"
#import "MessageCell.h"
#import "EntityDetailVC.h"
#import "UserVC.h"

@interface MessageVC () <UITableViewDataSource, UITableViewDelegate, MessageCellDelegate>

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation MessageVC

#pragma mark - Private Method

- (void)refresh
{
    __weak __typeof(&*self)weakSelf = self;
    
    if (!k_isLogin) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [Passport loginWithSuccessBlock:^{
            [weakSelf refresh];
        }];
        return;
    }
    
    [GKDataManager getMessageListWithTimestamp:[[NSDate date] timeIntervalSince1970] count:kRequestSize success:^(NSArray *messageArray) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
        [weakSelf.messageArray removeAllObjects];
        weakSelf.messageArray = [messageArray mutableCopy];
        [weakSelf.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)loadMore
{
    __weak __typeof(&*self)weakSelf = self;
    
    if (!k_isLogin) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [Passport loginWithSuccessBlock:^{
            [weakSelf refresh];
        }];
        return;
    }
    
    NSTimeInterval timestamp = [self.messageArray.lastObject[@"time"] doubleValue];
    [GKDataManager getMessageListWithTimestamp:timestamp count:kRequestSize success:^(NSArray *messageArray) {
        [self.tableView.infiniteScrollingView stopAnimating];
        
        [self.messageArray addObjectsFromArray:messageArray];
        [self.tableView reloadData];
        
        if (messageArray.count < kRequestSize) {
            self.tableView.showsInfiniteScrolling = NO;
        }
    } failure:^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didLogin
{
    [self.tableView triggerPullToRefresh];
}

- (void)didLogout
{
    [self.messageArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Selector

- (IBAction)tapRefreshButton:(id)sender
{
    [self.tableView triggerPullToRefresh];
}

#pragma mark - MessageCellDelegate

- (void)messageCell:(MessageCell *)cell didSelectEntity:(GKEntity *)entity
{
#if EnableDataTracking
    [self saveStateWithEventName:@"ENTITY"];
#endif
    EntityDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EntityDetailVC"];
    vc.entity = entity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageCell:(MessageCell *)cell didSelectNote:(GKNote *)note
{
    
}

- (void)messageCell:(MessageCell *)cell didSelectUser:(GKUser *)user
{
    UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *message = self.messageArray[indexPath.row];
    cell.message = message;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageArray[indexPath.row];
    return [MessageCell heightForMessage:message];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageArray[indexPath.row];
    MessageType type = [MessageCell typeFromMessage:message];
    
    switch (type) {
        case MessageType_1:
        {
            // 评论被回复
            break;
        }
            
        case MessageType_2:
        {
            // 点评被评论
            break;
        }
            
        case MessageType_3:
        {
            // 被关注
            GKUser *user = self.messageArray[indexPath.row][@"content"][@"user"];
            UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
            vc.user = user;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case MessageType_4:
        {
            // 点评被赞
            break;
        }
            
        case MessageType_5:
        case MessageType_6:
        case MessageType_7:
        {
            GKEntity *entity = self.messageArray[indexPath.row][@"content"][@"entity"];
            EntityDetailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EntityDetailVC"];
            vc.entity = entity;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"消息页";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin) name:GKUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:GKUserDidLogoutNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    if (self.messageArray.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView triggerPullToRefresh];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GKUserDidLogoutNotification object:nil];
}

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"MESSAGE";
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
