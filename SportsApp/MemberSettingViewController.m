//
//  TestLayoutViewController.m
//  SportsApp
//
//  Created by sergeyZ on 23.05.15.
//
//

#import "MemberSettingViewController.h"
#import "UIViewController+Navigation.h"
#import "DDPageControl.h"
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "SportInfo.h"
#import "SportItemUI.h"
#import "MemberSettings.h"
#import "AppDelegate.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "CustomButton.h"

enum SportTypeIndex : NSUInteger {
    SportTypeIndexFootball,
    SportTypeIndexBasketball,
    SportTypeIndexVolleyball,
    SportTypeIndexHandball,
    SportTypeIndexTennis,
    SportTypeIndexHockey,
    SportTypeIndexSquash,
};
typedef enum SportTypeIndex SportTypeIndex;

static const CGFloat kHorizontalPadding = 12.5f;
static const CGFloat kScrollContentHeight = 464.0f;
static const CGFloat kScrollItemHeight = 99.0f;

@interface MemberSettingViewController () <UIScrollViewDelegate>

#pragma mark -
#pragma mark Containers
@property (strong, nonatomic) UIScrollView* containerScrollView;
@property (strong, nonatomic) UIView* containerView;

#pragma mark -
#pragma mark Groups view
@property (strong, nonatomic) UIView* sportsGroupView;
@property (strong, nonatomic) UIView* levelGroupView;
@property (strong, nonatomic) UIView* ageGroupView;

#pragma mark -
#pragma mark Groups title
@property (strong, nonatomic) UILabel* lbTitleSportsGrpup;
@property (strong, nonatomic) UILabel* lbTitleLevelGrpup;
@property (strong, nonatomic) UILabel* lbTitleAgeGrpup;

#pragma mark -
#pragma mark Sports group views
@property (strong, nonatomic) UIScrollView* sportsScrollView;
@property (strong, nonatomic) DDPageControl* sportsPageControl;
@property (strong, nonatomic) NSMutableArray* sportInfoItems;
@property (strong, nonatomic) NSMutableArray* sportUIItems;

#pragma mark -
#pragma mark Levels group images
@property (strong, nonatomic) UIImageView* ivOneStarLevel;
@property (strong, nonatomic) UIImageView* ivTwoStarLevel;
@property (strong, nonatomic) UIImageView* ivThreeStarLevel;

#pragma mark -
#pragma mark Ages group images
@property (strong, nonatomic) UIImageView* ivOneAge;
@property (strong, nonatomic) UIImageView* ivTwoAge;
@property (strong, nonatomic) UIImageView* ivThreeAge;
@property (strong, nonatomic) UIImageView* ivFourAge;

#pragma mark -
#pragma mark Ages group titles
@property (strong, nonatomic) UILabel* lbTitleOneAge;
@property (strong, nonatomic) UILabel* lbTitleTwoAge;
@property (strong, nonatomic) UILabel* lbTitleThreeAge;
@property (strong, nonatomic) UILabel* lbTitleFourAge;

@property (strong, nonatomic) UIButton* btnSave;
@property (strong, nonatomic) CustomButton* btnExit;

@end

