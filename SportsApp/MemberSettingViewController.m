//
//  TestLayoutViewController.m
//  SportsApp
//
//  Created by sergeyZ on 23.05.15.
//
//

#import "MemberSettingViewController.h"
#import "UIViewController+Navigation.h"
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "SportInfo.h"
#import "SportItemUI.h"

#define PADDING_H 12.5
#define MAIN_SCROLL_CONTENT_HEIGHT 415
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
@property (strong, nonatomic) UIPageControl* sportsPageControl;
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

@end

@implementation MemberSettingViewController{
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
    
    //self.title = @"Мои настройки";
    [self setNavTitle:@"Мои настройки"];
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    [self setNavigationItems];
    
    kScrollItemWidht = self.view.bounds.size.width - PADDING_H * 2;
    
    _sportInfoItems = [[NSMutableArray alloc] initWithCapacity:6];
    
    SportInfo* sport1 = [SportInfo new];
    sport1.activeImage = [UIImage imageNamed:@"icon_sport_01_active.png"];
    sport1.inactiveImage = [UIImage imageNamed:@"icon_sport_01.png"];
    sport1.title = @"Футбол";
    [_sportInfoItems addObject:sport1];
    
    SportInfo* sport2 = [SportInfo new];
    sport2.activeImage = [UIImage imageNamed:@"icon_sport_02_active.png"];
    sport2.inactiveImage = [UIImage imageNamed:@"icon_sport_02.png"];
    sport2.title = @"Баскетбол";
    [_sportInfoItems addObject:sport2];
    
    SportInfo* sport3 = [SportInfo new];
    sport3.activeImage = [UIImage imageNamed:@"icon_sport_03_active.png"];
    sport3.inactiveImage = [UIImage imageNamed:@"icon_sport_03.png"];
    sport3.title = @"Волейбол";
    [_sportInfoItems addObject:sport3];
    
    SportInfo* sport4 = [SportInfo new];
    sport4.activeImage = [UIImage imageNamed:@"icon_sport_01_active.png"];
    sport4.inactiveImage = [UIImage imageNamed:@"icon_sport_01.png"];
    sport4.title = @"Футбол 1";
    [_sportInfoItems addObject:sport4];
    
    SportInfo* sport5 = [SportInfo new];
    sport5.activeImage = [UIImage imageNamed:@"icon_sport_02_active.png"];
    sport5.inactiveImage = [UIImage imageNamed:@"icon_sport_02.png"];
    sport5.title = @"Баскетбол 1";
    [_sportInfoItems addObject:sport5];
    
    SportInfo* sport6 = [SportInfo new];
    sport6.activeImage = [UIImage imageNamed:@"icon_sport_03_active.png"];
    sport6.inactiveImage = [UIImage imageNamed:@"icon_sport_03.png"];
    sport6.title = @"Волейбол 1";
    [_sportInfoItems addObject:sport6];
    
    
    grayStarImage = [UIImage imageNamed:@"icon_star.png"];
    activeStarImage = [UIImage imageNamed:@"icon_star_active.png"];
    grayAgeImage = [UIImage imageNamed:@"icon_age.png"];
    activeAgeImage = [UIImage imageNamed:@"icon_age_active.png"];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self setupButtonInParentView:self.view];
    [self setupContainerScroll];
    [self setupContainerView];
    
    [self setupSportsGroupInParentView:_containerView];
    [self setupLevelsGroupInParentView:_containerView];
    [self setupAgesGroupInParentView:_containerView];
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
    
    UIButton* btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAdd setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitle:@"Сохранить" forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnAdd setUserInteractionEnabled:NO];
    [btnAdd setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    [btnAdd sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    [btnAdd setEnabled:NO]; // !!
}

#pragma mark -
#pragma mark Containers
#pragma mark -
- (void) setupButtonInParentView:(UIView*)container {
    _btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSave.translatesAutoresizingMaskIntoConstraints = NO;
    //[_btnSave addTarget:self action:@selector(btnSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave setTitle:@"Сохранить" forState:UIControlStateNormal];
    [_btnSave setTintColor:[UIColor whiteColor]];
    _btnSave.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _btnSave.layer.borderWidth = 0.0;
    _btnSave.layer.cornerRadius = 6.0;
    _btnSave.layer.backgroundColor = [[UIColor colorWithRGBA:BG_BUTTON_COLOR] CGColor];
    
    [container addSubview:_btnSave];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnSave
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:-8]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnSave
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_btnSave
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-PADDING_H]];
    
    [_btnSave addConstraint: [NSLayoutConstraint constraintWithItem:_btnSave
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
                                                                  constant:164]];
    
    // subviews
    _lbTitleSportsGrpup = [UILabel new];
    [self setupTitle:_lbTitleSportsGrpup forGroup:_sportsGroupView withText:@"Мои виды спорта:" andWidht:124];
    
    [self setupSportsPageControl];
    [self setupSportsScroll];
    [self setupSportItemViews];
}

