//
//  UMFeedbackViewController.m
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMFeedbackTableViewCellLeft.h"
#import "UMFeedbackTableViewCellRight.h"

#define TOP_MARGIN 20.0f

static UITapGestureRecognizer *tapRecognizer;

@interface UMFeedbackViewController ()
@property(nonatomic, copy) NSString *mContactInfo;
@end

@implementation UMFeedbackViewController

@synthesize mTextField = _mTextField, mTableView = _mTableView, mToolBar = _mToolBar, mFeedbackData = _mFeedbackData;

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)setupTableView {
    _tableViewTopMargin = self.navigationController.navigationBar.frame.size.height;
    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)setupEGORefreshTableHeaderView {
    if (_refreshHeaderView == nil) {

        UMEGORefreshTableHeaderView *view = [[UMEGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mTableView.bounds.size.height, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
        view.delegate = (id <UMEGORefreshTableHeaderDelegate>) self;
        [self.mTableView addSubview:view];
        _refreshHeaderView = view;
    }

    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)setupToolbar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.frame = CGRectMake(256, 7, 57.0f, 30.0f);
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.backgroundColor = UIColorFromRGB(0x427EC0);
    [button addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];

    [self.mToolBar addSubview:button];

    [self setupTextField];
}

- (void)setupTextField {
    _mTextField = [[UITextField alloc] initWithFrame:CGRectMake(6, 7, _mToolBar.frame.size.width - 74.0f, 30.0f)];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.backgroundColor = [UIColor whiteColor];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.textAlignment = NSTextAlignmentLeft;
    _mTextField.textColor = UIColorFromRGB(0x666666);
    _mTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mTextField.borderStyle = UITextBorderStyleNone;
    _mTextField.font = [UIFont systemFontOfSize:14.0f];

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    _mTextField.leftView = paddingView;
    _mTextField.leftViewMode = UITextFieldViewModeAlways;
    _mTextField.delegate = (id <UITextFieldDelegate>) self;

    [self.mToolBar addSubview:_mTextField];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_refreshHeaderView egoRefreshScrollViewShowLoadingManual:self.mTableView];
    [_refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.mTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"意见反馈";
    
    if (iOS7) {
        _mTableView.deFrameTop = 25.f;
        _mTableView.deFrameHeight -= 25.f;
    }

    [self setBackgroundColor];
    [self setupTableView];
    [self setupEGORefreshTableHeaderView];
    [self setupToolbar];
    [self setFeedbackClient];
    [self updateTableView:nil];
    [self handleKeyboard];

    _shouldScrollToBottom = YES;

}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
}

- (void)setFeedbackClient {
    _mFeedbackData = [[NSArray alloc] init];
    feedbackClient = [UMFeedback sharedInstance];
    if ([self.appkey isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO Umeng kUmengAppkey"
                                                        message:@"Please define UMENG_APPKEY macro!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [feedbackClient setAppkey:self.appkey delegate:(id <UMFeedbackDataDelegate>) self];

//    从缓存取topicAndReplies
    self.mFeedbackData = feedbackClient.topicAndReplies;
}

- (void)setBackgroundColor {
    self.mTableView.backgroundColor = [UIColor whiteColor];
    if ([self.mToolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        UIImage *image = [self imageWithColor:UIColorFromRGB(0xEEEEEE)];
        [self.mToolBar setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    } else {
        self.mToolBar.barStyle = UIBarStyleBlack;
    }
}

- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [self.mTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height;

    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

                         CGRect toolbarFrame = self.mToolBar.frame;
                         toolbarFrame.origin.y = self.view.bounds.size.height - keyboardHeight - toolbarFrame.size.height;
                         self.mToolBar.frame = toolbarFrame;

                         CGRect tableViewFrame = self.mTableView.frame;
                         tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - keyboardHeight;
                         self.mTableView.frame = tableViewFrame;
                     }
                     completion:^(BOOL finished) {
                         if (_shouldScrollToBottom) {
                             [self scrollToBottom];
                         }
                     }
    ];

    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    CGRect toolbarFrame = self.mToolBar.frame;
    toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
    self.mToolBar.frame = toolbarFrame;

    CGRect tableViewFrame = self.mTableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height;
    self.mTableView.frame = tableViewFrame;

    [UIView commitAnimations];

    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)backToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)sendFeedback:(id)sender {
    if ([self.mTextField.text length]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:self.mTextField.text forKey:@"content"];

        if ([self.mContactInfo length]) {
            [dictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:self.mContactInfo, @"plain", nil] forKey:@"contact"];
        }

        [feedbackClient post:dictionary];
        [self.mTextField resignFirstResponder];
        _shouldScrollToBottom = YES;
    }
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_mFeedbackData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *content = [[feedbackClient.topicAndReplies objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"content"];
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                           constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 40 + TOP_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *L_CellIdentifier = @"L_UMFBTableViewCell";
    static NSString *R_CellIdentifier = @"R_UMFBTableViewCell";

    NSDictionary *data = [self.mFeedbackData objectAtIndex:(NSUInteger) indexPath.row];

    if ([[data valueForKey:@"type"] isEqualToString:@"dev_reply"]) {
        UMFeedbackTableViewCellLeft *cell = (UMFeedbackTableViewCellLeft *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil) {
            cell = [[UMFeedbackTableViewCellLeft alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }

        cell.textLabel.text = [data valueForKey:@"content"];
        cell.timestampLabel.text = [data valueForKey:@"datetime"];

        return cell;
    }
    else {

        UMFeedbackTableViewCellRight *cell = (UMFeedbackTableViewCellRight *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
        if (cell == nil) {
            cell = [[UMFeedbackTableViewCellRight alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
        }

        cell.textLabel.text = [data valueForKey:@"content"];
        cell.timestampLabel.text = [data valueForKey:@"datetime"];

        return cell;

    }
}

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error {
    if ([self.mFeedbackData count]) {
        [self.mTableView reloadData];
    }
}

- (void)updateTextField:(NSError *)error {
    if (!error) {
        self.mTextField.text = @"";
        [feedbackClient get];
    }
}

- (void)getFinishedWithError:(NSError *)error {
    if (!error) {
        [self updateTableView:error];
    }

    if (_shouldScrollToBottom) {
        [self scrollToBottom];
    }

    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (void)postFinishedWithError:(NSError *)error {
    [self updateTextField:error];
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollToBottom {
    if ([self.mTableView numberOfRowsInSection:0] > 1) {
        int lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource {
    _reloading = YES;
    [feedbackClient get];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UMEGORefreshTableHeaderView *)view {
    _shouldScrollToBottom = NO;
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UMEGORefreshTableHeaderView *)view {
    return _reloading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(UMEGORefreshTableHeaderView *)view {
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

- (void)dealloc {

    feedbackClient.delegate = nil;
}

@end