@implementation MemberSettingViewController{
    MemberSettings *memberSettings;
    BOOL settingWasChanged;
    
    // level
    UIImage* grayStarImage;
    UIImage* activeStarImage;
    
    // age
    UIImage* grayAgeImage;
    UIImage* activeAgeImage;
    
    BOOL oneStarStatus, twoStarStatus, threeStarStatus;
    
    CGFloat scrollItemWidht;
    CGFloat mainScrollHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"Мои настройки"];
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    [self setNavigationItems];
    
    scrollItemWidht = self.view.bounds.size.width - kHorizontalPadding * 2;
    
    _sportInfoItems = [[NSMutableArray alloc] initWithCapacity:7];
    
    SportInfo* football = [SportInfo new];
    football.activeImage = [UIImage imageNamed:@"ic_football_active.png"];
    football.inactiveImage = [UIImage imageNamed:@"ic_football.png"];
    football.title = NSLocalizedString(@"STORT_FOOTBALL", nil);
    [_sportInfoItems addObject:football];
    
    SportInfo* basketball = [SportInfo new];
    basketball.activeImage = [UIImage imageNamed:@"ic_basketball_active.png"];
    basketball.inactiveImage = [UIImage imageNamed:@"ic_basketball.png"];
    basketball.title = NSLocalizedString(@"STORT_BASKETBALL", nil);
    [_sportInfoItems addObject:basketball];
    
    SportInfo* volleyball = [SportInfo new];
    volleyball.activeImage = [UIImage imageNamed:@"ic_volleyball_active.png"];
    volleyball.inactiveImage = [UIImage imageNamed:@"ic_volleyball.png"];
    volleyball.title = NSLocalizedString(@"STORT_VOLLEYBALL", nil);
    [_sportInfoItems addObject:volleyball];
    
    SportInfo* handball = [SportInfo new];
    handball.activeImage = [UIImage imageNamed:@"ic_handball_active.png"];
    handball.inactiveImage = [UIImage imageNamed:@"ic_handball.png"];
    handball.title = NSLocalizedString(@"STORT_HANDBALL", nil);
    [_sportInfoItems addObject:handball];
    
    SportInfo* tennis = [SportInfo new];
    tennis.activeImage = [UIImage imageNamed:@"ic_tennis_active.png"];
    tennis.inactiveImage = [UIImage imageNamed:@"ic_tennis.png"];
    tennis.title = NSLocalizedString(@"STORT_TENNIS", nil);
    [_sportInfoItems addObject:tennis];
    
    SportInfo* hockey = [SportInfo new];
    hockey.activeImage = [UIImage imageNamed:@"ic_hockey_active.png"];
    hockey.inactiveImage = [UIImage imageNamed:@"ic_hockey.png"];
    hockey.title = NSLocalizedString(@"STORT_HOCKEY", nil);
    [_sportInfoItems addObject:hockey];
    
    SportInfo* squash = [SportInfo new];
    squash.activeImage = [UIImage imageNamed:@"ic_squash_active.png"];
    squash.inactiveImage = [UIImage imageNamed:@"ic_squash.png"];
    squash.title = NSLocalizedString(@"STORT_SQUASH", nil);
    [_sportInfoItems addObject:squash];
    
    
    grayStarImage = [UIImage imageNamed:@"icon_star.png"];
    activeStarImage = [UIImage imageNamed:@"icon_star_active.png"];
    grayAgeImage = [UIImage imageNamed:@"icon_age.png"];
    activeAgeImage = [UIImage imageNamed:@"icon_age_active.png"];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadSettings];
}

- (void) loadSettings {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking settingsForCurrentUserCompletionHandler:^(MemberSettings *settings, NSString *errorMessage) {
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
                memberSettings = settings;
                [self makeUI];
            }
        });
    }];
}

- (void) makeUI {
    [self setupContainerScroll];
    [self setupContainerView];
    
    [self setupSportsGroupInParentView:_containerView];
    [self setupLevelsGroupInParentView:_containerView];
    [self setupAgesGroupInParentView:_containerView];
    
    [self setupButtonInParentView:_containerView];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[btnCancel setBackgroundColor:[UIColor grayColor]];
    [btnCancel setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitle:NSLocalizedString(@"BTN_CANCEL_2", nil) forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btnCancel.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btnCancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnSave setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [_btnSave addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave setTitle:NSLocalizedString(@"BTN_SAVE", nil) forState:UIControlStateNormal];
    _btnSave.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_btnSave setUserInteractionEnabled:NO];
    [_btnSave setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    [_btnSave sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btnSave];
    [_btnSave setEnabled:NO]; // !!
    settingWasChanged = NO;
}

#pragma mark -
#pragma mark Containers
#pragma mark -
- (void) setupButtonInParentView:(UIView*)container {
    _btnExit = [self createExitButton];
    _btnExit.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:_btnExit];
    
    [NSLayoutConstraint setHeight:40 forView:_btnExit];
    [NSLayoutConstraint setLeftPadding:kHorizontalPadding forView:_btnExit inContainer:container];
    [NSLayoutConstraint setRightPadding:kHorizontalPadding forView:_btnExit inContainer:container];
    [NSLayoutConstraint setBottomPadding:kHorizontalPadding forView:_btnExit inContainer:container];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnExit
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                             toItem:_ageGroupView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-8]];
}

- (void) setupContainerScroll {
    _containerScrollView = [UIScrollView new];
    _containerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(self.view.bounds.size.height > kScrollContentHeight)
        mainScrollHeight = self.view.bounds.size.height;
    else
        mainScrollHeight = kScrollContentHeight;
    
    _containerScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, mainScrollHeight);
    [self.view addSubview:_containerScrollView];
    
    [NSLayoutConstraint stretch:_containerScrollView inContainer:self.view withPadding:0];
}

