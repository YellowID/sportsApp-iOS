//
//  ChatViewController.m
//  SportsApp
//
//  Created by sergeyZ on 26.05.15.
//
//

#import "ChatViewController.h"
#import "UIViewController+Navigation.h"
#import "InviteUserViewController.h"
#import "MemberViewController.h"
#import "NewEvenViewController.h"
#import "CustomButton.h"
#import "ChatTableViewCell.h"
#import "ChatRightTableViewCell.h"
#import "NSLayoutConstraint+Helper.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ChatMessage.h"

#import "UIImage+Utilities.h"
#import "NSDate+Utilities.h"
#import "NSDate+Formater.h"

#import <Quickblox/Quickblox.h>

static const CGFloat kPhotoSize = 40.0f;
static const CGFloat kCurtainHeight = 174.0f;
static const CGFloat kHorizontalPadding = 12.0f;

static const CGFloat kFooterHeightNormal = 50.0f;
static const CGFloat kMsgInputHeightNormal = 30.0f;
static const CGFloat kMsgInputHeightMax = 120.0f;

static const CGFloat kUserStatusButtonWidth = 83.0f;
static const CGFloat kUserStatusButtonHeight = 24.5f;

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, AppChatDelegate, NewEvenViewControllerDelegate>

#pragma mark -
#pragma mark Containers
@property (strong, nonatomic) UIView* chatContentView;
@property (strong, nonatomic) UIView* chatFooterView;
@property (strong, nonatomic) UITextView* tfMessage;
@property (strong, nonatomic) UIButton* btnSend;

@property (strong, nonatomic) UIView* curtainView;
@property (strong, nonatomic) UIView* curtainRowOneView;
@property (strong, nonatomic) UIView* curtainRowTwoView;
@property (strong, nonatomic) UIView* curtainRowThreeView;
@property (strong, nonatomic) UIButton* curtainArrowButton;

@property (strong, nonatomic) UILabel* peopleInGame;
@property (strong, nonatomic) UILabel* peopleNeed;

@property (strong, nonatomic) CustomButton* btnInviteUser;
@property (strong, nonatomic) CustomButton* btnAnswerYes;
@property (strong, nonatomic) CustomButton* btnAnswerPerhaps;
@property (strong, nonatomic) CustomButton* btnAnswerNo;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation ChatViewController{
    NSLayoutConstraint* footerViewHeightConstraint;
    NSLayoutConstraint* messageHeightConstraint;
    NSLayoutConstraint* curtainHeigtContraint;
    BOOL isCurtainOpen;
    
    UILabel* locTitle;
    UILabel* timeTitle;
    
    CGFloat mainViewHeight;
    
    NSUInteger currentUserId;
    GameInfo *game;
    
    NSMutableDictionary *avatarCache;
    NSMutableDictionary *chatRowHeightCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_chat.png"]];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    avatarCache = [NSMutableDictionary new];
    chatRowHeightCache = [NSMutableDictionary new];
    currentUserId = [AppDelegate instance].user.uid;
    
    // for getting messages
    AppChat *appChat = [[AppDelegate instance] appChatInstance];
    appChat.delegate = self;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking gameById:_gameId completionHandler:^(GameInfo *gameInfo, NSString *errorMessage) {
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
            else {
                game = gameInfo;
                
                [self setNavTitle:game.gameName];
                [self setNavigationItems];
                
                [self loadChatMessages];
                
                [self setupChatContentView];
                [self setupCurtainView];
                [self changeStatusButtons:game.participateStatus];
            }
        });
    }];
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

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    mainViewHeight = self.view.frame.size.height;
}

#pragma mark -
#pragma mark TEMP
- (void) loadChatMessages {
    /**/
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    AppChat *appChat = [[AppDelegate instance] appChatInstance];
    [appChat messagesForGameId:_gameId completionHandler:^(NSArray *chatMessages) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        _messages = [chatMessages mutableCopy];
        
        if(!_messages)
            _messages = [NSMutableArray new];
        
        [_tableView reloadData];
        CGFloat y = _tableView.contentSize.height - _tableView.frame.size.height;
        [_tableView setContentOffset:CGPointMake(0, y)];
    }];
    
}

- (void) putNewMessageInArray:(ChatMessage *)newMessage {
    NSUInteger count = _messages.count;
    
    if(count > 0){
        NSMutableArray *messagesOfLastDay = _messages[count-1];
        
        if(messagesOfLastDay.count > 0){
            ChatMessage *someMessage = messagesOfLastDay[0];
            
            if([newMessage.fullDate isEqualToDateIgnoringTime:someMessage.fullDate]){
                [messagesOfLastDay addObject:newMessage];
            }
            else{
                NSMutableArray *messagesForNewDay = [NSMutableArray new];
                [_messages addObject:messagesForNewDay];
                
                [messagesForNewDay addObject:newMessage];
            }
        }
        else{
            [messagesOfLastDay addObject:newMessage];
        }
    }
    else{
        NSMutableArray *messagesForNewDay = [NSMutableArray new];
        [_messages addObject:messagesForNewDay];
        
        [messagesForNewDay addObject:newMessage];
    }
    
    [_tableView reloadData];
    CGFloat y = _tableView.contentSize.height - _tableView.frame.size.height;
    [_tableView setContentOffset:CGPointMake(0, y)];
}

