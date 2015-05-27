//
//  ChatViewController.m
//  SportsApp
//
//  Created by sergeyZ on 26.05.15.
//
//

#import "ChatViewController.h"
#import "InviteUserViewController.h"
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#define CURTAIN_HEIGT 161

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
//@property (strong, nonatomic) UIView* curtainArrowView;
@property (strong, nonatomic) UIButton* curtainArrowButton;

@property (strong, nonatomic) UILabel* peopleInGame;
@property (strong, nonatomic) UILabel* peopleNeed;

@property (strong, nonatomic) UIButton* btnInviteUser;
@property (strong, nonatomic) UIButton* btnAnswerYes;
@property (strong, nonatomic) UIButton* btnAnswerPerhaps;
@property (strong, nonatomic) UIButton* btnAnswerNo;

@end

@implementation ChatViewController{
    NSLayoutConstraint* curtainHeigtContraint;
    BOOL isCurtainOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Chat";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupCurtainView];
    
}

#pragma mark -
#pragma mark Curtain view
- (void) setupCurtainView {
    _curtainView = [UIView new];
    _curtainView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    //_curtainArrowButton.showsTouchWhenHighlighted = NO;
    
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
    
    [_curtainRowOneView addConstraint: [NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:38]];
    
    UIImageView* locIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_location.png"]];
    [_curtainRowOneView addSubview:locIcon];
    locIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:8 height:10 forView:locIcon];
    [NSLayoutConstraint centerVertical:locIcon withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UILabel* locTitle = [self makeLocationLable];
    [_curtainRowOneView addSubview:locTitle];
    locTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:locTitle];
    [NSLayoutConstraint centerVertical:locTitle withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UIImageView* timeIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_time.png"]];
    [_curtainRowOneView addSubview:timeIcon];
    timeIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:10 height:11 forView:timeIcon];
    [NSLayoutConstraint centerVertical:timeIcon withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UILabel* timeTitle = [self makeTimeLable];
    [_curtainRowOneView addSubview:timeTitle];
    timeTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:timeTitle];
    [NSLayoutConstraint centerVertical:timeTitle withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(locTitle, locIcon, timeTitle, timeIcon);
    NSString* hc_str = @"H:|-5-[locIcon]-4-[locTitle]-(>=1)-[timeIcon]-4-[timeTitle]-5-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:hzConstraints];
}

- (UIImageView*) makeFirstRowIconWithImage:(UIImage*)image {
    UIImageView* icon = [UIImageView new];
    icon.image = image;
    return icon;
}

- (UILabel*) makeTimeLable {
    UILabel* lable = [UILabel new];
    lable.text = @"10:00 через 3 дня";
    lable.textAlignment = NSTextAlignmentRight;
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
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowTwoView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:_curtainRowOneView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:1]];
    
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
    
    [_curtainRowTwoView addConstraint: [NSLayoutConstraint constraintWithItem:_curtainRowTwoView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:0
                                                                       toItem:nil
                                                                    attribute:0
                                                                   multiplier:1
                                                                     constant:60]];
    
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
    [NSLayoutConstraint setWidht:80 height:30 forView:_btnInviteUser];
    [NSLayoutConstraint centerVertical:_btnInviteUser withView:_curtainRowTwoView inContainer:_curtainRowTwoView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_peopleInGame, _peopleNeed, _btnInviteUser);
    NSString* hc_str = @"H:|-5-[_peopleInGame]-10-[_peopleNeed]-(>=1)-[_btnInviteUser]-5-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_curtainRowTwoView addConstraints:hzConstraints];
}