- (void) setupContainerView {
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, mainScrollHeight)];
    [_containerScrollView addSubview:_containerView];
}

#pragma mark -
#pragma mark SPORTs group
#pragma mark -
- (void) setupSportsGroupInParentView:(UIView*)container {
    _sportsGroupView = [UIView new];
    _sportsGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _sportsGroupView.backgroundColor = [UIColor whiteColor];
    _sportsGroupView.layer.borderWidth = 0.5;
    _sportsGroupView.layer.cornerRadius = 6.0;
    _sportsGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [container addSubview:_sportsGroupView];
    
    [NSLayoutConstraint setHeight:155 forView:_sportsGroupView];
    [NSLayoutConstraint setTopPadding:7.5f forView:_sportsGroupView inContainer:container];
    [NSLayoutConstraint stretchHorizontal:_sportsGroupView inContainer:container withPadding:kHorizontalPadding];
    
    // subviews
    _lbTitleSportsGrpup = [UILabel new];
    [self setupTitle:_lbTitleSportsGrpup forGroup:_sportsGroupView withText:NSLocalizedString(@"TXT_MY_SPORTS", nil) andWidht:124];
    
    [self setupSportsPageControl];
    [self setupSportsScroll];
    [self setupSportItemViews];
}

- (void) setupSportsPageControl {
    _sportsPageControl = [DDPageControl new];
    [_sportsPageControl setType: DDPageControlTypeOnFullOffEmpty];
    [_sportsPageControl setOnColor: [UIColor colorWithRGBA:PAGE_INDICATOR_ACTIVE_COLOR]];
    [_sportsPageControl setOffColor: [UIColor colorWithRGBA:PAGE_INDICATOR_INACTIVE_COLOR]];
    [_sportsPageControl setIndicatorDiameter: 4.0f];
    [_sportsPageControl setIndicatorSpace: 5.0f];
    _sportsPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _sportsPageControl.userInteractionEnabled = NO;
    _sportsPageControl.numberOfPages = [self sportGroupsNumber];
    _sportsPageControl.currentPage = 0;
    [_sportsGroupView addSubview:_sportsPageControl];
    
    [NSLayoutConstraint setHeight:10 forView:_sportsPageControl];
    [NSLayoutConstraint stretchHorizontal:_sportsPageControl inContainer:_sportsGroupView withPadding:8];
    [NSLayoutConstraint setBottomPadding:8.0f forView:_sportsPageControl inContainer:_sportsGroupView];
}

- (void) setupSportsScroll {
    int childrenCount = [self sportGroupsNumber];
    
    _sportsScrollView = [UIScrollView new];
    _sportsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //[_sportsScrollView setBackgroundColor:[UIColor blueColor]];
    _sportsScrollView.delegate = self;
    _sportsScrollView.showsHorizontalScrollIndicator = NO;
    _sportsScrollView.pagingEnabled = YES;
    _sportsScrollView.contentSize = CGSizeMake(scrollItemWidht * childrenCount, kScrollItemHeight);
    [_sportsGroupView addSubview:_sportsScrollView];
    
    [NSLayoutConstraint stretchHorizontal:_sportsScrollView inContainer:_sportsGroupView withPadding:0];
    [NSLayoutConstraint setTopDistance:0 fromView:_sportsScrollView toView:_lbTitleSportsGrpup inContainer:_sportsGroupView];
    [NSLayoutConstraint setBottomDistance:0 fromView:_sportsScrollView toView:_sportsPageControl inContainer:_sportsGroupView];
}

