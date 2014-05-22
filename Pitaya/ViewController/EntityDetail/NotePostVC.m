//
//  NotePostVC.m
//  Pitaya
//
//  Created by 魏哲 on 14-4-8.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "NotePostVC.h"

@interface NotePostVC () <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *placeholderLabel;

@end

@implementation NotePostVC

- (IBAction)tapSendButton:(id)sender
{
    NSInteger score = 0;
    NSString *content = self.textView.text;
    
    if (content.length == 0) {
        [BBProgressHUD showText:@"请输入点评内容"];
        return;
    }
    
    [BBProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    __weak __typeof(&*self)weakSelf = self;
    if ([self isMyNote]) {
        [GKDataManager updateNoteWithNoteId:self.note.noteId content:content score:score imageData:nil success:^(GKNote *note) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [BBProgressHUD showSuccessWithText:@"修改成功"];
            if (weakSelf.successBlock) {
                weakSelf.successBlock(note);
            }
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showErrorWithText:@"修改失败"];
        }];
    } else {
        [GKDataManager postNoteWithEntityId:self.entity.entityId content:content score:score imageData:nil success:^(GKNote *note) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [BBProgressHUD showSuccessWithText:@"发布成功"];
            [Passport sharedInstance].user.noteCount += 1;
            if (weakSelf.successBlock) {
                weakSelf.successBlock(note);
            }
        } failure:^(NSInteger stateCode) {
            [BBProgressHUD showErrorWithText:@"发布失败"];
        }];
    }
}

- (BOOL)isMyNote
{
    return (self.note && [Passport sharedInstance].user.userId == self.note.creator.userId);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = (textView.text.length > 0);
    
    // 修复 iOS 7 下 UITextView 最后一行文字看不到的 bug。
    if (iOS7) {
        CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
        CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
        
        if (overflow > 0) {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            CGPoint offset = textView.contentOffset;
            offset.y += overflow + 7; // leave 7 pixels margin
            // Cannot animate with setContentOffset:animated: or caret will not appear
            [UIView animateWithDuration:.2 animations:^{
                [textView setContentOffset:offset];
            }];
        }
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7) {
        self.textView.textContainerInset = UIEdgeInsetsMake(20.f, 18.f, 20.f, 18.f);
    } else {
        self.textView.contentInset = UIEdgeInsetsMake(12.f, 20.f, 12.f, 20.f);
    }
    
    [self.textView becomeFirstResponder];
    
    if ([self isMyNote]) {
        [self.sendButton setTitle:@"修改" forState:UIControlStateNormal];
        self.textView.text = self.note.text;
        self.placeholderLabel.hidden = (self.textView.text.length > 0);
    } else {
        [self.sendButton setTitle:@"发布" forState:UIControlStateNormal];
        self.textView.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
