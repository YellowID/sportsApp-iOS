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
#import "CustomButton.h"
#import "ChatTableViewCell.h"
#import "ChatRightTableViewCell.h"
#import "NSLayoutConstraint+Helper.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "ChatMessage.h"

#import <Quickblox/Quickblox.h>

#define PHOTO_SIZE 40
#define CURTAIN_HEIGT 174
#define PADDING_H 12

#define TMP_MSG @"Всем привет! Сегодня играем!! Расскажите всем. Соберем большую команду)"

// curtain
@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark -
#pragma mark Containers
//@property (strong, nonatomic) UIScrollView* chatScrollView;
@property (strong, nonatomic) UIView* chatContentView;
@property (strong, nonatomic) UIView* chatFooterView;
@property (strong, nonatomic) UITextField* tfMessage;
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
@property (strong, nonatomic) NSArray *sectionNames;

@end

@implementation ChatViewController{
    NSLayoutConstraint* curtainHeigtContraint;
    BOOL isCurtainOpen;
    
    CGFloat mainViewHeight;
    
    NSUInteger currentUserId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"Волейбол"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_chat.png"]];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self setNavigationItems];
    
    [self loadChatMessages];
    
    [self setupChatContentView];
    [self setupCurtainView];
    
    /*
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        //NSLog(@"QBResponse: %@", response.debugDescription);
        //NSLog(@"QBASession: %@", session.debugDescription);
        
        //register
        QBUUser *user = [QBUUser user];
        user.login = @"TestUser1";
        user.password = @"ahtrahtrahtr1";
        user.externalUserID = 758902384;
        
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            NSLog(@"QBUUser: %@", user.debugDescription);
        }
        errorBlock:^(QBResponse *response) {
            NSLog(@"QBResponse: %@", response.debugDescription);
        }];
        
        //login
        [QBRequest logInWithUserLogin:@"TestUser1" password:@"ahtrahtrahtr1" successBlock:^(QBResponse *response, QBUUser *user) {
            NSLog(@"QBUUser: %@", user.debugDescription);
        } errorBlock:^(QBResponse *response) {
            NSLog(@"QBResponse: %@", response.debugDescription);
        }];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"QBResponse: %@", response.debugDescription);
    }];
     */
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

#pragma mark -
#pragma mark TEMP
- (void) loadChatMessages {
    currentUserId = 0;
    
    _sectionNames = @[@"Апрель 23", @"сегодня"];
    _messages = [NSMutableArray new];
    
    // day1
    NSMutableArray *day1 = [NSMutableArray new];
    ChatMessage *msg1 = [ChatMessage new];
    msg1.userName = @"Антон Якушев";
    msg1.userId = 1;
    msg1.time = @"10:00";
    msg1.message = @"Всем привет! Сегодня играем!! Расскажите всем. Соберем большую команду)";
    [day1 addObject:msg1];
    
    ChatMessage *msg2 = [ChatMessage new];
    msg2.userName = @"Павел Ларчик";
    msg2.userId = 2;
    msg2.time = @"10:05";
    msg2.message = @"Да?";
    [day1 addObject:msg2];
    
    ChatMessage *msg3 = [ChatMessage new];
    msg3.userName = @"Саша Лукашенко";
    msg3.userId = 3;
    msg3.time = @"10:12";
    msg3.message = @"Я тоже у хакей!";
    [day1 addObject:msg3];
    
    ChatMessage *msg4 = [ChatMessage new];
    msg4.userName = @"Я";
    msg4.userId = 0;
    msg4.time = @"13:00";
    msg4.message = @"У хакей играют самыя настоящие мужчыны.";
    [day1 addObject:msg4];
    
    [_messages addObject:day1];
    
    // day2
    NSMutableArray *day2 = [NSMutableArray new];
    ChatMessage *msg21 = [ChatMessage new];
    msg21.userName = @"Антон Якушев";
    msg21.userId = 1;
    msg21.time = @"11:02";
    msg21.message = @"Саня, будешь шайбу подавать";
    [day2 addObject:msg21];
    
    ChatMessage *msg22 = [ChatMessage new];
    msg22.userName = @"Саша Лукашенко";
    msg22.userId = 3;
    msg22.time = @"11:03";
    msg22.message = @"Я на усё сагаласен";
    [day2 addObject:msg22];
    
    ChatMessage *msg23 = [ChatMessage new];
    msg23.userName = @"Павел Ларчик";
    msg23.userId = 2;
    msg23.time = @"11:23";
    msg23.message = @"А где играем?";
    [day2 addObject:msg23];
    
    ChatMessage *msg24 = [ChatMessage new];
    msg24.userName = @"Я";
    msg24.userId = 0;
    msg24.time = @"11:25";
    msg24.message = @"В зале";
    [day2 addObject:msg24];
    
    [_messages addObject:day2];
    
}

#pragma mark -
#pragma mark UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sectionNames count];
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
    
    ChatMessage *chatMessage = rows[indexPath.row];
    if(chatMessage.userId == currentUserId)
        height = [ChatRightTableViewCell heightRowForMessage:chatMessage.message andWidth:tableView.bounds.size.width];
    else
        height = [ChatTableViewCell heightRowForMessage:chatMessage.message andWidth:tableView.bounds.size.width];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 70.0f;
    else
        return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = _sectionNames[section];
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
    [NSLayoutConstraint alignBottom:label inContainer:view];
    [NSLayoutConstraint centerHorizontal:label withView:view inContainer:view];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LeftChatCellIdentifier = @"LeftChatCellIdentifier";
    static NSString *RightChatCellIdentifier = @"RightChatCellIdentifier";
    
    UITableViewCell *cell = nil;
    
    NSArray *rows = [_messages objectAtIndex:indexPath.section];
    ChatMessage *chatMessage = rows[indexPath.row];
    
    BOOL isMessageOfCurrentUser = (chatMessage.userId == currentUserId);
    
    if(isMessageOfCurrentUser){
        cell = [tableView dequeueReusableCellWithIdentifier:RightChatCellIdentifier];
        if(cell == nil)
            cell = [[ChatRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RightChatCellIdentifier];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:LeftChatCellIdentifier];
        if(cell == nil)
            cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LeftChatCellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ChatRightTableViewCell *chatCell = (ChatRightTableViewCell *)cell;
    
    UIImage* im = [UIImage imageNamed:@"photo.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PHOTO_SIZE, PHOTO_SIZE), YES, 0);
    [im drawInRect:CGRectMake(0, 0, PHOTO_SIZE, PHOTO_SIZE)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    chatCell.ivPhoto.image = im2;
    chatCell.ivPhoto.contentMode = UIViewContentModeCenter;
    
    chatCell.ivPhoto.layer.borderWidth = 0.0;
    chatCell.ivPhoto.layer.cornerRadius = PHOTO_SIZE / 2;
    chatCell.ivPhoto.layer.masksToBounds = YES;
    
    chatCell.userNameLabel.text = chatMessage.userName;
    chatCell.userNameLabel.textColor = [UIColor blueColor];
    
    chatCell.userMessage.text = chatMessage.message;
    chatCell.userMessage.textColor = [UIColor blackColor];
    
    chatCell.timeLabel.text = chatMessage.time;
    chatCell.timeLabel.textColor = [UIColor grayColor];
    
    if(isMessageOfCurrentUser)
        [chatCell setBackgroundImageForMessageView:[UIImage imageNamed:@"bg_chat_right_message.png"]];
    else
        [chatCell setBackgroundImageForMessageView:[UIImage imageNamed:@"bg_chat_message.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIButton* btnChange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnChange setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnChange addTarget:self action:@selector(btnChangeClick) forControlEvents:UIControlEventTouchUpInside];
    [btnChange setTitle:@"Изменить" forState:UIControlStateNormal];
    btnChange.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnChange setUserInteractionEnabled:NO];
    [btnChange setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnChange setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    [btnChange sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnChange];
}

#pragma mark -
#pragma mark ChatContent view
- (void) setupChatContentView {
    [self layoutChatContainerView];
    
    _chatFooterView = [UIView new];
    _chatFooterView.translatesAutoresizingMaskIntoConstraints = NO;
    _chatFooterView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_chatContentView addSubview:_chatFooterView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_chatContentView addSubview:_tableView];
    
    [NSLayoutConstraint stretchHorizontal:_tableView inContainer:_chatContentView];
    [NSLayoutConstraint stretchHorizontal:_chatFooterView inContainer:_chatContentView];
    [NSLayoutConstraint setHeight:50 forView:_chatFooterView];
    
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
    
    [NSLayoutConstraint stretch:_chatContentView inContainer:self.view];
}

- (void) layoutFooterContent {
    [self setupMessageField];
    [self setupSendButton];
    
    //[NSLayoutConstraint setWidht:20 height:18.5 forView:_btnSend];
    [NSLayoutConstraint setWidht:30 height:30 forView:_btnSend];
    [NSLayoutConstraint centerVertical:_btnSend withView:_chatFooterView inContainer:_chatFooterView];
    
    [NSLayoutConstraint setHeight:30 forView:_tfMessage];
    [NSLayoutConstraint centerVertical:_tfMessage withView:_chatFooterView inContainer:_chatFooterView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_tfMessage, _btnSend);
    
    NSString* hc_str = @"H:|-8-[_tfMessage]-8-[_btnSend]-8-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_chatFooterView addConstraints:hzConstraints];
}

- (void) setupMessageField {
    _tfMessage = [UITextField new];
    _tfMessage.translatesAutoresizingMaskIntoConstraints = NO;
    [_tfMessage setBorderStyle:UITextBorderStyleRoundedRect];
    [_tfMessage addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tfMessage.delegate = self;
    _tfMessage.placeholder = @"";//@"ваше сообщение";
    _tfMessage.backgroundColor = [UIColor whiteColor];
    _tfMessage.font = [UIFont systemFontOfSize:12.0f];
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
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:0]];
    
    curtainHeigtContraint = [NSLayoutConstraint constraintWithItem:_curtainView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:0
                                                                    toItem:nil
                                                                 attribute:0
                                                                multiplier:1
                                                                  constant:0];
    [_curtainView addConstraint: curtainHeigtContraint];
    
    [self setupCurtainArrowView];
    [self layoutFirstRowCurtain];
    [self layoutSecondRowCurtain];
    [self layoutThirdRowCurtain];
}

#pragma mark -
#pragma mark Arrow View
- (void) setupCurtainArrowView { // 224 104
    _curtainArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _curtainArrowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_curtainArrowButton addTarget:self action:@selector(tapCurtainArrow) forControlEvents:UIControlEventTouchUpInside];
    
    _curtainArrowButton.adjustsImageWhenHighlighted = NO;
    
    [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down.png"] forState:UIControlStateNormal];
    [_curtainArrowButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_slide_down_active.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_curtainArrowButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainArrowButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_curtainView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-0.5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainArrowButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:_curtainView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [NSLayoutConstraint setWidht:60 height:30 forView:_curtainArrowButton];
}

#pragma mark -
#pragma mark First row
- (void) layoutFirstRowCurtain {
    _curtainRowOneView = [UIView new];
    _curtainRowOneView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowOneView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowOneView];
    
    [NSLayoutConstraint setHeight:57.5 forView:_curtainRowOneView];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:0]];
    
    UIView* separator = [UIView new];
    [self setupSeparator:separator intoGroup:_curtainRowOneView];
    
    UIImageView* locIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_location.png"]];
    [_curtainRowOneView addSubview:locIcon];
    locIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:8 height:10.5 forView:locIcon];
    //[NSLayoutConstraint centerVertical:locIcon withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UILabel* locTitle = [self makeLocationLable];
    [_curtainRowOneView addSubview:locTitle];
    locTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:locTitle];
    [NSLayoutConstraint centerVertical:locTitle withView:locIcon inContainer:_curtainRowOneView];
    
    UIImageView* timeIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_time.png"]];
    [_curtainRowOneView addSubview:timeIcon];
    timeIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:10.5 height:11 forView:timeIcon];
    //[NSLayoutConstraint centerVertical:timeIcon withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UILabel* timeTitle = [self makeTimeLable];
    [_curtainRowOneView addSubview:timeTitle];
    timeTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:timeTitle];
    [NSLayoutConstraint centerVertical:timeTitle withView:timeIcon inContainer:_curtainRowOneView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(locTitle, locIcon, timeTitle, timeIcon, separator);
    
    NSString* hc1_str = @"H:|-12-[locIcon]-6.5-[locTitle]";
    NSArray* hz1Constraints = [NSLayoutConstraint constraintsWithVisualFormat:hc1_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:hz1Constraints];
    
    NSString* hc2_str = @"H:|-12-[timeIcon]-4-[timeTitle]";
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
    
    [group addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:0
                                                         toItem:group
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];
    
    [group addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:0
                                                         toItem:group
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:PADDING_H]];
    
    [group addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:0
                                                         toItem:group
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:-PADDING_H]];
    
    [separator addConstraint: [NSLayoutConstraint constraintWithItem:separator
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:0.5f]];
}