#pragma mark -
#pragma mark AppChat delegate methods
- (void) appChatDidReceiveMessage:(ChatMessage *)message {
    NSLog(@"appChatDidReceiveMessage: %@", message.message);
    
    if(message)
        [self putNewMessageInArray:message];
}

#pragma mark -
#pragma mark UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_messages count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [_messages objectAtIndex:section];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [_messages objectAtIndex:indexPath.section];
    if(!rows)
        return 0;
    
    CGFloat height = 0;
    
    NSString *keyForHeight = [NSString stringWithFormat:@"%lu_%lu", (unsigned long)indexPath.section, (unsigned long)indexPath.row];
    NSNumber *numHeight = [chatRowHeightCache objectForKey:keyForHeight];
    if(numHeight){
        height = [numHeight floatValue];
    }
    else{
        ChatMessage *chatMessage = rows[indexPath.row];
        
        BOOL theSameUser = NO;
        if(indexPath.row > 0){
            ChatMessage *prevMessage = rows[indexPath.row - 1];
            if(prevMessage.userId == chatMessage.userId)
                theSameUser = YES;
        }
        
        if(chatMessage.userId == currentUserId){
            height = [ChatRightTableViewCell heightRowForMessage:chatMessage.message andWidth:tableView.bounds.size.width showUserName:!theSameUser];
        }
        else{
            height = [ChatTableViewCell heightRowForMessage:chatMessage.message andWidth:tableView.bounds.size.width showUserName:!theSameUser];
        }
        
        numHeight = [NSNumber numberWithFloat:height];
        [chatRowHeightCache setObject:numHeight forKey:keyForHeight];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 70.0f;
    else
        return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *messagesOfSection = _messages[section];
    if(messagesOfSection.count <= 0)
        return nil;
    
    ChatMessage *firstMsg = messagesOfSection[0];
    
    NSString *title;
    if([firstMsg.fullDate isToday])
        title = NSLocalizedString(@"TXT_TODAY", nil);
    else
        title = [firstMsg.fullDate toFormat:@"LLLL d"];
    
    if(!title)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35.0f)];
    //view.backgroundColor = [UIColor redColor];
    
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11.0f];
    
    label.layer.borderWidth = 0.0;
    label.layer.cornerRadius = 12.0;
    label.layer.backgroundColor = [[UIColor colorWithRGBA:BG_CHAT_TITLE_COLOR] CGColor];
    
    [view addSubview:label];
    
    [NSLayoutConstraint setWidht:80 height:24 forView:label];
    [NSLayoutConstraint setBottomPadding:3 forView:label inContainer:view];
    [NSLayoutConstraint centerHorizontal:label withView:view inContainer:view];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const LeftChatCellIdentifier = @"LeftChatCellIdentifier";
    static NSString *const RightChatCellIdentifier = @"RightChatCellIdentifier";
    
    NSArray *rows = [_messages objectAtIndex:indexPath.section];
    ChatMessage *chatMessage = rows[indexPath.row];
    BOOL isMessageOfCurrentUser = (chatMessage.userId == currentUserId);
    
    UITableViewCell *cell = nil;
    if(isMessageOfCurrentUser){
        cell = [tableView dequeueReusableCellWithIdentifier:RightChatCellIdentifier];
        if(cell == nil){
            cell = [[ChatRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RightChatCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:LeftChatCellIdentifier];
        if(cell == nil){
            cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LeftChatCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [_messages objectAtIndex:indexPath.section];
    ChatMessage *chatMessage = rows[indexPath.row];
    BOOL isMessageOfCurrentUser = (chatMessage.userId == currentUserId);
    
    //ChatRightTableViewCell *chatCell = (ChatRightTableViewCell *)cell;
    ChatTableViewCell *chatCell = (ChatTableViewCell *)cell;
    
    BOOL theSameUser = NO;
    if(indexPath.row > 0){
        ChatMessage *prevMessage = rows[indexPath.row - 1];
        if(prevMessage.userId == chatMessage.userId)
            theSameUser = YES;
    }
    
    chatCell.showUserName = !theSameUser;
    
    if(!theSameUser){
        NSString *keyForUserAvatar = [NSString stringWithFormat:@"%lu", (unsigned long)chatMessage.userId];
        __block UIImage *avatar = [avatarCache objectForKey:keyForUserAvatar];
        if(avatar){
            chatCell.ivPhoto.image = avatar;
        }
        else{
            if(chatMessage.avatarLink){
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:chatMessage.avatarLink]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        avatar = [UIImage imageForAvatar:[UIImage imageWithData:data]];
                        [avatarCache setObject:avatar forKey:keyForUserAvatar];
                        chatCell.ivPhoto.image = avatar;
                    });
                });
            }
            else{
                avatar = [UIImage imageForAvatarDefault:[UIImage imageNamed:@"ic_avatar.png"] text:chatMessage.userName];
                [avatarCache setObject:avatar forKey:keyForUserAvatar];
                chatCell.ivPhoto.image = avatar;
            }
        }
        
        chatCell.ivPhoto.contentMode = UIViewContentModeCenter;
        
        chatCell.ivPhoto.layer.borderWidth = 0.0;
        chatCell.ivPhoto.layer.cornerRadius = kPhotoSize / 2;
        chatCell.ivPhoto.layer.masksToBounds = YES;
    }
    else{
        chatCell.ivPhoto.image = nil;
    }
    
    if(chatMessage.userName.length > 0)
        chatCell.userNameLabel.text = chatMessage.userName;
    else
        chatCell.userNameLabel.text = NSLocalizedString(@"TXT_GUEST", nil);
    
    chatCell.userNameLabel.textColor = [UIColor colorWithRGBA:CHAT_USERNAME_COLOR];
    
    chatCell.userMessage.text = chatMessage.message;
    chatCell.userMessage.textColor = [UIColor blackColor];
    
    chatCell.timeLabel.text = chatMessage.time;
    chatCell.timeLabel.textColor = [UIColor grayColor];
    
    
    if(isMessageOfCurrentUser){
        if(theSameUser)
            [chatCell setBackgroundImageForMessageView:[UIImage imageNamed:@"bg_chat_right_message_ellipse.png"]];
        else
            [chatCell setBackgroundImageForMessageView:[UIImage imageNamed:@"bg_chat_right_message.png"]];
    }
    else{
        if(theSameUser)
            [chatCell setBackgroundImageForMessageView:[UIImage imageNamed:@"bg_chat_message_ellipse.png"]];
        else
            [chatCell setBackgroundImageForMessageView:[UIImage imageNamed:@"bg_chat_message.png"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    if(currentUserId == game.adminId){
        UIButton* btnChange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnChange setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
        [btnChange addTarget:self action:@selector(btnChangeClick) forControlEvents:UIControlEventTouchUpInside];
        [btnChange setTitle:NSLocalizedString(@"BTN_CHANGE", nil) forState:UIControlStateNormal];
        btnChange.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btnChange setUserInteractionEnabled:YES];
        [btnChange setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
        [btnChange setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
        [btnChange sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnChange];
    }
}

#pragma mark -
#pragma mark ChatContent view
- (void) setupChatContentView {
    [self layoutChatContainerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_chatContentView addSubview:_tableView];
    
    _chatFooterView = [UIView new];
    _chatFooterView.translatesAutoresizingMaskIntoConstraints = NO;
    _chatFooterView.backgroundColor = [UIColor colorWithRGBA:BG_CHAT_INPUT_CONTAINER_COLOR];
    [_chatContentView addSubview:_chatFooterView];
    _chatFooterView.backgroundColor = [UIColor greenColor];
    
    [NSLayoutConstraint stretchHorizontal:_tableView inContainer:_chatContentView withPadding:0];
    [NSLayoutConstraint stretchHorizontal:_chatFooterView inContainer:_chatContentView withPadding:0];
    footerViewHeightConstraint = [NSLayoutConstraint setHeight:kFooterHeightNormal forView:_chatFooterView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_tableView, _chatFooterView);
    
    NSString* vc_str = @"V:|-0-[_tableView]-0-[_chatFooterView]-0-|";
    NSArray* vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vc_str options:0 metrics:nil views:views];
    [_chatContentView addConstraints:vConstraints];
    
    [self layoutFooterContent];
}

- (void) layoutChatContainerView {
    _chatContentView = [UIView new];
    _chatContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_chatContentView];
    
    [NSLayoutConstraint stretch:_chatContentView inContainer:self.view withPadding:0];
}

- (void) layoutFooterContent {
    [self setupMessageField];
    [self setupSendButton];
    
    [NSLayoutConstraint setWidht:30 height:30 forView:_btnSend];
    [NSLayoutConstraint setBottomPadding:10 forView:_btnSend inContainer:_chatFooterView];
    
    messageHeightConstraint = [NSLayoutConstraint setHeight:kMsgInputHeightNormal forView:_tfMessage];
    [NSLayoutConstraint setBottomPadding:10 forView:_tfMessage inContainer:_chatFooterView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_tfMessage, _btnSend);
    NSString* hc_str = @"H:|-8-[_tfMessage]-8-[_btnSend]-8-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_chatFooterView addConstraints:hzConstraints];
}

- (void) setupMessageField {
    _tfMessage = [UITextView new];
    _tfMessage.translatesAutoresizingMaskIntoConstraints = NO;
    _tfMessage.delegate = self;
    _tfMessage.font = [UIFont systemFontOfSize:14.0f];
    _tfMessage.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _tfMessage.layer.borderWidth = 0.0;
    _tfMessage.layer.cornerRadius = 6.0;
    _tfMessage.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    [_chatFooterView addSubview:_tfMessage];
}

- (void) setupSendButton {
    _btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSend.enabled = NO;
    _btnSend.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnSend addTarget:self action:@selector(btnSendClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSend setImage:[UIImage imageNamed:@"ic_send_active.png"] forState:UIControlStateNormal];
    [_btnSend setImage:[UIImage imageNamed:@"ic_send.png"] forState:UIControlStateDisabled];
    [_chatFooterView addSubview:_btnSend];
}

#pragma mark -
#pragma mark Curtain view
- (void) setupCurtainView {
    _curtainView = [UIView new];
    _curtainView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainView.backgroundColor = [UIColor colorWithRGBA:ROW_SEPARATOR_COLOR];
    _curtainView.clipsToBounds = YES;
    [self.view addSubview:_curtainView];
    
    [NSLayoutConstraint setTopPadding:0 forView:_curtainView inContainer:self.view];
    [NSLayoutConstraint stretchHorizontal:_curtainView inContainer:self.view withPadding:0];
    curtainHeigtContraint = [NSLayoutConstraint setHeight:kCurtainHeight forView:_curtainView];
    
    isCurtainOpen = YES;
    
    [self setupCurtainArrowView];
    [self layoutFirstRowCurtain];
    [self layoutSecondRowCurtain];
    [self layoutThirdRowCurtain];
}

#pragma mark -
#pragma mark Arrow View
- (void) setupCurtainArrowView { // 224x104 // 115x54
    _curtainArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _curtainArrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_curtainArrowButton addTarget:self action:@selector(tapCurtainArrow) forControlEvents:UIControlEventTouchUpInside];
    
    _curtainArrowButton.adjustsImageWhenHighlighted = NO;
    
    if(isCurtainOpen){
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_up.png"] forState:UIControlStateNormal];
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_up_active.png"] forState:UIControlStateHighlighted];
    }
    else{
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down.png"] forState:UIControlStateNormal];
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down_active.png"] forState:UIControlStateHighlighted];
    }
    
    [self.view addSubview:_curtainArrowButton];
    
    [NSLayoutConstraint setWidht:57.5 height:27 forView:_curtainArrowButton];
    [NSLayoutConstraint setTopDistance:0.5 fromView:_curtainArrowButton toView:_curtainView inContainer:self.view];
    [NSLayoutConstraint centerHorizontal:_curtainArrowButton withView:_curtainView inContainer:self.view];
}