- (void) setupSportItemViews {
    NSUInteger count = _sportInfoItems.count;
    _sportUIItems = [[NSMutableArray alloc] initWithCapacity:count];
    
    UIView* trinesView = [self createSportItemView:0];
    int subIndex = 0;
    int trinesCount = 1;
    for(int i = 0; i < count; ++i){
        SportInfo* sport = _sportInfoItems[i];
        
        SportItemUI* uiItem = [SportItemUI new];
        [_sportUIItems addObject:uiItem];
        
        //image
        uiItem.icon = [UIImageView new];
        uiItem.icon.tag = i;
        uiItem.icon.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapSportRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportIconClick:)];
        [uiItem.icon addGestureRecognizer:tapSportRecognizer];
        
        //lable
        uiItem.lable = [UILabel new];
        uiItem.lable.text = sport.title;
        uiItem.lable.textAlignment = NSTextAlignmentCenter;
        uiItem.lable.font = [UIFont systemFontOfSize:9.0f];
        
        BOOL active = NO;
        switch(i){
            case SportTypeIndexFootball:
                active = memberSettings.football;
                break;
            case SportTypeIndexBasketball:
                active = memberSettings.basketball;
                break;
            case SportTypeIndexVolleyball:
                active = memberSettings.volleyball;
                break;
            case SportTypeIndexHandball:
                active = memberSettings.handball;
                break;
            case SportTypeIndexTennis:
                active = memberSettings.tennis;
                break;
            case SportTypeIndexHockey:
                active = memberSettings.hockey;
                break;
            case SportTypeIndexSquash:
                active = memberSettings.squash;
                break;
                
            default:
                break;
        }
        
        if(active){
            uiItem.active = YES;
            uiItem.icon.image = sport.activeImage;
            uiItem.lable.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
        }
        else{
            uiItem.active = NO;
            uiItem.icon.image = sport.inactiveImage;
            uiItem.lable.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
        }
        
        NSUInteger number = subIndex+1;
        if(number%3 == 0){
            [self layoutSportRightIcon:uiItem.icon intoContainer:trinesView];
            [self layoutSportLable:uiItem.lable forIcon:uiItem.icon intoContainer:trinesView];
        }
        else if(number%2 == 0){
            [self layoutSportCenterIcon:uiItem.icon intoContainer:trinesView];
            [self layoutSportLable:uiItem.lable forIcon:uiItem.icon intoContainer:trinesView];
        }
        else{
            if(i == count-1){
                [self layoutSportCenterIcon:uiItem.icon intoContainer:trinesView];
                [self layoutSportLable:uiItem.lable forIcon:uiItem.icon intoContainer:trinesView];
            }
            else{
                [self layoutSportLeftIcon:uiItem.icon intoContainer:trinesView];
                [self layoutSportLable:uiItem.lable forIcon:uiItem.icon intoContainer:trinesView];
            }
        }
        
        [_sportsScrollView addSubview:trinesView];
        
        subIndex++;
        if(number%3 == 0){
            trinesView = [self createSportItemView:trinesCount];
            trinesCount++;
            subIndex = 0;
        }
    }
}

- (int) sportGroupsNumber {
    int pageCount = (int) _sportInfoItems.count / 3;
    int modulo = _sportInfoItems.count % 3;
    int groupNum = (modulo == 0) ? pageCount : pageCount+1;
    
    return groupNum;
}

- (UIView*) createSportItemView:(CGFloat)offset {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(scrollItemWidht * offset, 0, scrollItemWidht, kScrollItemHeight)];
    return view;
}

#pragma mark - Layout SPOTR icons
- (void) layoutSportLeftIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];
    [NSLayoutConstraint setWidht:50 height:48 forView:icon];
    [NSLayoutConstraint setTopPadding:20 forView:icon inContainer:container];
    [NSLayoutConstraint setLeftPadding:28.5f forView:icon inContainer:container];
}

- (void) layoutSportCenterIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];
    [NSLayoutConstraint setWidht:50 height:48 forView:icon];
    [NSLayoutConstraint setTopPadding:20 forView:icon inContainer:container];
    [NSLayoutConstraint centerHorizontal:icon withView:container inContainer:container];
}

- (void) layoutSportRightIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];
    [NSLayoutConstraint setWidht:50 height:48 forView:icon];
    [NSLayoutConstraint setTopPadding:20 forView:icon inContainer:container];
    [NSLayoutConstraint setRightPadding:28.5f forView:icon inContainer:container];
}

#pragma mark -
#pragma mark Layout SPOTR titles
- (void) layoutSportLable:(UILabel*)lable forIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    [container addSubview:lable];
    lable.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:60 height:10 forView:lable];
    [NSLayoutConstraint setTopDistance:15.0f fromView:lable toView:icon inContainer:container];
    [NSLayoutConstraint centerHorizontal:lable withView:icon inContainer:container];
}

