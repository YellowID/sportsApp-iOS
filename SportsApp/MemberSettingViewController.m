//
//  TestLayoutViewController.m
//  SportsApp
//
//  Created by sergeyZ on 23.05.15.
//
//

#import "MemberSettingViewController.h"
#import "UIViewController+Navigation.h"
//#import "CustomDotPageControl.h"
#import "DDPageControl.h"
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "SportInfo.h"
#import "SportItemUI.h"
#import "MemberSettings.h"
#import "AppNetHelper.h"
#import "MBProgressHUD.h"
#import "CustomButton.h"

#define PADDING_H 12.5
#define MAIN_SCROLL_CONTENT_HEIGHT 464 //462.5 //415
#define SCROLL_ITEM_HEIGHT 99

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
//@property (strong, nonatomic) UIPageControl* sportsPageControl;
//@property (strong, nonatomic) CustomDotPageControl* sportsPageControl;
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
    
    CGFloat kScrollItemWidht;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"Мои настройки"];
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    [self setNavigationItems];
    
    kScrollItemWidht = self.view.bounds.size.width - PADDING_H * 2;
    
    _sportInfoItems = [[NSMutableArray alloc] initWithCapacity:7];
    
    SportInfo* football = [SportInfo new];
    football.activeImage = [UIImage imageNamed:@"ic_football_active.png"];
    football.inactiveImage = [UIImage imageNamed:@"ic_football.png"];
    football.title = @"Футбол";
    [_sportInfoItems addObject:football];
    
    SportInfo* basketball = [SportInfo new];
    basketball.activeImage = [UIImage imageNamed:@"ic_basketball_active.png"];
    basketball.inactiveImage = [UIImage imageNamed:@"ic_basketball.png"];
    basketball.title = @"Баскетбол";
    [_sportInfoItems addObject:basketball];
    
    SportInfo* volleyball = [SportInfo new];
    volleyball.activeImage = [UIImage imageNamed:@"ic_volleyball_active.png"];
    volleyball.inactiveImage = [UIImage imageNamed:@"ic_volleyball.png"];
    volleyball.title = @"Волейбол";
    [_sportInfoItems addObject:volleyball];
    
    SportInfo* handball = [SportInfo new];
    handball.activeImage = [UIImage imageNamed:@"ic_handball_active.png"];
    handball.inactiveImage = [UIImage imageNamed:@"ic_handball.png"];
    handball.title = @"Гандбол";
    [_sportInfoItems addObject:handball];
    
    SportInfo* tennis = [SportInfo new];
    tennis.activeImage = [UIImage imageNamed:@"ic_tennis_active.png"];
    tennis.inactiveImage = [UIImage imageNamed:@"ic_tennis.png"];
    tennis.title = @"Тенис";
    [_sportInfoItems addObject:tennis];
    
    SportInfo* hockey = [SportInfo new];
    hockey.activeImage = [UIImage imageNamed:@"ic_hockey_active.png"];
    hockey.inactiveImage = [UIImage imageNamed:@"ic_hockey.png"];
    hockey.title = @"Хоккей";
    [_sportInfoItems addObject:hockey];
    
    SportInfo* squash = [SportInfo new];
    squash.activeImage = [UIImage imageNamed:@"ic_squash_active.png"];
    squash.inactiveImage = [UIImage imageNamed:@"ic_squash.png"];
    squash.title = @"Сквош";
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
    
    [AppNetHelper settingsForUser:1 completionHandler:^(MemberSettings *settings, NSString *errorMessage) {
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
                memberSettings = settings;
                [self makeUI];
            }
        });
    }];
}

- (void) makeUI {
    //[self setupButtonInParentView:self.view];
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
    [btnCancel setTitle:@"Отменить" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    btnCancel.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btnCancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnSave setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [_btnSave addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave setTitle:@"Сохранить" forState:UIControlStateNormal];
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
    
    /*
    _btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect]
    _btnSave.translatesAutoresizingMaskIntoConstraints = NO;
    //[_btnSave addTarget:self action:@selector(btnSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave setTitle:@"Выход" forState:UIControlStateNormal];
    [_btnSave setTintColor:[UIColor whiteColor]];
    _btnSave.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _btnSave.layer.borderWidth = 0.0;
    _btnSave.layer.cornerRadius = 6.0;
    _btnSave.layer.backgroundColor = [[UIColor colorWithRGBA:BG_BUTTON_COLOR] CGColor];
    */
    
    _btnExit.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:_btnExit];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnExit
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-8]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnExit
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnExit
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-PADDING_H]];
    
    [_btnExit addConstraint: [NSLayoutConstraint constraintWithItem:_btnExit
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:40]];
}