#pragma mark -
#pragma mark First row
- (void) layoutFirstRowCurtain {
    _curtainRowOneView = [UIView new];
    _curtainRowOneView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowOneView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowOneView];
    
    [NSLayoutConstraint setHeight:57.5 forView:_curtainRowOneView];
    [NSLayoutConstraint stretchHorizontal:_curtainRowOneView inContainer:_curtainView withPadding:0];
    [NSLayoutConstraint setTopPadding:0 forView:_curtainRowOneView inContainer:_curtainView];
    
    UIView* separator = [UIView new];
    [self setupSeparator:separator intoGroup:_curtainRowOneView];
    
    UIImageView* locIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_location_gray.png"]];
    [_curtainRowOneView addSubview:locIcon];
    locIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:13.5f height:13.5f forView:locIcon];
    
    locTitle = [self makeLocationLable];
    [_curtainRowOneView addSubview:locTitle];
    locTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:locTitle];
    [NSLayoutConstraint centerVertical:locTitle withView:locIcon inContainer:_curtainRowOneView];
    //[NSLayoutConstraint ];
    
    UIImageView* timeIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_time_gray.png"]];
    [_curtainRowOneView addSubview:timeIcon];
    timeIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:13.5f height:13.5f forView:timeIcon];
    
    timeTitle = [self makeTimeLable];
    [_curtainRowOneView addSubview:timeTitle];
    timeTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:timeTitle];
    [NSLayoutConstraint centerVertical:timeTitle withView:timeIcon inContainer:_curtainRowOneView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(locTitle, locIcon, timeTitle, timeIcon, separator);
    
    NSString* hc1_str = @"H:|-12-[locIcon]-5.5-[locTitle]-(>=12)-|";
    NSArray* hz1Constraints = [NSLayoutConstraint constraintsWithVisualFormat:hc1_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:hz1Constraints];
    
    NSString* hc2_str = @"H:|-12-[timeIcon]-6-[timeTitle]";
    NSArray* hz2Constraints = [NSLayoutConstraint constraintsWithVisualFormat:hc2_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:hz2Constraints];
    
    //V
    NSString* vc1_str = @"V:|-9-[locIcon]";
    NSArray* vz1Constraints = [NSLayoutConstraint constraintsWithVisualFormat:vc1_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:vz1Constraints];
    
    NSString* vc2_str = @"V:[timeIcon]-9-|";
    NSArray* vz2Constraints = [NSLayoutConstraint constraintsWithVisualFormat:vc2_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:vz2Constraints];
}