#pragma mark -
#pragma mark LEVELs group
#pragma mark -
- (void) setupLevelsGroupInParentView:(UIView*)container {
    _levelGroupView = [UIView new];
    _levelGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _levelGroupView.backgroundColor = [UIColor whiteColor];
    _levelGroupView.layer.borderWidth = 0.5;
    _levelGroupView.layer.cornerRadius = 6.0;
    _levelGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [container addSubview:_levelGroupView];
    
    [NSLayoutConstraint setHeight:105 forView:_levelGroupView];
    [NSLayoutConstraint stretchHorizontal:_levelGroupView inContainer:container withPadding:kHorizontalPadding];
    [NSLayoutConstraint setTopDistance:7.5f fromView:_levelGroupView toView:_sportsGroupView inContainer:container];
    
    // title
    _lbTitleLevelGrpup = [UILabel new];
    [self setupTitle:_lbTitleLevelGrpup forGroup:_levelGroupView withText:NSLocalizedString(@"TXT_MY_LEVEL", nil) andWidht:106];
    
    BOOL isLevelOne, isLevelTwo, isLevelThree;
    if(memberSettings.level == PlayerLevelBeginner){
        isLevelOne = YES;
        isLevelTwo = NO;
        isLevelThree = NO;
    }
    else if(memberSettings.level == PlayerLevelMiddling){
        isLevelOne = YES;
        isLevelTwo = YES;
        isLevelThree = NO;
    }
    else if(memberSettings.level == PlayerLevelMaster){
        isLevelOne = YES;
        isLevelTwo = YES;
        isLevelThree = YES;
    }
    
    // icons !! order is important
    [self setupIconTwoStar:isLevelTwo];
    [self setupIconOneStar:isLevelOne];
    [self setupIconThreeStar:isLevelThree];
    [self setLevelImagesGestureRecognizers];
}

#pragma mark -
#pragma mark Layout LEVEL icons
- (void) setupIconTwoStar:(BOOL)active {
    _ivTwoStarLevel = [UIImageView new];
    _ivTwoStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoStarLevel.image = (active) ? activeStarImage : grayStarImage;
    [_levelGroupView addSubview:_ivTwoStarLevel];
    
    [NSLayoutConstraint setWidht:27 height:25 forView:_ivTwoStarLevel];
    [NSLayoutConstraint setTopDistance:20 fromView:_ivTwoStarLevel toView:_lbTitleLevelGrpup inContainer:_levelGroupView];
    [NSLayoutConstraint centerHorizontal:_ivTwoStarLevel withView:_lbTitleLevelGrpup inContainer:_levelGroupView];
}

- (void) setupIconOneStar:(BOOL)active {
    _ivOneStarLevel = [UIImageView new];
    _ivOneStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneStarLevel.image = (active) ? activeStarImage : grayStarImage;
    [_levelGroupView addSubview:_ivOneStarLevel];
    
    [NSLayoutConstraint setWidht:27 height:25 forView:_ivOneStarLevel];
    [NSLayoutConstraint setRightDistance:23 fromView:_ivOneStarLevel toView:_ivTwoStarLevel inContainer:_levelGroupView];
    [NSLayoutConstraint centerVertical:_ivOneStarLevel withView:_ivTwoStarLevel inContainer:_levelGroupView];
}

- (void) setupIconThreeStar:(BOOL)active {
    _ivThreeStarLevel = [UIImageView new];
    _ivThreeStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeStarLevel.image = (active) ? activeStarImage : grayStarImage;
    [_levelGroupView addSubview:_ivThreeStarLevel];
    
    [NSLayoutConstraint setWidht:27 height:25 forView:_ivThreeStarLevel];
    [NSLayoutConstraint setLeftDistance:23 fromView:_ivThreeStarLevel toView:_ivTwoStarLevel inContainer:_levelGroupView];
    [NSLayoutConstraint centerVertical:_ivThreeStarLevel withView:_ivTwoStarLevel inContainer:_levelGroupView];
}

