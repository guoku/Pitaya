//
//  UserListVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-5-3.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "UserListVC.h"
#import "UserCell.h"
#import "SVPullToRefresh.h"
#import "UserVC.h"

@interface UserListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation UserListVC

#pragma mark - Private Method

- (void)refresh
{
    void (^successBlock)(NSArray *userArray) = ^(NSArray *userArray) {
        [self.userArray removeAllObjects];
        [self.userArray addObjectsFromArray:userArray];
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        
        if (userArray.count < kRequestSize) {
            self.tableView.showsInfiniteScrolling = NO;
        } else {
            self.tableView.showsInfiniteScrolling = YES;
        }
    };
    
    void (^failureBlock)(NSInteger stateCode) = ^(NSInteger stateCode) {
        [self.tableView.pullToRefreshView stopAnimating];
    };
    
    switch (self.type) {
        case UserListTypeFans:
        {
            [GKDataManager getUserFanListWithUserId:self.user.userId offset:0 count:kRequestSize success:successBlock failure:failureBlock];
            break;
        }
            
        case UserListTypeFriends:
        {
            [GKDataManager getUserFollowingListWithUserId:self.user.userId offset:0 count:kRequestSize success:successBlock failure:failureBlock];
            break;
        }
    }
}

- (void)loadMore
{
    void (^successBlock)(NSArray *userArray) = ^(NSArray *userArray) {
        [self.userArray addObjectsFromArray:userArray];
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        
        if (userArray.count < kRequestSize) {
            self.tableView.showsInfiniteScrolling = NO;
        } else {
            self.tableView.showsInfiniteScrolling = YES;
        }
    };
    
    void (^failureBlock)(NSInteger stateCode) = ^(NSInteger stateCode) {
        [self.tableView.infiniteScrollingView stopAnimating];
    };
    
    switch (self.type) {
        case UserListTypeFans:
        {
            [GKDataManager getUserFanListWithUserId:self.user.userId offset:self.userArray.count count:kRequestSize success:successBlock failure:failureBlock];
            break;
        }
            
        case UserListTypeFriends:
        {
            [GKDataManager getUserFollowingListWithUserId:self.user.userId offset:self.userArray.count count:kRequestSize success:successBlock failure:failureBlock];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.user = self.userArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.type) {
        case UserListTypeFans:
        {
            self.navigationItem.title = @"TA的粉丝";
            break;
        }
            
        case UserListTypeFriends:
        {
            
            self.navigationItem.title = @"TA关注的";
            break;
        }
    }
    
    _userArray = [NSMutableArray array];
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
    
    if (self.userArray.count == 0) {
        [self.tableView triggerPullToRefresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController isKindOfClass:[UserVC class]]) {
        UserCell *cell = (UserCell *)sender;
        UserVC *vc = (UserVC *)segue.destinationViewController;
        vc.user = cell.user;
    }
}

@end
