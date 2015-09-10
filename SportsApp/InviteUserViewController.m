//
//  InviteUserViewController.m
//  SportsApp
//
//  Created by sergeyZ on 27.05.15.
//
//

#import "InviteUserViewController.h"
#import "UIViewController+Navigation.h"
#import "NSLayoutConstraint+Helper.h"
#import "CustomSearchBar.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "MemberInfo.h"
#import "AppDelegate.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "UIImage+Utilities.h"

static const CGFloat kPhotoSize = 40.0f;
static const CGFloat kHorizontalPadding = 12.0f;
static const CGFloat kSearchHeight = 38.0f;

//static const NSUInteger kAlertError = 1;
static const NSUInteger kAlertInviteUser = 2;
//static const NSUInteger kAlertInviteSent = 3;


@interface InviteUserViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UIView* searchFieldContainer; // because you can not properly configure the appearance of UISearchBar
@property (strong, nonatomic) CustomSearchBar* searchBar;

@property (strong, nonatomic) UIView* inviteFromEmailViewGroup;
@property (strong, nonatomic) UILabel* inviteGroupTitle;
@property (strong, nonatomic) UITextField* tfEmail;
@property (strong, nonatomic) UIButton* btnInvite;

@property (strong, nonatomic) UITableView* tableView;
//@property (strong, nonatomic) UITextField* tfSearch;

@end

@implementation InviteUserViewController{
    NSMutableArray* members;
    NSMutableArray* filteredMembers;
    NSUInteger selectedUserId;
    NSString *emailForInvite;
    
    NSLayoutConstraint* tableHeigtContraint;
    
    NSTimer *searchTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"Позвать друга";
    [self setNavTitle:NSLocalizedString(@"TITLE_INVITE_FRIEND", nil)];
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    [self setNavigationItems];
    
    _searchFieldContainer = [self layoutSearchBarContaiter];
    [self layoutSearchBarInContainer:_searchFieldContainer];
    [self layoutInviteFromEmailViewGroup];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithRGBA:BG_GRAY_COLOR]];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRGBA:VIEW_SEPARATOR_COLOR];
    [self.view addSubview:self.tableView];
    
    tableHeigtContraint = [NSLayoutConstraint setHeight:self.view.bounds.size.height - kSearchHeight forView:_tableView];
    [NSLayoutConstraint setWidht:self.view.bounds.size.width forView:_tableView];
    [NSLayoutConstraint setTopDistance:0 fromView:_tableView toView:_searchFieldContainer inContainer:self.view];
    
    _tableView.hidden = YES;
}

- (UIView*) layoutSearchBarContaiter {
    UIView* sbContaiter = [UIView new];
    sbContaiter.clipsToBounds = YES;
    sbContaiter.translatesAutoresizingMaskIntoConstraints = NO;
    sbContaiter.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    [self.view addSubview:sbContaiter];
    
    [NSLayoutConstraint setHeight:kSearchHeight forView:sbContaiter];
    [NSLayoutConstraint stretchHorizontal:sbContaiter inContainer:self.view withPadding:0];
    [NSLayoutConstraint setTopPadding:12 forView:sbContaiter inContainer:self.view];
    
    return sbContaiter;
}

- (void) layoutSearchBarInContainer:(UIView*)container {
    _searchBar = [CustomSearchBar new];
    _searchBar.delegate = self;
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _searchBar.barTintColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    [_searchBar setPlaceholder:NSLocalizedString(@"TXT_FIND", nil)];
    [_searchBar setTextColorTF:[UIColor colorWithRGBA:TXT_SEARCH_FIELD_COLOR]];
    [_searchBar setBackgroundColorTF:[UIColor colorWithRGBA:BG_SEARCH_FIELD_COLOR]];
    [container addSubview:_searchBar];
    
    [NSLayoutConstraint centerVertical:_searchBar withView:container inContainer:container];
    [NSLayoutConstraint stretchHorizontal:_searchBar inContainer:container withPadding:0];
}

