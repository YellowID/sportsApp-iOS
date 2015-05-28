//
//  InviteUserViewController.m
//  SportsApp
//
//  Created by sergeyZ on 27.05.15.
//
//

#import "InviteUserViewController.h"
#import "NSLayoutConstraint+Helper.h"
#import "CustomSearchBar.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#define PADDING_H 12

@interface InviteUserViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Позвать друга";
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    [self setNavigationItems];
    
    _searchFieldContainer = [self layoutSearchBarContaiter];
    [self layoutSearchBarInContainer:_searchFieldContainer];
    [self layoutInviteFromEmailViewGroup];
}

- (UIView*) layoutSearchBarContaiter {
    UIView* sbContaiter = [UIView new];
    sbContaiter.clipsToBounds = YES;
    sbContaiter.translatesAutoresizingMaskIntoConstraints = NO;
    sbContaiter.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    //sbContaiter.backgroundColor = [UIColor grayColor];
    [self.view addSubview:sbContaiter];
    
    [NSLayoutConstraint setHeight:38 forView:sbContaiter];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sbContaiter
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:12]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sbContaiter
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sbContaiter
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    return sbContaiter;
}

- (void) layoutSearchBarInContainer:(UIView*)container {
    _searchBar = [CustomSearchBar new];
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    //_searchBar.translucent = YES;
    
    _searchBar.barTintColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    [_searchBar setPlaceholder:@"Найти"];
    [_searchBar setTextColorTF:[UIColor colorWithRGBA:TXT_SEARCH_FIELD_COLOR]];
    [_searchBar setBackgroundColorTF:[UIColor colorWithRGBA:BG_SEARCH_FIELD_COLOR]];
    
    [container addSubview:_searchBar];
    
    [NSLayoutConstraint centerVertical:_searchBar withView:container inContainer:container];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
}

#pragma mark -
#pragma mark NEW user invite
- (void) layoutInviteFromEmailViewGroup {
    _inviteFromEmailViewGroup = [UIView new];
    _inviteFromEmailViewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    //_inviteFromEmailViewGroup.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_inviteFromEmailViewGroup];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inviteFromEmailViewGroup
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_searchFieldContainer
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:28]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inviteFromEmailViewGroup
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:PADDING_H]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inviteFromEmailViewGroup
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_H]];
    
    [_inviteFromEmailViewGroup addConstraint: [NSLayoutConstraint constraintWithItem:_inviteFromEmailViewGroup
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:100]];
    
    [self setupTitleInviteFromEmailViewGroup];
    [self setupEmailField];
    [self setupInviteButton];
}

- (void) setupTitleInviteFromEmailViewGroup {
    _inviteGroupTitle = [UILabel new];
    _inviteGroupTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _inviteGroupTitle.text = @"Пригласить нового пользователя:";
    _inviteGroupTitle.textAlignment = NSTextAlignmentCenter;
    _inviteGroupTitle.font = [UIFont boldSystemFontOfSize:9.0f];
    [_inviteGroupTitle sizeToFit];
    [_inviteFromEmailViewGroup addSubview:_inviteGroupTitle];
    
    [NSLayoutConstraint setHeight:21 forView:_inviteGroupTitle];
    [NSLayoutConstraint centerHorizontal:_inviteGroupTitle withView:_inviteFromEmailViewGroup inContainer:_inviteFromEmailViewGroup];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_inviteGroupTitle
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_inviteFromEmailViewGroup
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
}

- (void) setupEmailField {
    _tfEmail = [UITextField new];
    [_tfEmail addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _tfEmail.delegate = self;
    [_tfEmail setBorderStyle:UITextBorderStyleRoundedRect];
    _tfEmail.placeholder = @"Введите email";
    _tfEmail.textColor = [UIColor colorWithRGBA:TXT_SEARCH_FIELD_COLOR];
    _tfEmail.backgroundColor = [UIColor whiteColor];
    _tfEmail.textAlignment = NSTextAlignmentCenter;
    _tfEmail.font = [UIFont systemFontOfSize:12.0f];
    [_inviteFromEmailViewGroup addSubview:_tfEmail];
    
    _tfEmail.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:34 forView:_tfEmail];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_tfEmail
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_inviteGroupTitle
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:4]];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_tfEmail
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:_inviteFromEmailViewGroup
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_tfEmail
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_inviteFromEmailViewGroup
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
}

- (void) setupInviteButton {
    _btnInvite = [self createInviteButton];
    _btnInvite.translatesAutoresizingMaskIntoConstraints = NO;
    [_inviteFromEmailViewGroup addSubview:_btnInvite];
    
    [NSLayoutConstraint setHeight:40 forView:_btnInvite];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_btnInvite
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:0
                                                                             toItem:_tfEmail
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1
                                                                           constant:24]];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_btnInvite
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:0
                                                                             toItem:_inviteFromEmailViewGroup
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1
                                                                           constant:0]];
    
    [_inviteFromEmailViewGroup addConstraint:[NSLayoutConstraint constraintWithItem:_btnInvite
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:0
                                                                             toItem:_inviteFromEmailViewGroup
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1
                                                                           constant:0]];
}

- (UIButton*) createInviteButton {
    _btnInvite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnInvite addTarget:self action:@selector(btnInviteClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnInvite setTitle:@"Пригласить" forState:UIControlStateNormal];
    
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
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return members.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    
    NSString* seekCity = members[indexPath.row];
    
    cell.textLabel.text = seekCity;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString* selectedCity = members[indexPath.row];
    
    [_tableView reloadData];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitle:@"Отмена" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnCancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
}

#pragma mark -
#pragma mark Other methods
# pragma mark -
# pragma mark Navigation button click
- (void) btnCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnInviteClick {
    NSLog(@"btnInviteClick");
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
        if([textField.text isEmpty]){
            _btnInvite.enabled = NO;
            _btnInvite.userInteractionEnabled = NO;
            _btnInvite.layer.backgroundColor = [[UIColor clearColor] CGColor];
            
            _btnInvite.layer.borderWidth = 0.5;
            _btnInvite.layer.cornerRadius = 6.0;
            _btnInvite.layer.borderColor = [[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] CGColor];
            
        }
        else{
            _btnInvite.enabled = YES;
            _btnInvite.userInteractionEnabled = YES;
            _btnInvite.layer.backgroundColor = [[UIColor colorWithRGBA:BG_BUTTON_COLOR] CGColor];
            
            _btnInvite.layer.borderWidth = 0.0;
            _btnInvite.layer.cornerRadius = 6.0;
        }
    }
}

@end