- (void) setupSportsPageControl {
    _sportsPageControl = [UIPageControl new];
    _sportsPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _sportsPageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    _sportsPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _sportsPageControl.userInteractionEnabled = NO;
    _sportsPageControl.numberOfPages = _sportInfoItems.count / 3;
    _sportsPageControl.currentPage = 0;
    [_sportsGroupView addSubview:_sportsPageControl];
    //_sportsPageControl.backgroundColor = [UIColor greenColor];
    
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
    int itemsCount = 2;
    _sportsScrollView = [UIScrollView new];
    _sportsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //[_sportsScrollView setBackgroundColor:[UIColor blueColor]];
    _sportsScrollView.delegate = self;
    _sportsScrollView.showsHorizontalScrollIndicator = NO;
    _sportsScrollView.pagingEnabled = YES;
    _sportsScrollView.contentSize = CGSizeMake(kScrollItemWidht * itemsCount, SCROLL_ITEM_HEIGHT);
    
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
        
        if(i == 0){
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
            [self layoutSportLeftIcon:uiItem.icon intoContainer:trinesView];
            [self layoutSportLable:uiItem.lable forIcon:uiItem.icon intoContainer:trinesView];
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
                                                           constant:20]];
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
                                                           constant:-20]];
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
    
    // icons !! order is important
    [self setupIconTwoStar];
    [self setupIconOneStar];
    [self setupIconThreeStar];
    [self setLevelImagesGestureRecognizers];
}

#pragma mark -
#pragma mark Layout LEVEL icons
- (void) setupIconTwoStar {
    _ivTwoStarLevel = [UIImageView new];
    _ivTwoStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoStarLevel.image = grayStarImage;
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

- (void) setupIconOneStar {
    _ivOneStarLevel = [UIImageView new];
    _ivOneStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneStarLevel.image = grayStarImage;
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

- (void) setupIconThreeStar {
    _ivThreeStarLevel = [UIImageView new];
    _ivThreeStarLevel.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeStarLevel.image = grayStarImage;
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
                                                                  constant:136.5]];//122

    // subviews
    _lbTitleAgeGrpup = [UILabel new];
    [self setupTitle:_lbTitleAgeGrpup forGroup:_ageGroupView withText:@"Мой возраст:" andWidht:106];
    
    // icons !! order is important
    [self setupIconAgeTwo];
    [self setupIconAgeOne];
    [self setupIconAgeThree];
    [self setupIconAgeFour];
    [self setAgeImagesGestureRecognizers];
    
    // lables
    _lbTitleOneAge = [UILabel new];
    [self setupAgeLable:_lbTitleOneAge forView:_ivOneAge withText:@"до 20" andColor:[UIColor colorWithRGBA:TXT_ACTIVE_COLOR]];
    
    _lbTitleTwoAge = [UILabel new];
    [self setupAgeLable:_lbTitleTwoAge forView:_ivTwoAge withText:@"20-28" andColor:[UIColor colorWithRGBA:TXT_INACTIVE_COLOR]];
    
    _lbTitleThreeAge = [UILabel new];
    [self setupAgeLable:_lbTitleThreeAge forView:_ivThreeAge withText:@"28-35" andColor:[UIColor colorWithRGBA:TXT_INACTIVE_COLOR]];
    
    _lbTitleFourAge = [UILabel new];
    [self setupAgeLable:_lbTitleFourAge forView:_ivFourAge withText:@"после 35" andColor:[UIColor colorWithRGBA:TXT_INACTIVE_COLOR]];
}

- (void) setupTitleAge {
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
}