#pragma mark -
#pragma mark NEW user invite
- (void) layoutInviteFromEmailViewGroup {
    _inviteFromEmailViewGroup = [UIView new];
    _inviteFromEmailViewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_inviteFromEmailViewGroup];
    
    [NSLayoutConstraint setHeight:100 forView:_inviteFromEmailViewGroup];
    [NSLayoutConstraint stretchHorizontal:_inviteFromEmailViewGroup inContainer:self.view withPadding:kHorizontalPadding];
    [NSLayoutConstraint setTopDistance:28 fromView:_inviteFromEmailViewGroup toView:_searchFieldContainer inContainer:self.view];
    
    [self setupTitleInviteFromEmailViewGroup];
    [self setupEmailField];
    [self setupInviteButton];
}

- (void) setupTitleInviteFromEmailViewGroup {
    _inviteGroupTitle = [UILabel new];
    _inviteGroupTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _inviteGroupTitle.text = NSLocalizedString(@"TXT_INVITE_NEW_USER", nil);
    _inviteGroupTitle.textAlignment = NSTextAlignmentCenter;
    _inviteGroupTitle.font = [UIFont boldSystemFontOfSize:9.0f];
    [_inviteGroupTitle sizeToFit];
    [_inviteFromEmailViewGroup addSubview:_inviteGroupTitle];
    
    [NSLayoutConstraint setHeight:21 forView:_inviteGroupTitle];
    [NSLayoutConstraint centerHorizontal:_inviteGroupTitle withView:_inviteFromEmailViewGroup inContainer:_inviteFromEmailViewGroup];
    [NSLayoutConstraint setTopPadding:0 forView:_inviteGroupTitle inContainer:_inviteFromEmailViewGroup];
}

- (void) setupEmailField {
    _tfEmail = [UITextField new];
    _tfEmail.translatesAutoresizingMaskIntoConstraints = NO;
    [_tfEmail addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfEmail.delegate = self;
    _tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [_tfEmail setBorderStyle:UITextBorderStyleRoundedRect];
    _tfEmail.placeholder = NSLocalizedString(@"TXT_ENTER_EMAIL", nil);
    _tfEmail.textColor = [UIColor colorWithRGBA:TXT_SEARCH_FIELD_COLOR];
    _tfEmail.backgroundColor = [UIColor whiteColor];
    _tfEmail.textAlignment = NSTextAlignmentCenter;
    _tfEmail.font = [UIFont systemFontOfSize:12.0f];
    _tfEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    [_inviteFromEmailViewGroup addSubview:_tfEmail];
    
    [NSLayoutConstraint setHeight:34 forView:_tfEmail];
    [NSLayoutConstraint stretchHorizontal:_tfEmail inContainer:_inviteFromEmailViewGroup withPadding:0];
    [NSLayoutConstraint setTopDistance:4 fromView:_tfEmail toView:_inviteGroupTitle inContainer:_inviteFromEmailViewGroup];
}

- (void) setupInviteButton {
    _btnInvite = [self createInviteButton];
    _btnInvite.translatesAutoresizingMaskIntoConstraints = NO;
    [_inviteFromEmailViewGroup addSubview:_btnInvite];
    
    [NSLayoutConstraint setHeight:40 forView:_btnInvite];
    [NSLayoutConstraint stretchHorizontal:_btnInvite inContainer:_inviteFromEmailViewGroup withPadding:0];
    [NSLayoutConstraint setTopDistance:20 fromView:_btnInvite toView:_tfEmail inContainer:_inviteFromEmailViewGroup];
}

- (UIButton*) createInviteButton {
    _btnInvite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnInvite addTarget:self action:@selector(btnInviteClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnInvite setTitle:NSLocalizedString(@"BTN_INVITE", nil) forState:UIControlStateNormal];
    
    _btnInvite.enabled = NO;
    [_btnInvite setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateNormal];
    [_btnInvite setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    
    _btnInvite.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnInvite.layer.borderWidth = 0.5;
    _btnInvite.layer.cornerRadius = 6.0;
    _btnInvite.layer.borderColor = [[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] CGColor];
    
    return _btnInvite;
}

#pragma mark -
#pragma mark UITableView delegate methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [cell setPreservesSuperviewLayoutMargins:NO];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 14)];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return members.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        
        UIImage *avatar = [UIImage imageForAvatarDefault:[UIImage imageNamed:@"ic_avatar.png"] text:nil];
        cell.imageView.image = avatar;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    MemberInfo* member = members[indexPath.row];
    
    if(member.icon){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:member.icon]];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIImage *avatar = [UIImage imageForAvatar:[UIImage imageWithData:data]];
                cell.imageView.image = avatar;
            });
        });
    }
    else{
        UIImage *avatar = [UIImage imageForAvatarDefault:[UIImage imageNamed:@"ic_avatar.png"] text:member.name];
        cell.imageView.image = avatar;
    }
    
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    cell.imageView.layer.borderWidth = 0.0;
    cell.imageView.layer.cornerRadius = kPhotoSize / 2;
    cell.imageView.layer.masksToBounds = YES;
    
    cell.textLabel.text = member.name;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberInfo *member = members[indexPath.row];
    selectedUserId = member.userId;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"MSG_INVITE_THIS_MEMBER", nil)
                          message:nil
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL_1", nil)
                          otherButtonTitles:NSLocalizedString(@"BTN_YES", nil), nil];
    alert.tag = kAlertInviteUser;
    [alert show];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelClick)];
    self.navigationItem.leftBarButtonItem = btnBack;
}