- (UIImageView*) makeFirstRowIconWithImage:(UIImage*)image {
    UIImageView* icon = [UIImageView new];
    icon.image = image;
    return icon;
}

- (UILabel*) makeTimeLable {
    UILabel* lable = [UILabel new];
    lable.text = @"10:00 через 3 дня";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:9.0f];
    [lable sizeToFit];
    return lable;
}

- (UILabel*) makeLocationLable {
    UILabel* lable = [UILabel new];
    lable.text = @"Суперзал, ул. Пушкина, 120Д/1";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:9.0f];
    [lable sizeToFit];
    return lable;
}

#pragma mark -
#pragma mark Second row
- (void) layoutSecondRowCurtain {
    _curtainRowTwoView = [UIView new];
    _curtainRowTwoView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowTwoView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowTwoView];
    
    [NSLayoutConstraint setHeight:57.5 forView:_curtainRowTwoView];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowTwoView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:_curtainRowOneView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0.5f]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowTwoView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:0
                                                                toItem:_curtainView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:0]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowTwoView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:0
                                                                toItem:_curtainView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0]];
    
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
    
    /*
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc] initWithString:@"Идут 7 человек"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    _peopleInGame.attributedText = [attributeString copy];
    */
    
    _peopleInGame.text = @"Идут 7 человек";
    _peopleInGame.textAlignment = NSTextAlignmentLeft;
    _peopleInGame.font = [UIFont systemFontOfSize:12.0f];
    _peopleInGame.textColor = [UIColor colorWithRGBA:TXT_LINK_COLOR];
    [_peopleInGame sizeToFit];
    
    _peopleInGame.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGamers)];
    [_peopleInGame addGestureRecognizer:tapGesture];
}

