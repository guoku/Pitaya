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
#import "UserVC.h"
#import "TagVC.h"
#import "CategoryVC.h"

@interface NoteDetailVC () <UITableViewDataSource, UITableViewDelegate, NoteDetailHeaderViewDelegate, CommentCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet NoteDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) IBOutlet UIView *inputBarView;
@property (nonatomic, strong) IBOutlet UITextField *inputTextField;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) GKComment *repliedComment;

@end

@implementation NoteDetailVC

#pragma mark - Selector Method

- (IBAction)tapSendButton:(id)sender
{
    if (!(self.inputTextField.text && self.inputTextField.text.length > 0)) {
        [BBProgressHUD showErrorWithText:@"请输入评论内容"];
        return;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    
    if (self.repliedComment) {
        [GKDataManager replyCommentWithNoteId:self.note.noteId commentId:self.repliedComment.commentId commentCreatorId:self.repliedComment.creator.userId content:self.inputTextField.text success:^(GKComment *comment) {
            [weakSelf.commentArray addObject:comment];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(weakSelf.commentArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            weakSelf.note.commentCount += 1;
            weakSelf.inputTextField.text = @"";
            weakSelf.inputTextField.placeholder = @"";
            [weakSelf.inputTextField resignFirstResponder];
            [BBProgressHUD showSuccessWithText:@"回复成功!"];
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showSuccessWithText:@"回复失败!"];
        }];
    } else {
        [GKDataManager postCommentWithNoteId:self.note.noteId content:self.inputTextField.text success:^(GKComment *comment) {
            [weakSelf.commentArray addObject:comment];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(weakSelf.commentArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            weakSelf.note.commentCount += 1;
            weakSelf.inputTextField.text = @"";
            weakSelf.inputTextField.placeholder = @"";
            [weakSelf.inputTextField resignFirstResponder];
            [BBProgressHUD showSuccessWithText:@"评论成功!"];
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showSuccessWithText:@"评论失败!"];
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.inputTextField) {
            [self tapSendButton:nil];
        }
    }
    return YES;
}

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
    return [CommentCell heightForCellWithComment:self.commentArray[indexPath.row]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inputTextField resignFirstResponder];
}

#pragma mark - NoteDetailHeaderViewDelegate

- (void)headerView:(NoteDetailHeaderView *)headerView didSelectTag:(NSString *)tag fromUser:(GKUser *)user
{
    TagVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TagVC"];
    if (tag.length > 1) {
        vc.tagName = [tag substringFromIndex:1];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)headerView:(NoteDetailHeaderView *)headerView didSelectCategory:(GKEntityCategory *)category
{
#if EnableDataTracking
    [self saveStateWithEventName:@"CATEGORY"];
#endif
    CategoryVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CategoryVC"];
    vc.category = category;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CommentCellDelegate

- (void)commentCell:(CommentCell *)cell replyComment:(GKComment *)comment
{
    self.repliedComment = comment;
    self.inputTextField.placeholder = [NSString stringWithFormat:@"回复：%@", comment.creator.nickname];
    self.inputTextField.text = @"";
    [self.inputTextField becomeFirstResponder];
}

- (void)commentCell:(CommentCell *)cell didSelectUser:(GKUser *)user
{
    UserVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserVC"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentCell:(CommentCell *)cell didSelectTag:(NSString *)tag fromUser:(GKUser *)user
{
    TagVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TagVC"];
    if (tag.length > 1) {
        vc.tagName = [tag substringFromIndex:1];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight;
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        keyboardHeight = CGRectGetHeight(keyboardFrame);
    } else {
        keyboardHeight = CGRectGetWidth(keyboardFrame);
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.inputBarView.deFrameBottom = CGRectGetHeight(self.view.bounds) - keyboardHeight;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.inputBarView.deFrameBottom = CGRectGetHeight(self.view.bounds);
    [UIView commitAnimations];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = @"点评页";
    
    self.navigationItem.title = [NSString stringWithFormat:@"%d 条评论", self.note.commentCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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

#pragma mark - Data Tracking

#if EnableDataTracking

- (void)saveStateWithEventName:(NSString *)eventName
{
    [kAppDelegate.trackNode clear];
    kAppDelegate.trackNode.pageName = @"NOTE";
    kAppDelegate.trackNode.xid = @(self.note.noteId).stringValue;
    kAppDelegate.trackNode.featureName = eventName;
}

#endif

@end