#pragma mark -
#pragma mark Other methods
# pragma mark -
# pragma mark Navigation button click
- (void) btnCancelClick {
    if(_tableView.hidden){
        [self.view endEditing:YES]; // hide keyboard
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        _tableView.hidden = YES;
        _inviteFromEmailViewGroup.hidden = NO;
        [_searchBar resignFirstResponder];
    }
}

- (void) btnInviteClick {
    if(_tfEmail.text.length <= 0)
        return;
    
    [self.view endEditing:YES]; // hide keyboard
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking inviteUserWithEmail:_tfEmail.text completionHandler:^(NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(errorMessage){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:errorMessage
                                      delegate:nil
                                      cancelButtonTitle:@"Ок"
                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:NSLocalizedString(@"MSG_INVITATION_SENT", nil)
                                      delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                                      otherButtonTitles:nil];
                [alert show];
            }
        });
    }];
}

#pragma mark -
#pragma mark UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidChange:(UITextField *)textField {
    if (textField == _tfEmail){
        if(![textField.text isValidEmail]){
            emailForInvite = nil;
            
            _btnInvite.enabled = NO;
            _btnInvite.userInteractionEnabled = NO;
            _btnInvite.layer.backgroundColor = [[UIColor clearColor] CGColor];
            
            _btnInvite.layer.borderWidth = 0.5;
            _btnInvite.layer.cornerRadius = 6.0;
            _btnInvite.layer.borderColor = [[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] CGColor];
            
        }
        else{
            emailForInvite = textField.text;
            
            _btnInvite.enabled = YES;
            _btnInvite.userInteractionEnabled = YES;
            _btnInvite.layer.backgroundColor = [[UIColor colorWithRGBA:BG_BUTTON_COLOR] CGColor];
            
            _btnInvite.layer.borderWidth = 0.0;
            _btnInvite.layer.cornerRadius = 6.0;
        }
    }
}

#pragma mark -
#pragma mark UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchTimer invalidate];
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startSearch:) userInfo:searchText repeats:NO];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _inviteFromEmailViewGroup.hidden = YES;
    _tableView.hidden = NO;
    [_tableView reloadData];
    
    return YES;
}

# pragma mark -
# pragma mark Alerts buttons
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == kAlertInviteUser){
        if(buttonIndex == 1){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
            [appNetworking inviteUserWithId:selectedUserId forGame:_gameId completionHandler:^(NSString *errorMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    if(errorMessage){
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:nil
                                              message:errorMessage
                                              delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:nil
                                              message:NSLocalizedString(@"MSG_INVITATION_SENT", nil)
                                              delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                                              otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
}

#pragma mark -
- (void)startSearch:(NSTimer *)timer {
    NSString *searchText = timer.userInfo;
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking findUser:searchText completionHandler:^(NSMutableArray *arrayData, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!errorMessage){
                members = arrayData;
                [_tableView reloadData];
            }
        });
    }];
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat bottom = _searchFieldContainer.frame.origin.y + kSearchHeight;
    tableHeigtContraint.constant = self.view.frame.size.height - kbSize.height - bottom;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    tableHeigtContraint.constant = self.view.bounds.size.height - kSearchHeight;
}

@end