#pragma mark -
#pragma mark AGEs group
#pragma mark -
- (void) setupAgesGroupInParentView:(UIView*)container {
    _ageGroupView = [UIView new];
    _ageGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _ageGroupView.backgroundColor = [UIColor whiteColor];
    _ageGroupView.layer.borderWidth = 0.5;
    _ageGroupView.layer.cornerRadius = 6.0;
    _ageGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [container addSubview:_ageGroupView];
    
    [NSLayoutConstraint setHeight:126 forView:_ageGroupView];
    [NSLayoutConstraint stretchHorizontal:_ageGroupView inContainer:container withPadding:kHorizontalPadding];
    [NSLayoutConstraint setTopDistance:7.5f fromView:_ageGroupView toView:_levelGroupView inContainer:container];

    // subviews
    _lbTitleAgeGrpup = [UILabel new];
    [self setupTitle:_lbTitleAgeGrpup forGroup:_ageGroupView withText:NSLocalizedString(@"TXT_MY_AGE", nil) andWidht:106];
    
    BOOL isAgeOne = (memberSettings.age == PlayerAge_20) ? YES : NO;
    BOOL isAgeTwo = (memberSettings.age == PlayerAge_20_28) ? YES : NO;
    BOOL isAgeThree = (memberSettings.age == PlayerAge_28_35) ? YES : NO;
    BOOL isAgeFour = (memberSettings.age == PlayerAge_35) ? YES : NO;
    
    // icons !! order is important
    [self setupIconAgeTwo:isAgeTwo];
    [self setupIconAgeOne:isAgeOne];
    [self setupIconAgeThree:isAgeThree];
    [self setupIconAgeFour:isAgeFour];
    [self setAgeImagesGestureRecognizers];
    
    // lables
    _lbTitleOneAge = [UILabel new];
    UIColor *oneAgeColor = (isAgeOne) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleOneAge forView:_ivOneAge withText:NSLocalizedString(@"TXT_AGE_UNTIL_20", nil) andColor:oneAgeColor];
    
    _lbTitleTwoAge = [UILabel new];
    UIColor *twoAgeColor = (isAgeTwo) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleTwoAge forView:_ivTwoAge withText:NSLocalizedString(@"TXT_AGE_20_28", nil) andColor:twoAgeColor];
    
    _lbTitleThreeAge = [UILabel new];
    UIColor *threeAgeColor = (isAgeThree) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleThreeAge forView:_ivThreeAge withText:NSLocalizedString(@"TXT_AGE_28_35", nil) andColor:threeAgeColor];
    
    _lbTitleFourAge = [UILabel new];
    UIColor *fourAgeColor = (isAgeFour) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleFourAge forView:_ivFourAge withText:NSLocalizedString(@"TXT_AGE_AFTER_35", nil) andColor:fourAgeColor];
}

- (void) setupTitleAge {
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
}

#pragma mark -
#pragma mark Layout AGE icons
- (void) setupIconAgeOne:(BOOL)active {
    _ivOneAge = [UIImageView new];
    _ivOneAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneAge.image = (active) ? activeAgeImage : grayAgeImage;
    [_ageGroupView addSubview:_ivOneAge];
    
    [NSLayoutConstraint setWidht:36 height:35 forView:_ivOneAge];
    [NSLayoutConstraint setTopDistance:21 fromView:_ivOneAge toView:_lbTitleAgeGrpup inContainer:_ageGroupView];
    [NSLayoutConstraint setRightDistance:33.5 fromView:_ivOneAge toView:_ivTwoAge inContainer:_ageGroupView];
}

- (void) setupIconAgeTwo:(BOOL)active {
    _ivTwoAge = [UIImageView new];
    _ivTwoAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoAge.image = (active) ? activeAgeImage : grayAgeImage;
    [_ageGroupView addSubview:_ivTwoAge];
    
    [NSLayoutConstraint setWidht:36 height:35 forView:_ivTwoAge];
    [NSLayoutConstraint setTopDistance:21 fromView:_ivTwoAge toView:_lbTitleAgeGrpup inContainer:_ageGroupView];
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivTwoAge
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:0
                                                                   toItem:_lbTitleAgeGrpup
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:-16.75f]];
}

- (void) setupIconAgeThree:(BOOL)active {
    _ivThreeAge = [UIImageView new];
    _ivThreeAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeAge.image = (active) ? activeAgeImage : grayAgeImage;
    [_ageGroupView addSubview:_ivThreeAge];
    
    [NSLayoutConstraint setWidht:36 height:35 forView:_ivThreeAge];
    [NSLayoutConstraint setTopDistance:21 fromView:_ivThreeAge toView:_lbTitleAgeGrpup inContainer:_ageGroupView];
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivThreeAge
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:0
                                                                 toItem:_lbTitleAgeGrpup
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:16.75f]];
}

- (void) setupIconAgeFour:(BOOL)active {
    _ivFourAge = [UIImageView new];
    _ivFourAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivFourAge.image = (active) ? activeAgeImage : grayAgeImage;
    [_ageGroupView addSubview:_ivFourAge];
    
    [NSLayoutConstraint setWidht:36 height:35 forView:_ivFourAge];
    [NSLayoutConstraint setTopDistance:21 fromView:_ivFourAge toView:_lbTitleAgeGrpup inContainer:_ageGroupView];
    [NSLayoutConstraint setLeftDistance:33.5f fromView:_ivFourAge toView:_ivThreeAge inContainer:_ageGroupView];
}