- (void) createPeopleInGameLable {
    _peopleInGame = [UILabel new];
    _peopleInGame.text = @"Идут 7 человек";
    _peopleInGame.textAlignment = NSTextAlignmentLeft;
    _peopleInGame.font = [UIFont systemFontOfSize:12.0f];
    _peopleInGame.textColor = [UIColor blueColor];
    [_peopleInGame sizeToFit];
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
    _btnInviteUser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnInviteUser addTarget:self action:@selector(btnInviteUserClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnInviteUser setTitle:@"Позвать" forState:UIControlStateNormal];
    [_btnInviteUser setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateNormal];
    _btnInviteUser.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnInviteUser.layer.borderWidth = 0.5;
    _btnInviteUser.layer.cornerRadius = 6.0;
    //_btnInviteUser.layer.backgroundColor = [[UIColor colorWithRGBA:BG_BUTTON_COLOR] CGColor];
    _btnInviteUser.layer.borderColor = [[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] CGColor];
}

#pragma mark -
#pragma mark Third row
- (void) layoutThirdRowCurtain {
    _curtainRowThreeView = [UIView new];
    _curtainRowThreeView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowThreeView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowThreeView];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowThreeView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:_curtainRowTwoView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:1]];
    
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
    
    [_curtainRowThreeView addConstraint: [NSLayoutConstraint constraintWithItem:_curtainRowThreeView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:0
                                                                       toItem:nil
                                                                    attribute:0
                                                                   multiplier:1
                                                                     constant:60]];
    
    [self createYesButton];
    [_curtainRowThreeView addSubview:_btnAnswerYes];
    _btnAnswerYes.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:80 height:30 forView:_btnAnswerYes];
    [NSLayoutConstraint centerVertical:_btnAnswerYes withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    [self createPerhapsButton];
    [_curtainRowThreeView addSubview:_btnAnswerPerhaps];
    _btnAnswerPerhaps.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:80 height:30 forView:_btnAnswerPerhaps];
    [NSLayoutConstraint centerVertical:_btnAnswerPerhaps withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    [NSLayoutConstraint centerHorizontal:_btnAnswerPerhaps withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    [self createNoButton];
    [_curtainRowThreeView addSubview:_btnAnswerNo];
    _btnAnswerNo.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:80 height:30 forView:_btnAnswerNo];
    [NSLayoutConstraint centerVertical:_btnAnswerNo withView:_curtainRowThreeView inContainer:_curtainRowThreeView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_btnAnswerYes, _btnAnswerPerhaps, _btnAnswerNo);
    NSString* hc_str = @"H:|-5-[_btnAnswerYes]-(>=1)-[_btnAnswerPerhaps]-(>=1)-[_btnAnswerNo]-5-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [_curtainRowThreeView addConstraints:hzConstraints];
}

- (void) createYesButton {
    _btnAnswerYes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnAnswerYes addTarget:self action:@selector(btnInviteUserClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerYes setTitle:@"Иду" forState:UIControlStateNormal];
    [_btnAnswerYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAnswerYes.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnAnswerYes.layer.borderWidth = 0.5;
    _btnAnswerYes.layer.cornerRadius = 6.0;
    _btnAnswerYes.layer.backgroundColor = [[UIColor colorWithRGBA:BG_BUTTON_COLOR] CGColor];
}

- (void) createPerhapsButton {
    _btnAnswerPerhaps = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnAnswerPerhaps addTarget:self action:@selector(btnInviteUserClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerPerhaps setTitle:@"Возможно" forState:UIControlStateNormal];
    [_btnAnswerPerhaps setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateNormal];
    _btnAnswerPerhaps.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnAnswerPerhaps.layer.borderWidth = 0.5;
    _btnAnswerPerhaps.layer.cornerRadius = 6.0;
    _btnAnswerPerhaps.layer.borderColor = [[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] CGColor];
}

- (void) createNoButton {
    _btnAnswerNo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnAnswerNo addTarget:self action:@selector(btnInviteUserClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnAnswerNo setTitle:@"Нет" forState:UIControlStateNormal];
    [_btnAnswerNo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnAnswerNo.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnAnswerNo.layer.borderWidth = 0.5;
    _btnAnswerNo.layer.cornerRadius = 6.0;
    _btnAnswerNo.layer.borderColor = [[UIColor redColor] CGColor];
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