- (void) setupSeparator:(UIView*)separator intoGroup:(UIView*)group {
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithRGBA:CELL_SEPARATOR_COLOR];
    [group addSubview:separator];
    
    [NSLayoutConstraint setHeight:0.5f forView:separator];
    [NSLayoutConstraint stretchHorizontal:separator inContainer:group withPadding:kHorizontalPadding];
    [NSLayoutConstraint centerVertical:separator withView:group inContainer:group];
}

- (UIImageView*) makeFirstRowIconWithImage:(UIImage*)image {
    UIImageView* icon = [UIImageView new];
    icon.image = image;
    return icon;
}

- (UILabel*) makeTimeLable {
    UILabel* lable = [UILabel new];
    lable.text = [self titleForTimeLable:game];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:11.0f];
    //[lable sizeToFit];
    return lable;
}

- (UILabel*) makeLocationLable {
    UILabel* lable = [UILabel new];
    lable.text = [self titleForLocationLable:game];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    lable.font = [UIFont systemFontOfSize:11.0f];
    //[lable sizeToFit];
    return lable;
}

- (NSString *) titleForTimeLable:(GameInfo *)gameInfo {
    return [NSString stringWithFormat:@"%@ %@", gameInfo.time, gameInfo.date]; //@"10:00 через 3 дня";
}