#pragma mark -
#pragma mark Layout AGE icons
- (void) setupIconAgeOne {
    _ivOneAge = [UIImageView new];
    _ivOneAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneAge.image = activeAgeImage;
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

- (void) setupIconAgeTwo {
    _ivTwoAge = [UIImageView new];
    _ivTwoAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoAge.image = grayAgeImage;
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

- (void) setupIconAgeThree {
    _ivThreeAge = [UIImageView new];
    _ivThreeAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeAge.image = grayAgeImage;
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

- (void) setupIconAgeFour {
    _ivFourAge = [UIImageView new];
    _ivFourAge.translatesAutoresizingMaskIntoConstraints = NO;
    _ivFourAge.image = grayAgeImage;
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
                                                           constant:12]];
    
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
- (void) setupTitle:(UILabel*)lable forGroup:(UIView*)groupView withText:(NSString*)text andWidht:(CGFloat)widht {
    lable.translatesAutoresizingMaskIntoConstraints = NO;
    lable.text = text;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:11.0f];
    lable.layer.borderWidth = 0.5;
    lable.layer.cornerRadius = 12.0;
    lable.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    lable.layer.backgroundColor = [[UIColor colorWithRGBA:BG_GROUP_LABLE_COLOR] CGColor];
    [groupView addSubview:lable];
    
    [groupView addConstraint:[NSLayoutConstraint constraintWithItem:lable
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:groupView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:13.5f]];
    
    [groupView addConstraint:[NSLayoutConstraint constraintWithItem:lable
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:groupView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [lable addConstraint: [NSLayoutConstraint constraintWithItem:lable
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:0
                                                          toItem:nil
                                                       attribute:0
                                                      multiplier:1
                                                        constant:widht]];
    
    [lable addConstraint: [NSLayoutConstraint constraintWithItem:lable
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
    UIImageView* icon = (UIImageView*)gestureRecognizer.view;
    
    NSUInteger sportIndex = icon.tag;
    if(sportIndex < _sportUIItems.count){
        SportItemUI* sportUI = _sportUIItems[sportIndex];
        SportInfo* sportInfo = _sportInfoItems[sportIndex];
        
        if(sportUI.active){
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
    twoStarStatus = threeStarStatus = NO;
    _ivTwoStarLevel.image = grayStarImage;
    _ivThreeStarLevel.image = grayStarImage;
    
    if(oneStarStatus){
        oneStarStatus = NO;
        _ivOneStarLevel.image = grayStarImage;
    }
    else{
        oneStarStatus = YES;
        _ivOneStarLevel.image = activeStarImage;
    }
}

- (void) twoStarClick {
    oneStarStatus = twoStarStatus = YES;
    threeStarStatus = NO;
    _ivOneStarLevel.image = activeStarImage;
    _ivTwoStarLevel.image = activeStarImage;
    _ivThreeStarLevel.image = grayStarImage;
}

- (void) threeStarClick {
    oneStarStatus = twoStarStatus = threeStarStatus = YES;
    
    _ivOneStarLevel.image = activeStarImage;
    _ivTwoStarLevel.image = activeStarImage;
    _ivThreeStarLevel.image = activeStarImage;
}

#pragma mark -
#pragma mark Age
- (void) oneAgeClick {
    _ivOneAge.image = activeAgeImage;
    _ivTwoAge.image = grayAgeImage;
    _ivThreeAge.image = grayAgeImage;
    _ivFourAge.image = grayAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
}

- (void) twoAgeClick {
    _ivOneAge.image = grayAgeImage;
    _ivTwoAge.image = activeAgeImage;
    _ivThreeAge.image = grayAgeImage;
    _ivFourAge.image = grayAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
}

- (void) threeAgeClick {
    _ivOneAge.image = grayAgeImage;
    _ivTwoAge.image = grayAgeImage;
    _ivThreeAge.image = activeAgeImage;
    _ivFourAge.image = grayAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
}

- (void) fourAgeClick {
    _ivOneAge.image = grayAgeImage;
    _ivTwoAge.image = grayAgeImage;
    _ivThreeAge.image = grayAgeImage;
    _ivFourAge.image = activeAgeImage;
    
    _lbTitleOneAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleTwoAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleThreeAge.textColor = [UIColor colorWithRGBA:TXT_INACTIVE_COLOR];
    _lbTitleFourAge.textColor = [UIColor colorWithRGBA:TXT_ACTIVE_COLOR];
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
# pragma mark -
# pragma mark Navigation button click
- (void) btnCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnAddClick {
    NSLog(@"btnAddClick");
}
@end