#pragma mark -
#pragma mark Layout AGE titles
- (void) setupAgeLable:(UILabel*)lable forView:(UIView*)view withText:(NSString*)text andColor:(UIColor*)color {
    [_ageGroupView addSubview:lable];
    lable.translatesAutoresizingMaskIntoConstraints = NO;
    lable.text = text;
    lable.textColor = color;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:9.0f];
    
    [NSLayoutConstraint setWidht:47 height:21 forView:lable];
    [NSLayoutConstraint setTopDistance:4 fromView:lable toView:view inContainer:_ageGroupView];
    [NSLayoutConstraint centerHorizontal:lable withView:view inContainer:_ageGroupView];
}

#pragma mark -
#pragma mark Gesture Recognizers
#pragma mark -
- (void) setLevelImagesGestureRecognizers {
    _ivOneStarLevel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapOneStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneStarClick)];
    [_ivOneStarLevel addGestureRecognizer:tapOneStarGesture];
    
    _ivTwoStarLevel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapTwoStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoStarClick)];
    [_ivTwoStarLevel addGestureRecognizer:tapTwoStarGesture];
    
    _ivThreeStarLevel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapThreeStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeStarClick)];
    [_ivThreeStarLevel addGestureRecognizer:tapThreeStarGesture];
}

- (void) setAgeImagesGestureRecognizers {
    _ivOneAge.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOneStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneAgeClick)];
    [_ivOneAge addGestureRecognizer:tapOneStarGesture];
    
    _ivTwoAge.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTwoStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoAgeClick)];
    [_ivTwoAge addGestureRecognizer:tapTwoStarGesture];
    
    _ivThreeAge.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapThreeStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeAgeClick)];
    [_ivThreeAge addGestureRecognizer:tapThreeStarGesture];
    
    _ivFourAge.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFourStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fourAgeClick)];
    [_ivFourAge addGestureRecognizer:tapFourStarGesture];
}

#pragma mark -
#pragma mark UI helper methods
- (void) setupTitle:(UILabel*)label forGroup:(UIView*)groupView withText:(NSString*)text andWidht:(CGFloat)widht {
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11.0f];
    label.layer.borderWidth = 0.5;
    label.layer.cornerRadius = 12.0;
    label.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    label.layer.backgroundColor = [[UIColor colorWithRGBA:BG_GROUP_LABLE_COLOR] CGColor];
    [groupView addSubview:label];
    
    [NSLayoutConstraint setWidht:widht height:24.0f forView:label];
    [NSLayoutConstraint setTopPadding:13.5f forView:label inContainer:groupView];
    [NSLayoutConstraint centerHorizontal:label withView:groupView inContainer:groupView];
}

#pragma mark -
#pragma mark Clicks methods
#pragma mark -
#pragma mark Sport
- (void) sportIconClick:(UIGestureRecognizer*)gestureRecognizer {
    [self enableSaveButton];
    
    UIImageView* icon = (UIImageView*)gestureRecognizer.view;
    
    NSUInteger sportIndex = icon.tag;
    if(sportIndex < _sportUIItems.count){
        SportItemUI* sportUI = _sportUIItems[sportIndex];
        SportInfo* sportInfo = _sportInfoItems[sportIndex];
        
        BOOL active = NO;
        switch(sportIndex){
            case SportTypeIndexFootball:
                memberSettings.football = !memberSettings.football;
                active = memberSettings.football;
                break;
            case SportTypeIndexBasketball:
                memberSettings.basketball = !memberSettings.basketball;
                active = memberSettings.basketball;
                break;
            case SportTypeIndexVolleyball:
                memberSettings.volleyball = !memberSettings.volleyball;
                active = memberSettings.volleyball;
                break;
            case SportTypeIndexHandball:
                memberSettings.handball = !memberSettings.handball;
                active = memberSettings.handball;
                break;
            case SportTypeIndexTennis:
                memberSettings.tennis = !memberSettings.tennis;
                active = memberSettings.tennis;
                break;
            case SportTypeIndexHockey:
                memberSettings.hockey = !memberSettings.hockey;
                active = memberSettings.hockey;
                break;
            case SportTypeIndexSquash:
                memberSettings.squash = !memberSettings.squash;
                active = memberSettings.squash;
                break;
                
            default:
                break;
        }
        
        if(!active){
            sportUI.icon.image = sportInfo.inactiveImage;
            sportUI.lable.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
            sportUI.active = NO;
        }
        else{
            sportUI.icon.image = sportInfo.activeImage;
            sportUI.lable.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
            sportUI.active = YES;
        }
    }
}