- (NSString *) titleForLocationLable:(GameInfo *)gameInfo {
    NSString *text = NSLocalizedString(@"TXT_PLACE_UNKNOWN", nil);
    
    BOOL hasAddressName = (gameInfo.addressName.length > 0);
    BOOL hasAddress = (gameInfo.address.length > 0);
    
    if(hasAddressName && hasAddress)
        text = [NSString stringWithFormat:@"%@, %@", gameInfo.addressName, gameInfo.address];
    else if(hasAddressName)
        text = [NSString stringWithFormat:@"%@", gameInfo.addressName];
    else if(hasAddress)
        text = [NSString stringWithFormat:@"%@", gameInfo.address];
    
    return text;
}

#pragma mark -
#pragma mark Second row
- (void) layoutSecondRowCurtain {
    _curtainRowTwoView = [UIView new];
    _curtainRowTwoView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowTwoView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowTwoView];
    
    [NSLayoutConstraint setHeight:57.5 forView:_curtainRowTwoView];
    [NSLayoutConstraint stretchHorizontal:_curtainRowTwoView inContainer:_curtainView withPadding:0];
    [NSLayoutConstraint setTopDistance:0.5f fromView:_curtainRowTwoView toView:_curtainRowOneView inContainer:_curtainView];
    
    [self createPeopleInGameLable];
    [_curtainRowTwoView addSubview:_peopleInGame];
    _peopleInGame.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:20 forView:_peopleInGame];
    [NSLayoutConstraint centerVertical:_peopleInGame withView:_curtainRowTwoView inContainer:_curtainRowTwoView];
    
    [self createPeopleNeedLable];
    [_curtainRowTwoView addSubview:_peopleNeed];
    _peopleNeed.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:20 forView:_peopleInGame];
    [NSLayoutConstraint centerVertical:_peopleNeed withView:_curtainRowTwoView inContainer:_curtainRowTwoView];
    
    [self createInviteUserButton];
    [_curtainRowTwoView addSubview:_btnInviteUser];
    _btnInviteUser.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:83 height:24.5 forView:_btnInviteUser];
    [NSLayoutConstraint centerVertical:_btnInviteUser withView:_curtainRowTwoView inContainer:_curtainRowTwoView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_peopleInGame, _peopleNeed, _btnInviteUser);
    NSString* hc_str = @"H:|-12-[_peopleInGame]-10-[_peopleNeed]-(>=1)-[_btnInviteUser]-12-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_curtainRowTwoView addConstraints:hzConstraints];
}

- (void) createPeopleInGameLable {
    _peopleInGame = [UILabel new];
    _peopleInGame.text = [NSString stringWithFormat:NSLocalizedString(@"TXT_GOTO_PEOPLE", nil), (unsigned long)game.members.count];
    _peopleInGame.textAlignment = NSTextAlignmentLeft;
    _peopleInGame.font = [UIFont systemFontOfSize:12.0f];
    _peopleInGame.textColor = [UIColor colorWithRGBA:TXT_LINK_COLOR];
    [_peopleInGame sizeToFit];
    
    _peopleInGame.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGamers)];
    [_peopleInGame addGestureRecognizer:tapGesture];
}

- (void) createPeopleNeedLable {
    NSInteger diff = game.numbers - game.members.count;
    
    NSUInteger needle = 0;
    if(diff > 0)
        needle = diff;
    
    _peopleNeed = [UILabel new];
    _peopleNeed.text = [NSString stringWithFormat:NSLocalizedString(@"TXT_NEED_MORE", nil), (unsigned long)needle]; //@"Нужно ещё 3";
    _peopleNeed.textAlignment = NSTextAlignmentLeft;
    _peopleNeed.font = [UIFont systemFontOfSize:12.0f];
    _peopleNeed.textColor = [UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR];
    [_peopleNeed sizeToFit];
}

