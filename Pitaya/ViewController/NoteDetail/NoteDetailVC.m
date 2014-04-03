//
//  NoteDetailVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-1.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NoteDetailVC.h"
#import "NoteDetailHeaderView.h"
#import "CommentCell.h"

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
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.comment = self.commentArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell heightForComment:self.commentArray[indexPath.row]];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableHeaderView.note = self.note;
    
    __weak __typeof(&*self)weakSelf = self;
    [GKDataManager getNoteDetailWithNoteId:self.note.noteId success:^(GKNote *note, GKEntity *entity, NSArray *commentArray, NSArray *pokerArray) {
        weakSelf.note = note;
        self.commentArray = [commentArray mutableCopy];
        [self.tableView reloadData];
    } failure:^(NSInteger stateCode) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
