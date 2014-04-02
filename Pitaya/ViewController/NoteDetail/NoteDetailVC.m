//
//  NoteDetailVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteDetailVC.h"
#import "NoteDetailHeaderView.h"

@interface NoteDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet NoteDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation NoteDetailVC

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableHeaderView.note = self.note;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