- (void) createInviteUserButton {
    _btnInviteUser = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_btnInviteUser addTarget:self action:@selector(btnInviteUserClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnInviteUser setTitle:NSLocalizedString(@"TXT_INVITE", nil) forState:UIControlStateNormal];
    _btnInviteUser.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [_btnInviteUser setTitleColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateNormal];
    [_btnInviteUser setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_btnInviteUser setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [_btnInviteUser setBackgrounColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_btnInviteUser setBackgrounColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateSelected];
    [_btnInviteUser setBackgrounColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateHighlighted];
    
    [_btnInviteUser setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateNormal];
    [_btnInviteUser setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateSelected];
    [_btnInviteUser setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateHighlighted];
    
    _btnInviteUser.layer.borderWidth = 0.5;
    _btnInviteUser.layer.cornerRadius = 6.0;
}

#pragma mark -
#pragma mark Third row
- (void) layoutThirdRowCurtain {
    _curtainRowThreeView = [UIView new];
    _curtainRowThreeView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowThreeView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowThreeView];
    
    [NSLayoutConstraint setHeight:57.5 forView:_curtainRowThreeView];
    [NSLayoutConstraint stretchHorizontal:_curtainRowThreeView inContainer:_curtainView withPadding:0];
    [NSLayoutConstraint setTopDistance:0.5f fromView:_curtainRowThreeView toView:_curtainRowTwoView inContainer:_curtainView];
    
    [self createYesButton];
    [_curtainRowThreeView addSubview:_btnAnswerYes];
    _btnAnswerYes.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:kUserStatusButtonWidth height:kUserStatusButtonHeight forView:_btnAnswerYes];
    [NSLayoutConstraint centerVertical:_btnAnswerYes withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    [self createPerhapsButton];
    [_curtainRowThreeView addSubview:_btnAnswerPerhaps];
    _btnAnswerPerhaps.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:kUserStatusButtonWidth height:kUserStatusButtonHeight forView:_btnAnswerPerhaps];
    [NSLayoutConstraint centerVertical:_btnAnswerPerhaps withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    [NSLayoutConstraint centerHorizontal:_btnAnswerPerhaps withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    [self createNoButton];
    [_curtainRowThreeView addSubview:_btnAnswerNo];
    _btnAnswerNo.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:kUserStatusButtonWidth height:kUserStatusButtonHeight forView:_btnAnswerNo];
    [NSLayoutConstraint centerVertical:_btnAnswerNo withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_btnAnswerYes, _btnAnswerPerhaps, _btnAnswerNo);
    NSString* hc_str = @"H:|-12-[_btnAnswerYes]-(>=1)-[_btnAnswerPerhaps]-(>=1)-[_btnAnswerNo]-12-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_curtainRowThreeView addConstraints:hzConstraints];
}