- (void) setupContainerScroll {
    _containerScrollView = [UIScrollView new];
    _containerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, MAIN_SCROLL_CONTENT_HEIGHT);
    [self.view addSubview:_containerScrollView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerScrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerScrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    /*
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:_btnSave
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:-8]];
    */
}

- (void) setupContainerView {
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, MAIN_SCROLL_CONTENT_HEIGHT)];
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
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:7.5f]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:container
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [_sportsGroupView addConstraint: [NSLayoutConstraint constraintWithItem:_sportsGroupView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:0
                                                                    toItem:nil
                                                                 attribute:0
                                                                multiplier:1
                                                                  constant:155]];
    
    // subviews
    _lbTitleSportsGrpup = [UILabel new];
    [self setupTitle:_lbTitleSportsGrpup forGroup:_sportsGroupView withText:@"Мои виды спорта:" andWidht:124];
    
    [self setupSportsPageControl];
    [self setupSportsScroll];
    [self setupSportItemViews];
}

- (void) setupSportsPageControl {
    /*
    _sportsPageControl = [CustomDotPageControl new];
    [_sportsPageControl setDotImageActive:[UIImage imageNamed:@"ic_page_active.png"]];
    [_sportsPageControl setDotImageInactive:[UIImage imageNamed:@"ic_page.png"]];
    _sportsPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _sportsPageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    _sportsPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _sportsPageControl.userInteractionEnabled = NO;
    _sportsPageControl.numberOfPages = _sportInfoItems.count / 3;
    _sportsPageControl.currentPage = 0;
    [_sportsGroupView addSubview:_sportsPageControl];
    //_sportsPageControl.backgroundColor = [UIColor greenColor];
    */
    
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
    
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsPageControl
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-8.0f]];
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsPageControl
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:8]];
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsPageControl
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-8]];
    
    [_sportsPageControl addConstraint: [NSLayoutConstraint constraintWithItem:_sportsPageControl
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:10]];
}

- (void) setupSportsScroll {
    int childrenCount = [self sportGroupsNumber];
    
    _sportsScrollView = [UIScrollView new];
    _sportsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //[_sportsScrollView setBackgroundColor:[UIColor blueColor]];
    _sportsScrollView.delegate = self;
    _sportsScrollView.showsHorizontalScrollIndicator = NO;
    _sportsScrollView.pagingEnabled = YES;
    _sportsScrollView.contentSize = CGSizeMake(kScrollItemWidht * childrenCount, SCROLL_ITEM_HEIGHT);
    
    [_sportsGroupView addSubview:_sportsScrollView];
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsScrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsScrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_lbTitleSportsGrpup
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    [_sportsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_sportsScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:_sportsPageControl
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
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
            case IND_FOOTBALL:
                active = memberSettings.football;
                break;
            case IND_BASKETBALL:
                active = memberSettings.basketball;
                break;
            case IND_VOLLEYBALL:
                active = memberSettings.volleyball;
                break;
            case IND_HANDBALL:
                active = memberSettings.handball;
                break;
            case IND_TENNIS:
                active = memberSettings.tennis;
                break;
            case IND_HOCKEY:
                active = memberSettings.hockey;
                break;
            case IND_SQUASH:
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
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(kScrollItemWidht * offset, 0, kScrollItemWidht, SCROLL_ITEM_HEIGHT)];
    return view;
}

#pragma mark - Layout SPOTR icons
- (void) layoutSportLeftIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];
    [NSLayoutConstraint setWidht:50 height:48 forView:icon];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:20]];
    [container addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:28.5]];
}

- (void) layoutSportCenterIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];
    [NSLayoutConstraint setWidht:50 height:48 forView:icon];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:20]];
    [container addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
}

- (void) layoutSportRightIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];
    [NSLayoutConstraint setWidht:50 height:48 forView:icon];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:20]];
    [container addConstraint:[NSLayoutConstraint constraintWithItem:icon
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-28.5]];
}