- (void) createPeopleNeedLable {
    _peopleNeed = [UILabel new];
    _peopleNeed.text = @"Нужно ещё 3";
    _peopleNeed.textAlignment = NSTextAlignmentLeft;
    _peopleNeed.font = [UIFont systemFontOfSize:12.0f];
    _peopleNeed.textColor = [UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR];
    [_peopleNeed sizeToFit];
}

- (void) createInviteUserButton {
    _btnInviteUser = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_btnInviteUser addTarget:self action:@selector(btnInviteUserClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnInviteUser setTitle:@"Позвать" forState:UIControlStateNormal];
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
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowThreeView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:_curtainRowTwoView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0.5f]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowThreeView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:0
                                                                toItem:_curtainView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:0]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowThreeView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:0
                                                                toItem:_curtainView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0]];
    
    [self createYesButton];
    [_curtainRowThreeView addSubview:_btnAnswerYes];
    _btnAnswerYes.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:83 height:24.5 forView:_btnAnswerYes];
    [NSLayoutConstraint centerVertical:_btnAnswerYes withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    [self createPerhapsButton];
    [_curtainRowThreeView addSubview:_btnAnswerPerhaps];
    _btnAnswerPerhaps.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:83 height:24.5 forView:_btnAnswerPerhaps];
    [NSLayoutConstraint centerVertical:_btnAnswerPerhaps withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    [NSLayoutConstraint centerHorizontal:_btnAnswerPerhaps withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    [self createNoButton];
    [_curtainRowThreeView addSubview:_btnAnswerNo];
    _btnAnswerNo.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:83 height:24.5 forView:_btnAnswerNo];
    [NSLayoutConstraint centerVertical:_btnAnswerNo withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_btnAnswerYes, _btnAnswerPerhaps, _btnAnswerNo);
    NSString* hc_str = @"H:|-12-[_btnAnswerYes]-(>=1)-[_btnAnswerPerhaps]-(>=1)-[_btnAnswerNo]-12-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_curtainRowThreeView addConstraints:hzConstraints];
}