- (void) createYesButton {
    _btnAnswerYes = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_btnAnswerYes addTarget:self action:@selector(btnUserDecisionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerYes setTitle:NSLocalizedString(@"BTN_GOING", nil) forState:UIControlStateNormal];
    _btnAnswerYes.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _btnAnswerYes.titleLabel.shadowColor = [UIColor blackColor];
    
    [_btnAnswerYes setTitleColor:[UIColor colorWithRGBA:BTN_YES_COLOR] forState:UIControlStateNormal];
    [_btnAnswerYes setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [_btnAnswerYes setBackgrounColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_btnAnswerYes setBackgrounColor:[UIColor colorWithRGBA:BTN_YES_COLOR] forState:UIControlStateSelected];
    
    [_btnAnswerYes setBorderColor:[UIColor colorWithRGBA:BTN_YES_COLOR] forState:UIControlStateNormal];
    [_btnAnswerYes setBorderColor:[UIColor colorWithRGBA:BTN_YES_COLOR] forState:UIControlStateSelected];
    [_btnAnswerYes setBorderColor:[UIColor colorWithRGBA:BTN_YES_COLOR] forState:UIControlStateHighlighted];
    
    _btnAnswerYes.layer.borderWidth = 0.5;
    _btnAnswerYes.layer.cornerRadius = 6.0;
}

- (void) createPerhapsButton {
    _btnAnswerPerhaps = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_btnAnswerPerhaps addTarget:self action:@selector(btnUserDecisionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerPerhaps setTitle:NSLocalizedString(@"BTN_MAYBE", nil) forState:UIControlStateNormal];
    _btnAnswerPerhaps.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [_btnAnswerPerhaps setTitleColor:[UIColor colorWithRGBA:BTN_PERHAPS_COLOR] forState:UIControlStateNormal];
    [_btnAnswerPerhaps setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [_btnAnswerPerhaps setBackgrounColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_btnAnswerPerhaps setBackgrounColor:[UIColor colorWithRGBA:BTN_PERHAPS_COLOR] forState:UIControlStateSelected];
    
    [_btnAnswerPerhaps setBorderColor:[UIColor colorWithRGBA:BTN_PERHAPS_COLOR] forState:UIControlStateNormal];
    [_btnAnswerPerhaps setBorderColor:[UIColor colorWithRGBA:BTN_PERHAPS_COLOR] forState:UIControlStateSelected];
    [_btnAnswerPerhaps setBorderColor:[UIColor colorWithRGBA:BTN_PERHAPS_COLOR] forState:UIControlStateHighlighted];
    
    _btnAnswerPerhaps.layer.borderWidth = 0.5;
    _btnAnswerPerhaps.layer.cornerRadius = 6.0;
}

- (void) createNoButton {
    _btnAnswerNo = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_btnAnswerNo addTarget:self action:@selector(btnUserDecisionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerNo setTitle:NSLocalizedString(@"BTN_NO", nil) forState:UIControlStateNormal];
    _btnAnswerNo.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [_btnAnswerNo setTitleColor:[UIColor colorWithRGBA:BTN_NO_COLOR] forState:UIControlStateNormal];
    [_btnAnswerNo setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [_btnAnswerNo setBackgrounColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_btnAnswerNo setBackgrounColor:[UIColor colorWithRGBA:BTN_NO_COLOR] forState:UIControlStateSelected];
    
    [_btnAnswerNo setBorderColor:[UIColor colorWithRGBA:BTN_NO_COLOR] forState:UIControlStateNormal];
    [_btnAnswerNo setBorderColor:[UIColor colorWithRGBA:BTN_NO_COLOR] forState:UIControlStateSelected];
    [_btnAnswerNo setBorderColor:[UIColor colorWithRGBA:BTN_NO_COLOR] forState:UIControlStateHighlighted];
    
    _btnAnswerNo.layer.borderWidth = 0.5;
    _btnAnswerNo.layer.cornerRadius = 6.0;
}

- (void) btnUserDecisionClick:(UIButton*)button {
    if(button.selected)
        return;
    
    NSUInteger desireStatus = 0;
    if(button == _btnAnswerYes)
        desireStatus = UserGameParticipateStatusYes;
    else if(button == _btnAnswerPerhaps)
        desireStatus = UserGameParticipateStatusPossible;
    else if(button == _btnAnswerNo)
        desireStatus = UserGameParticipateStatusNo;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking setUserStatusForGame:_gameId status:desireStatus completionHandler:^(NSString *errorMessage) {
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
                [self changeStatusButtons:desireStatus];
                
                if([self.delegate respondsToSelector:@selector(needUpdateGamesWithController:)])
                    [self.delegate needUpdateGamesWithController:self];
            }
        });
    }];
}

- (void) changeStatusButtons:(NSUInteger)desireStatus {
    if(desireStatus == UserGameParticipateStatusYes){
        _btnAnswerYes.selected = YES;
        _btnAnswerPerhaps.selected = NO;
        _btnAnswerNo.selected = NO;
    }
    else if(desireStatus == UserGameParticipateStatusPossible){
        _btnAnswerYes.selected = NO;
        _btnAnswerPerhaps.selected = YES;
        _btnAnswerNo.selected = NO;
    }
    else if(desireStatus == UserGameParticipateStatusNo){
        _btnAnswerYes.selected = NO;
        _btnAnswerPerhaps.selected = NO;
        _btnAnswerNo.selected = YES;
    }
}

#pragma mark -
#pragma mark Buttons click methods
- (void) btnInviteUserClick {
    InviteUserViewController* controller = [[InviteUserViewController alloc] init];
    controller.gameId = _gameId;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnChangeClick {
    NewEvenViewController *controller = [[NewEvenViewController alloc] init];
    controller.isEditGameMode = YES;
    controller.gameId = _gameId;
    controller.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) btnSendClick {
    if(_tfMessage.text.length > 0){
        _btnSend.enabled = NO;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        
        AppUser *appUser = [AppDelegate instance].user;
        AppChat *appChat = [[AppDelegate instance] appChatInstance];
        [appChat sendMessage:_tfMessage.text forGameId:_gameId fromUser:appUser completionHandler:^(BOOL isSent) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            
            if(isSent){
                _btnSend.enabled = NO;
                _tfMessage.text = @"";
                messageHeightConstraint.constant = kMsgInputHeightNormal;
                footerViewHeightConstraint.constant = kFooterHeightNormal;
            }
            else{
                _btnSend.enabled = YES;
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:NSLocalizedString(@"MSG_UNABLE_TO_SEND_A_MESSAGE", nil)
                                      delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL_1", nil)
                                      otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
}

- (void) showGamers {
    MemberViewController *controller = [[MemberViewController alloc] init];
    controller.members = game.members;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
- (void)gameWasSavedWithController:(NewEvenViewController *)controller gameId:(NSUInteger)gameID {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self updateGame:gameID];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:NSLocalizedString(@"MSG_GAME_WAS_CHANGED", nil)
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                          otherButtonTitles:nil];
    
    [alert show];
    
    if([self.delegate respondsToSelector:@selector(needUpdateGamesWithController:)])
        [self.delegate needUpdateGamesWithController:self];
}

- (void) updateGame:(NSUInteger)gID {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking gameById:gID completionHandler:^(GameInfo *gameInfo, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            
            if(!errorMessage){
                game = gameInfo;
                
                [self setNavTitle:game.gameName];
                locTitle.text = [self titleForLocationLable:game];
                timeTitle.text = [self titleForTimeLable:game];
                
                _peopleInGame.text = [NSString stringWithFormat:NSLocalizedString(@"TXT_GOTO_PEOPLE", nil), (unsigned long)game.members.count];
                
                NSInteger diff = game.numbers - game.members.count;
                NSUInteger needle = 0;
                if(diff > 0)
                    needle = diff;
                
                _peopleNeed.text = [NSString stringWithFormat:NSLocalizedString(@"TXT_NEED_MORE", nil), (unsigned long)needle];
                
                [self changeStatusButtons:game.participateStatus];
            }
        });
    }];
}