#pragma mark -
#pragma mark Layout SPOTR titles
- (void) layoutSportLable:(UILabel*)lable forIcon:(UIImageView*)icon intoContainer:(UIView*)container {
    [container addSubview:lable];
    lable.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:60 height:10 forView:lable];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:lable
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:icon
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:15.0f]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:lable
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:icon
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
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
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_levelGroupView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_sportsGroupView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:7.5f]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_levelGroupView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:container
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_levelGroupView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [_levelGroupView addConstraint: [NSLayoutConstraint constraintWithItem:_levelGroupView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:0
                                                                    toItem:nil
                                                                 attribute:0
                                                                multiplier:1
                                                                  constant:105]];
    // title
    _lbTitleLevelGrpup = [UILabel new];
    [self setupTitle:_lbTitleLevelGrpup forGroup:_levelGroupView withText:@"Мой уровень:" andWidht:106];
    
    BOOL isLevelOne, isLevelTwo, isLevelThree;
    if(memberSettings.level == LEVEL_1){
        isLevelOne = YES;
        isLevelTwo = NO;
        isLevelThree = NO;
    }
    else if(memberSettings.level == LEVEL_2){
        isLevelOne = YES;
        isLevelTwo = YES;
        isLevelThree = NO;
    }
    else if(memberSettings.level == LEVEL_3){
        isLevelOne = YES;
        isLevelTwo = YES;
        isLevelThree = YES;
    }
    
    // icons !! order is important
    [self setupIconTwoStar:isLevelOne];
    [self setupIconOneStar:isLevelTwo];
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
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivTwoStarLevel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:0
                                                                   toItem:_lbTitleLevelGrpup
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:20]];
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivTwoStarLevel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:0
                                                                   toItem:_lbTitleLevelGrpup
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0]];
}

- (void) setupIconOneStar:(BOOL)active {
    _ivOneStarLevel = [UIImageView new];
    _ivOneStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneStarLevel.image = (active) ? activeStarImage : grayStarImage;
    [_levelGroupView addSubview:_ivOneStarLevel];
    [NSLayoutConstraint setWidht:27 height:25 forView:_ivOneStarLevel];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivOneStarLevel
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:0
                                                                   toItem:_ivTwoStarLevel
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivOneStarLevel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:0
                                                                   toItem:_ivTwoStarLevel
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:-23]];
    
}

- (void) setupIconThreeStar:(BOOL)active {
    _ivThreeStarLevel = [UIImageView new];
    _ivThreeStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeStarLevel.image = (active) ? activeStarImage : grayStarImage;
    [_levelGroupView addSubview:_ivThreeStarLevel];
    [NSLayoutConstraint setWidht:27 height:25 forView:_ivThreeStarLevel];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivThreeStarLevel
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:0
                                                                   toItem:_ivTwoStarLevel
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivThreeStarLevel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:0
                                                                   toItem:_ivTwoStarLevel
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:23]];
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
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ageGroupView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_levelGroupView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:7.5f]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ageGroupView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:container
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_ageGroupView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [_ageGroupView addConstraint: [NSLayoutConstraint constraintWithItem:_ageGroupView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:0
                                                                    toItem:nil
                                                                 attribute:0
                                                                multiplier:1
                                                                  constant:126]];

    // subviews
    _lbTitleAgeGrpup = [UILabel new];
    [self setupTitle:_lbTitleAgeGrpup forGroup:_ageGroupView withText:@"Мой возраст:" andWidht:106];
    
    BOOL isAgeOne = (memberSettings.age == AGE_20) ? YES : NO;
    BOOL isAgeTwo = (memberSettings.age == AGE_20_28) ? YES : NO;
    BOOL isAgeThree = (memberSettings.age == AGE_28_35) ? YES : NO;
    BOOL isAgeFour = (memberSettings.age == AGE_35) ? YES : NO;
    
    // icons !! order is important
    [self setupIconAgeTwo:isAgeTwo];
    [self setupIconAgeOne:isAgeOne];
    [self setupIconAgeThree:isAgeThree];
    [self setupIconAgeFour:isAgeFour];
    [self setAgeImagesGestureRecognizers];
    
    // lables
    _lbTitleOneAge = [UILabel new];
    UIColor *oneAgeColor = (isAgeOne) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleOneAge forView:_ivOneAge withText:@"до 20" andColor:oneAgeColor];
    
    _lbTitleTwoAge = [UILabel new];
    UIColor *twoAgeColor = (isAgeTwo) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleTwoAge forView:_ivTwoAge withText:@"20-28" andColor:twoAgeColor];
    
    _lbTitleThreeAge = [UILabel new];
    UIColor *threeAgeColor = (isAgeThree) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleThreeAge forView:_ivThreeAge withText:@"28-35" andColor:threeAgeColor];
    
    _lbTitleFourAge = [UILabel new];
    UIColor *fourAgeColor = (isAgeFour) ? [UIColor colorWithRGBA:TXT_ACTIVE_COLOR] : [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    [self setupAgeLable:_lbTitleFourAge forView:_ivFourAge withText:@"после 35" andColor:fourAgeColor];
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
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivOneAge
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:0
                                                                 toItem:_lbTitleAgeGrpup
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:21]];
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivOneAge
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:0
                                                                 toItem:_ivTwoAge
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:-33.5]];
}