- (void) createYesButton {
    _btnAnswerYes = [CustomButton buttonWithType:UIButtonTypeCustom];
    [_btnAnswerYes addTarget:self action:@selector(btnUserDecisionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerYes setTitle:@"Иду" forState:UIControlStateNormal];
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
    [_btnAnswerPerhaps setTitle:@"Возможно" forState:UIControlStateNormal];
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
    [_btnAnswerNo setTitle:@"Нет" forState:UIControlStateNormal];
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
    if(button == _btnAnswerYes){
        _btnAnswerPerhaps.selected = NO;
        _btnAnswerNo.selected = NO;
    }
    else if(button == _btnAnswerPerhaps){
        _btnAnswerYes.selected = NO;
        _btnAnswerNo.selected = NO;
    }
    else if(button == _btnAnswerNo){
        _btnAnswerYes.selected = NO;
        _btnAnswerPerhaps.selected = NO;
    }
    
    button.selected = !button.selected;
}

#pragma mark -
#pragma mark Buttons click methods
- (void) btnInviteUserClick {
    InviteUserViewController* controller = [[InviteUserViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnChangeClick {
    
}

- (void) btnSendClick {
    
}

- (void) showGamers {
    MemberViewController* controller = [[MemberViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
        curtainHeigtContraint.constant = CURTAIN_HEIGT;
        [self.view layoutIfNeeded];
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
    if (textField == _tfMessage){
        if([textField.text isEmpty]){
            _btnSend.enabled = NO;
            _btnSend.userInteractionEnabled = NO;
        }
        else{
            _btnSend.enabled = YES;
            _btnSend.userInteractionEnabled = YES;
        }
    }
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newRect = self.view.frame;
    mainViewHeight = newRect.size.height;
    newRect.size.height = self.view.frame.size.height - kbSize.height;
    self.view.frame = newRect;
    [self.view layoutIfNeeded];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect newRect = self.view.frame;
    newRect.size.height = mainViewHeight;
    self.view.frame = newRect;
    [self.view layoutIfNeeded];
}

@end