#pragma mark -
#pragma mark close/open Curtain view
- (void) tapCurtainArrow {
    if(isCurtainOpen){
        isCurtainOpen = NO;
        [self closeCurtainView];
        
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down.png"] forState:UIControlStateNormal];
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down_active.png"] forState:UIControlStateSelected];
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down_active.png"] forState:UIControlStateHighlighted];
    }
    else{
        isCurtainOpen = YES;
        [self openCurtainView];
        
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_up.png"] forState:UIControlStateNormal];
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_up_active.png"] forState:UIControlStateSelected];
        [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_up_active.png"] forState:UIControlStateHighlighted];
    }
}

- (void) closeCurtainView {
    [UIView animateWithDuration:0.4 animations:^{
        curtainHeigtContraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void) openCurtainView {
    [UIView animateWithDuration:0.4 animations:^{
        curtainHeigtContraint.constant = kCurtainHeight;
        [self.view layoutIfNeeded];
    }];
}

- (void) moveCurtainView:(UIPanGestureRecognizer*)recognizer {
    if(recognizer.state == UIGestureRecognizerStateChanged){
        
        CGPoint delta = [recognizer translationInView:self.view];
        CGFloat newHeight = curtainHeigtContraint.constant;
        
        CGFloat maxStep = 6;
        CGFloat value = (delta.y < 0) ? delta.y * -1 : delta.y;
        
        if(value > 2){
            if(delta.y > 0){
                if(delta.y > maxStep)
                    newHeight = curtainHeigtContraint.constant + maxStep;
                else
                    newHeight = curtainHeigtContraint.constant + delta.y;
            }
            else if(delta.y < 0){
                if(delta.y < maxStep)
                    newHeight = curtainHeigtContraint.constant - maxStep;
                else
                    newHeight = curtainHeigtContraint.constant + delta.y;
            }
            
            if(newHeight < kCurtainHeight && newHeight > 0){
                curtainHeigtContraint.constant = newHeight;
            }
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        if(curtainHeigtContraint.constant < kCurtainHeight/2)
            curtainHeigtContraint.constant = 0;
        else
            curtainHeigtContraint.constant = kCurtainHeight;
    }
}

#pragma mark -
#pragma mark UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //[self scrollToCursorForTextView:textView];
}

- (void) textViewDidChange:(UITextView *)textField {
    if (textField == _tfMessage){
        if([textField.text isEmpty]){
            _btnSend.enabled = NO;
            _btnSend.userInteractionEnabled = NO;
        }
        else{
            _btnSend.enabled = YES;
            _btnSend.userInteractionEnabled = YES;
        }
        
        CGFloat fixedWidth = textField.frame.size.width;
        CGSize newSize = [textField sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        
        if(newSize.height == textField.frame.size.height)
            return;
        
        if(newSize.height < kMsgInputHeightMax){
            int diffH = kFooterHeightNormal - kMsgInputHeightNormal;
            messageHeightConstraint.constant = newSize.height;
            footerViewHeightConstraint.constant = newSize.height + diffH;
            
            [self.view layoutIfNeeded];
            CGFloat y = _tableView.contentSize.height - _tableView.frame.size.height;
            [_tableView setContentOffset:CGPointMake(0, y)];
        }
    }
}

- (void)scrollToCursorForTextView: (UITextView*)textView {
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}

- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect newRect = self.view.frame;
    newRect.size.height = mainViewHeight - kbSize.height;
    NSLog(@"%f, %f", newRect.size.width, newRect.size.height);
    
    self.view.frame = newRect;
    [self.view layoutIfNeeded];
    
    CGFloat y = _tableView.contentSize.height - _tableView.frame.size.height;
    [_tableView setContentOffset:CGPointMake(0, y)];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect newRect = self.view.frame;
    newRect.size.height = mainViewHeight;
    self.view.frame = newRect;
    [self.view layoutIfNeeded];
    
    CGFloat y = _tableView.contentSize.height - _tableView.frame.size.height;
    [_tableView setContentOffset:CGPointMake(0, y)];
}

@end