- (void) setupIconAgeTwo:(BOOL)active {
    _ivTwoAge = [UIImageView new];
    _ivTwoAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoAge.image = (active) ? activeAgeImage : grayAgeImage;
    [_ageGroupView addSubview:_ivTwoAge];
    [NSLayoutConstraint setWidht:36 height:35 forView:_ivTwoAge];
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivTwoAge
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:0
                                                                   toItem:_lbTitleAgeGrpup
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:21]];
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
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivThreeAge
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:0
                                                                 toItem:_lbTitleAgeGrpup
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:21]];
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
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivFourAge
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:0
                                                                 toItem:_lbTitleAgeGrpup
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:21]];
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivFourAge
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:0
                                                                   toItem:_ivThreeAge
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:33.5f]];
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
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:lable
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:4]];
    
    [_ageGroupView addConstraint:[NSLayoutConstraint constraintWithItem:lable
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
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
    
    [groupView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:groupView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:13.5f]];
    
    [groupView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:groupView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [label addConstraint: [NSLayoutConstraint constraintWithItem:label
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:0
                                                          toItem:nil
                                                       attribute:0
                                                      multiplier:1
                                                        constant:widht]];
    
    [label addConstraint: [NSLayoutConstraint constraintWithItem:label
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:0
                                                          toItem:nil
                                                       attribute:0
                                                      multiplier:1
                                                        constant:24]];
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
            case IND_FOOTBALL:
                memberSettings.football = !memberSettings.football;
                active = memberSettings.football;
                break;
            case IND_BASKETBALL:
                memberSettings.basketball = !memberSettings.basketball;
                active = memberSettings.basketball;
                break;
            case IND_VOLLEYBALL:
                memberSettings.volleyball = !memberSettings.volleyball;
                active = memberSettings.volleyball;
                break;
            case IND_HANDBALL:
                memberSettings.handball = !memberSettings.handball;
                active = memberSettings.handball;
                break;
            case IND_TENNIS:
                memberSettings.tennis = !memberSettings.tennis;
                active = memberSettings.tennis;
                break;
            case IND_HOCKEY:
                memberSettings.hockey = !memberSettings.hockey;
                active = memberSettings.hockey;
                break;
            case IND_SQUASH:
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
}

- (void) twoStarClick {
    [self enableSaveButton];
    
    oneStarStatus = twoStarStatus = YES;
    threeStarStatus = NO;
    _ivOneStarLevel.image = activeStarImage;
    _ivTwoStarLevel.image = activeStarImage;
    _ivThreeStarLevel.image = grayStarImage;
    
    memberSettings.level = LEVEL_2;
}

- (void) threeStarClick {
    [self enableSaveButton];
    
    oneStarStatus = twoStarStatus = threeStarStatus = YES;
    
    _ivOneStarLevel.image = activeStarImage;
    _ivTwoStarLevel.image = activeStarImage;
    _ivThreeStarLevel.image = activeStarImage;
    
    memberSettings.level = LEVEL_3;
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
    
    memberSettings.age = AGE_20;
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
    
    memberSettings.age = AGE_20_28;
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
    
    memberSettings.age = AGE_28_35;
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
    
    memberSettings.age = AGE_35;
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
    [btn setTitle:@"Выход" forState:UIControlStateNormal];
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
    
    [AppNetHelper saveSettings:memberSettings forUser:1 completionHandler:^(NSString *errorMessage) {
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







