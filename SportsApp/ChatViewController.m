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
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#import <Quickblox/Quickblox.h>

#define CURTAIN_HEIGT 174.5 //161
#define PADDING_H 12

// curtain
@interface ChatViewController ()

#pragma mark -
#pragma mark Containers
@property (strong, nonatomic) UIScrollView* chatScrollView;
@property (strong, nonatomic) UIView* chatContentView;

#pragma mark -
#pragma mark Groups view
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

@end

@implementation ChatViewController{
    NSLayoutConstraint* curtainHeigtContraint;
    BOOL isCurtainOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"Волейбол";
    [self setNavTitle:@"Волейбол"];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setNavigationItems];
    
    [self setupCurtainView];
    
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        //NSLog(@"QBResponse: %@", response.debugDescription);
        //NSLog(@"QBASession: %@", session.debugDescription);
        
        /*
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
        */
        
        [QBRequest logInWithUserLogin:@"TestUser1" password:@"ahtrahtrahtr1" successBlock:^(QBResponse *response, QBUUser *user) {
            NSLog(@"QBUUser: %@", user.debugDescription);
        } errorBlock:^(QBResponse *response) {
            NSLog(@"QBResponse: %@", response.debugDescription);
        }];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"QBResponse: %@", response.debugDescription);
    }];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    /*
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnBack setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitle:@"<" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    btnBack.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btnBack sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    */
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    //self.navigationItem.backBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 50, -10, 0);
    
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
                                                           constant:-1]];
    
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
    
    /**/
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc] initWithString:@"Идут 7 человек"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    _peopleInGame.attributedText = [attributeString copy];
    
    //_peopleInGame.text = @"Идут 7 человек";
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
    
    //_btnAnswerYes.adjustsImageWhenHighlighted = NO;
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

/*
- (void) setupToolbar {
    // Toolbar
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonPlus = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnCallUserClick)];
    UIBarButtonItem *barButtonLocation = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_map.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnCallUserClick)];
    UIBarButtonItem* barButtonAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnCallUserClick)];
    barButtonAction.style = UIBarButtonItemStyleBordered;
    
    [self setToolbarItems:@[barButtonPlus, spacer, barButtonLocation, spacer, barButtonAction] animated:NO];
    
    //textField
    UIBarButtonItem *textFieldItem = [[UIBarButtonItem alloc] initWithCustomView:textField];
    toolbar.items = @[textFieldItem];
}
*/

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

@end












