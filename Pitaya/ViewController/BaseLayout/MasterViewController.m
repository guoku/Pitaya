//
//  MasterViewController.m
//  GuoKuHD
//
//  Created by 魏哲 on 14-1-6.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterTableViewCell.h"

static NSString * const CellReuseIdentifier = @"MasterTableViewCell";

@interface MasterViewController () <UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MasterViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    CGFloat f = 1.f/(indexPath.row + 0.1);
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(masterViewController:didSelectRowAtIndexPath:)]) {
        [_delegate masterViewController:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleArray = @[@"首页",
                        @"发现",
                        @"动态",
                        @"消息",
                        @"设置"];
    
    CGRect frame = self.headerView.frame;
    frame.size.height = iOS7 ? 80.f : 60;
    self.headerView.frame = frame;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end