#pragma mark -
#pragma mark Level
- (void) oneStarClick {
    [self enableSaveButton];
    
    twoStarStatus = threeStarStatus = NO;
    _ivTwoStarLevel.image = grayStarImage;
    _ivThreeStarLevel.image = grayStarImage;
    
    oneStarStatus = YES;
    _ivOneStarLevel.image = activeStarImage;
    memberSettings.level = PlayerLevelBeginner;
    
    /*
    if(oneStarStatus){
        oneStarStatus = NO;
        _ivOneStarLevel.image = grayStarImage;
        
        memberSettings.level = LEVEL_UNKNOWN;
    }
    else{
        oneStarStatus = YES;
        _ivOneStarLevel.image = activeStarImage;
        
        memberSettings.level = LEVEL_1;
    }
    */
}

- (void) twoStarClick {
    [self enableSaveButton];
    
    oneStarStatus = twoStarStatus = YES;
    threeStarStatus = NO;
    _ivOneStarLevel.image = activeStarImage;
    _ivTwoStarLevel.image = activeStarImage;
    _ivThreeStarLevel.image = grayStarImage;
    
    memberSettings.level = PlayerLevelMiddling;
}

- (void) threeStarClick {
    [self enableSaveButton];
    
    oneStarStatus = twoStarStatus = threeStarStatus = YES;
    
    _ivOneStarLevel.image = activeStarImage;
    _ivTwoStarLevel.image = activeStarImage;
    _ivThreeStarLevel.image = activeStarImage;
    
    memberSettings.level = PlayerLevelMaster;
}

#pragma mark -
#pragma mark Age
- (void) oneAgeClick {
    [self enableSaveButton];
    
    _ivOneAge.image = activeAgeImage;
    _ivTwoAge.image = grayAgeImage;
    _ivThreeAge.image = grayAgeImage;
    _ivFourAge.image = grayAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    
    memberSettings.age = PlayerAge_20;
}

- (void) twoAgeClick {
    [self enableSaveButton];
    
    _ivOneAge.image = grayAgeImage;
    _ivTwoAge.image = activeAgeImage;
    _ivThreeAge.image = grayAgeImage;
    _ivFourAge.image = grayAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    
    memberSettings.age = PlayerAge_20_28;
}

- (void) threeAgeClick {
    [self enableSaveButton];
    
    _ivOneAge.image = grayAgeImage;
    _ivTwoAge.image = grayAgeImage;
    _ivThreeAge.image = activeAgeImage;
    _ivFourAge.image = grayAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    
    memberSettings.age = PlayerAge_28_35;
}

- (void) fourAgeClick {
    [self enableSaveButton];
    
    _ivOneAge.image = grayAgeImage;
    _ivTwoAge.image = grayAgeImage;
    _ivThreeAge.image = grayAgeImage;
    _ivFourAge.image = activeAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    
    memberSettings.age = PlayerAge_35;
}

#pragma mark -
#pragma mark ScrollView deledate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == _sportsScrollView){
        CGFloat pageWidth = _sportsScrollView.frame.size.width;
        float fractionalPage = _sportsScrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        _sportsPageControl.currentPage = page;
    }
}

#pragma mark -
#pragma mark Other methods
- (void) enableSaveButton {
    settingWasChanged = YES;
    [_btnSave setEnabled:YES];
    [_btnSave setUserInteractionEnabled:YES];
}

- (CustomButton *) createExitButton {
    CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnExitClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"BTN_EXIT", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [btn setTitleColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btn setBackgrounColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn setBackgrounColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateSelected];
    [btn setBackgrounColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateHighlighted];
    
    [btn setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateNormal];
    [btn setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateSelected];
    [btn setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateHighlighted];
    
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 6.0;
    
    return btn;
}

# pragma mark -
# pragma mark Navigation button click
- (void) btnCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnAddClick {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking saveSettingsForCurrentUser:memberSettings completionHandler:^(NSString *errorMessage) {
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
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }];
}

- (void) btnExitClick {
    UINavigationController *root = self.navigationController;
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: root.viewControllers];
    
    while(navigationArray.count > 1)
        [navigationArray removeObjectAtIndex:1];
    
    root.viewControllers = navigationArray;
}

@end







