//
//  NewEvenTTTViewController.m
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import "NewEvenViewController.h"
#import "UIViewController+Navigation.h"
#import "PlaceSearchViewController.h"
#import "InviteUserViewController.h"
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "NewGame.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#import "NSDate+Formater.h"
#import "NSDate+Utilities.h"

#import "CustomTextField.h"

static const NSUInteger kPickerPeopleNumber = 0;
static const NSUInteger kPickerAge = 1;
static const NSUInteger kPickerSport = 2;

static const CGFloat kHorizontalPadding = 12.0f;
static const CGFloat kScrollContentHeight = 340.0f;

@interface NewEvenViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PlaceSearchViewControllerDelegate>

#pragma mark -
#pragma mark Containers
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIView* containerView;

#pragma mark -
#pragma mark Groups view
@property (strong, nonatomic) UIView* fieldsGroupView;
@property (strong, nonatomic) UIView* ageGroupView;
@property (strong, nonatomic) UIView* timeGroupView;
@property (strong, nonatomic) UIView* levelGroupView;

@property (strong, nonatomic) UITextField* tfKindOfSport;
@property (strong, nonatomic) UIPickerView* sportPicker;

@property (strong, nonatomic) UITextField* tfLocation;
@property (strong, nonatomic) UITextField* tfTime;

@property (strong, nonatomic) UIDatePicker* dateTimePicker;

@property (strong, nonatomic) UITextField* tfAge;
@property (strong, nonatomic) UIPickerView* agePicker;

@property (strong, nonatomic) UITextField* tfPeopleNumber;
@property (strong, nonatomic) UIPickerView* peopleNumberPicker;

@property (strong, nonatomic) UIImageView* ivOneStar;
@property (strong, nonatomic) UIImageView* ivTwoStar;
@property (strong, nonatomic) UIImageView* ivThreeStar;

@property (strong, nonatomic) UIButton* btnCreate;

@end

@implementation NewEvenViewController{
    UIImage *grayStarImage;
    UIImage *activeStarImage;
    
    BOOL oneStarStatus, twoStarStatus, threeStarStatus;
    
    NSArray *sportItems;
    NSArray *ageItems;
    NSMutableArray *peopleNumberItems;
    
    NewGame *newGame;
    GameInfo *editGameInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    grayStarImage = [UIImage imageNamed:@"icon_star_small.png"];
    activeStarImage = [UIImage imageNamed:@"icon_star_small_active.png"];
    
    // pickers
    peopleNumberItems = [NSMutableArray new];
    for(int i = 0; i < 100; ++i){
        NSString* numberStr = [NSString stringWithFormat:@"%lu", (unsigned long) i+1];
        [peopleNumberItems addObject:numberStr];
    }
    _peopleNumberPicker = [[UIPickerView alloc] init];
    _peopleNumberPicker.dataSource = self;
    _peopleNumberPicker.delegate = self;
    _peopleNumberPicker.tag = kPickerPeopleNumber;
    _peopleNumberPicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    ageItems = @[NSLocalizedString(@"TXT_AGE_UNTIL_20", nil),
                 NSLocalizedString(@"TXT_AGE_20_28", nil),
                 NSLocalizedString(@"TXT_AGE_28_35", nil),
                 NSLocalizedString(@"TXT_AGE_AFTER_35", nil)];
    _agePicker = [[UIPickerView alloc] init];
    _agePicker.dataSource = self;
    _agePicker.delegate = self;
    _agePicker.tag = kPickerAge;
    _agePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    sportItems = @[NSLocalizedString(@"STORT_FOOTBALL", nil),
                   NSLocalizedString(@"STORT_BASKETBALL", nil),
                   NSLocalizedString(@"STORT_VOLLEYBALL", nil),
                   NSLocalizedString(@"STORT_HANDBALL", nil),
                   NSLocalizedString(@"STORT_TENNIS", nil),
                   NSLocalizedString(@"STORT_HOCKEY", nil),
                   NSLocalizedString(@"STORT_SQUASH", nil)];
    _sportPicker = [[UIPickerView alloc] init];
    _sportPicker.dataSource = self;
    _sportPicker.delegate = self;
    _sportPicker.tag = kPickerSport;
    _sportPicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // UIDatePicker
    NSDate* todayDate = [NSDate date];
    _dateTimePicker = [UIDatePicker new];
    _dateTimePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_dateTimePicker setDate:todayDate];
    [_dateTimePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDate *twoYearsFromToday = [todayDate dateByAddingYears:2];
    _dateTimePicker.minimumDate = todayDate;
    _dateTimePicker.maximumDate = twoYearsFromToday;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    newGame = [NewGame new];
    //newGame.time = [datePicker.date toJsonFormat];
    
    if(_isEditGameMode){
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
                else{
                    editGameInfo = gameInfo;
                    newGame.sportType = editGameInfo.sportType;
                    newGame.time = editGameInfo.startAt;
                    
                    newGame.age = editGameInfo.age;
                    newGame.level = editGameInfo.level;
                    newGame.players = editGameInfo.numbers;
                    
                    newGame.placeName = editGameInfo.addressName;
                    
                    // UI
                    [self setNavTitle:NSLocalizedString(@"TITLE_NEW_EVENT", nil)];
                    [self setNavigationItems];
                    
                    [self setupContainers];
                    [self setupFieldsGroup];
                    [self setupTimeGroup];
                    [self setupAgeGroup];
                    [self setupLevelGroup];
                    
                    NSDate *editDate = [NSDate dateWithJsonString:editGameInfo.startAt];
                    [_dateTimePicker setDate:editDate];
                    
                    [_sportPicker selectRow:editGameInfo.sportType-1 inComponent:0 animated:NO];
                    [_peopleNumberPicker selectRow:editGameInfo.numbers-1 inComponent:0 animated:NO];
                    [_agePicker selectRow:editGameInfo.age-1 inComponent:0 animated:NO];
                    
                    if(editGameInfo.level == PlayerLevelBeginner)
                        [self oneStarClick];
                    else if(editGameInfo.level == PlayerLevelMiddling)
                        [self twoStarClick];
                    else if(editGameInfo.level == PlayerLevelMaster)
                        [self threeStarClick];
                }
            });
        }];
    }
    else{
        [self setNavTitle:NSLocalizedString(@"TITLE_NEW_EVENT", nil)];
        [self setNavigationItems];
        
        [self setupContainers];
        [self setupFieldsGroup];
        [self setupTimeGroup];
        [self setupAgeGroup];
        [self setupLevelGroup];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_tfLocation resignFirstResponder];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitle:NSLocalizedString(@"BTN_CANCEL_1", nil) forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnCancel setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnCancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    _btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnCreate setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [_btnCreate addTarget:self action:@selector(btnCreateClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(_isEditGameMode)
        [_btnCreate setTitle:NSLocalizedString(@"BTN_CHANGE", nil) forState:UIControlStateNormal];
    else
        [_btnCreate setTitle:NSLocalizedString(@"BTN_CREATE", nil) forState:UIControlStateNormal];
    
    _btnCreate.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_btnCreate setUserInteractionEnabled:NO];
    [_btnCreate setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [_btnCreate setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    [_btnCreate sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btnCreate];
    [_btnCreate setEnabled:NO]; // !!
}

# pragma mark -
# pragma mark Containers
- (void) setupContainers {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //_scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_scrollView];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScrollContentHeight)];
    //_containerView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:_containerView];
}

#pragma mark -
#pragma mark FIELDs group
- (void) setupFieldsGroup {
    _fieldsGroupView = [UIView new];
    _fieldsGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _fieldsGroupView.backgroundColor = [UIColor whiteColor];
    _fieldsGroupView.layer.borderWidth = 0.5;
    _fieldsGroupView.layer.cornerRadius = 6.0;
    _fieldsGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [_containerView addSubview:_fieldsGroupView];
    
    [NSLayoutConstraint setHeight:77 forView:_fieldsGroupView];
    [NSLayoutConstraint setTopPadding:8 forView:_fieldsGroupView inContainer:_containerView];
    [NSLayoutConstraint stretchHorizontal:_fieldsGroupView inContainer:_containerView withPadding:kHorizontalPadding];
    
    UIView* separator = [UIView new];
    [self setupSeparator:separator intoGroup:_fieldsGroupView];
    
    [self setupKindOfSportField];
    [self setupLocationField];
}

- (void) setupKindOfSportField {
    _tfKindOfSport = [UITextField new];
    _tfKindOfSport.translatesAutoresizingMaskIntoConstraints = NO;
    _tfKindOfSport.delegate = self;
    _tfKindOfSport.placeholder = NSLocalizedString(@"TXT_SPORT_TYPE", nil);
    
    [self setReadyButtonForTextField:_tfKindOfSport];
    
    if(_isEditGameMode){
        _tfKindOfSport.text = editGameInfo.gameName;
        _tfKindOfSport.enabled = NO;
        _tfKindOfSport.userInteractionEnabled = NO;
        _tfKindOfSport.textColor = [UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR];
    }
    
    _tfKindOfSport.font = [UIFont systemFontOfSize:12.0f];
    [_fieldsGroupView addSubview:_tfKindOfSport];
    
    [NSLayoutConstraint setHeight:30 forView:_tfKindOfSport];
    [NSLayoutConstraint setTopPadding:4 forView:_tfKindOfSport inContainer:_fieldsGroupView];
    [NSLayoutConstraint stretchHorizontal:_tfKindOfSport inContainer:_fieldsGroupView withPadding:kHorizontalPadding];
}

- (void) setupLocationField {
    _tfLocation = [UITextField new];
    _tfLocation.delegate = self;
    _tfLocation.translatesAutoresizingMaskIntoConstraints = NO;
    _tfLocation.placeholder = NSLocalizedString(@"TXT_PLACE", nil);
    
    if(_isEditGameMode)
        _tfLocation.text = editGameInfo.addressName;
    
    _tfLocation.font = [UIFont systemFontOfSize:12.0f];
    [_fieldsGroupView addSubview:_tfLocation];
    
    [NSLayoutConstraint setHeight:30 forView:_tfLocation];
    [NSLayoutConstraint setBottomPadding:4 forView:_tfLocation inContainer:_fieldsGroupView];
    [NSLayoutConstraint stretchHorizontal:_tfLocation inContainer:_fieldsGroupView withPadding:kHorizontalPadding];
}

#pragma mark -
#pragma mark AGEs group
- (void) setupAgeGroup {
    _ageGroupView = [UIView new];
    _ageGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _ageGroupView.backgroundColor = [UIColor whiteColor];
    _ageGroupView.layer.borderWidth = 0.5;
    _ageGroupView.layer.cornerRadius = 6.0;
    _ageGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [_containerView addSubview:_ageGroupView];
    
    [NSLayoutConstraint setHeight:38 forView:_ageGroupView];
    [NSLayoutConstraint setTopDistance:8 fromView:_ageGroupView toView:_timeGroupView inContainer:_containerView];
    [NSLayoutConstraint stretchHorizontal:_ageGroupView inContainer:_containerView withPadding:kHorizontalPadding];
    
    [self setupTitleForAgeGroup];
    [self setupLableAge];
}

- (void) setupTitleForAgeGroup {
    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = NSLocalizedString(@"TXT_AGE", nil);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_ageGroupView addSubview:title];
    
    [NSLayoutConstraint setWidht:60 height:21 forView:title];
    [NSLayoutConstraint setLeftPadding:kHorizontalPadding forView:title inContainer:_ageGroupView];
    [NSLayoutConstraint centerVertical:title withView:_ageGroupView inContainer:_ageGroupView];
}

- (void) setupLableAge {
    _tfAge = [UITextField new];
    _tfAge.translatesAutoresizingMaskIntoConstraints = NO;
    _tfAge.delegate = self;
    _tfAge.placeholder = NSLocalizedString(@"TXT_AGE_20_28", nil);
    
    [self setReadyButtonForTextField:_tfAge];
    
    if(_isEditGameMode){
        if(editGameInfo.age > 0 && editGameInfo.age <= ageItems.count)
            _tfAge.text = ageItems[editGameInfo.age - 1];
    }
    
    _tfAge.textAlignment = NSTextAlignmentRight;
    _tfAge.font = [UIFont systemFontOfSize:12.0f];
    
    [_ageGroupView addSubview:_tfAge];
    
    [NSLayoutConstraint setWidht:160 height:30 forView:_tfAge];
    [NSLayoutConstraint setRightPadding:kHorizontalPadding forView:_tfAge inContainer:_ageGroupView];
    [NSLayoutConstraint centerVertical:_tfAge withView:_ageGroupView inContainer:_ageGroupView];
}

#pragma mark -
#pragma mark TIMEs group
- (void) setupTimeGroup {
    _timeGroupView = [UIView new];
    _timeGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _timeGroupView.backgroundColor = [UIColor whiteColor];
    _timeGroupView.layer.borderWidth = 0.5;
    _timeGroupView.layer.cornerRadius = 6.0;
    _timeGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [_containerView addSubview:_timeGroupView];
    
    [NSLayoutConstraint setHeight:38 forView:_timeGroupView];
    [NSLayoutConstraint setTopDistance:8 fromView:_timeGroupView toView:_fieldsGroupView inContainer:_containerView];
    [NSLayoutConstraint stretchHorizontal:_timeGroupView inContainer:_containerView withPadding:kHorizontalPadding];
    
    [self setupTitleForTimeGroup];
    [self setupLableTime];
}

- (void) setupTitleForTimeGroup {
    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = NSLocalizedString(@"TXT_STARTING", nil);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_timeGroupView addSubview:title];
    
    [NSLayoutConstraint setWidht:60 height:21 forView:title];
    [NSLayoutConstraint setLeftPadding:kHorizontalPadding forView:title inContainer:_timeGroupView];
    [NSLayoutConstraint centerVertical:title withView:_timeGroupView inContainer:_timeGroupView];
}

- (void) setupLableTime {
    _tfTime = [UITextField new];
    _tfTime.translatesAutoresizingMaskIntoConstraints = NO;
    _tfTime.delegate = self;
    _tfTime.textAlignment = NSTextAlignmentRight;
    _tfTime.font = [UIFont systemFontOfSize:12.0f];
    
    [self setReadyButtonForTextField:_tfTime];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"d MMMM yyyy HH:mm"];
    
    _tfTime.placeholder = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    
    if(_isEditGameMode){
        NSDate *dateToDisplay = [NSDate dateWithJsonString:editGameInfo.startAt];
        _tfTime.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dateToDisplay]];
    }
    
    [_timeGroupView addSubview:_tfTime];
    
    [NSLayoutConstraint setWidht:200 height:30 forView:_tfTime];
    [NSLayoutConstraint setRightPadding:kHorizontalPadding forView:_tfTime inContainer:_timeGroupView];
    [NSLayoutConstraint centerVertical:_tfTime withView:_timeGroupView inContainer:_timeGroupView];
}

#pragma mark -
#pragma mark LEVELs group
- (void) setupLevelGroup {
    _levelGroupView = [UIView new];
    _levelGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    _levelGroupView.backgroundColor = [UIColor whiteColor];
    _levelGroupView.layer.borderWidth = 0.5;
    _levelGroupView.layer.cornerRadius = 6.0;
    _levelGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    [_containerView addSubview:_levelGroupView];
    
    [NSLayoutConstraint setHeight:77 forView:_levelGroupView];
    [NSLayoutConstraint setTopDistance:8 fromView:_levelGroupView toView:_ageGroupView inContainer:_containerView];
    [NSLayoutConstraint stretchHorizontal:_levelGroupView inContainer:_containerView withPadding:kHorizontalPadding];
    
    UIView* separator = [UIView new];
    [self setupSeparator:separator intoGroup:_levelGroupView];
    
    [self setupTitleForPeopleNumberRow];
    [self setupLablePeopleNumber];
    
    [self setupTitleForLevelRow];
    [self setupIconThreeStar];
    [self setupIconTwoStar];
    [self setupIconOneStar];
    [self setLevelImagesGestureRecognizers];
}

- (void) setupTitleForPeopleNumberRow {
    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = NSLocalizedString(@"TXT_NUMBER_OF_PEOPLE", nil);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_levelGroupView addSubview:title];
    
    title.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapSportRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peopleNumberClick)];
    [title addGestureRecognizer:tapSportRecognizer];
    
    [NSLayoutConstraint setWidht:152 height:30 forView:title];
    [NSLayoutConstraint setTopPadding:5 forView:title inContainer:_levelGroupView];
    [NSLayoutConstraint setLeftPadding:kHorizontalPadding forView:title inContainer:_levelGroupView];
}

- (void) setupTitleForLevelRow {
    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = NSLocalizedString(@"TXT_REQUIRED_LEVEL", nil);
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_levelGroupView addSubview:title];
    
    [NSLayoutConstraint setWidht:152 height:30 forView:title];
    [NSLayoutConstraint setLeftPadding:kHorizontalPadding forView:title inContainer:_levelGroupView];
    [NSLayoutConstraint setBottomPadding:5 forView:title inContainer:_levelGroupView];
}

- (void) setupLablePeopleNumber {
    _tfPeopleNumber = [UITextField new];
    _tfPeopleNumber.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPeopleNumber.delegate = self;
    _tfPeopleNumber.placeholder = @"15";
    
    [self setReadyButtonForTextField:_tfPeopleNumber];
    
    if(_isEditGameMode)
        _tfPeopleNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)editGameInfo.numbers];
    
    _tfPeopleNumber.textAlignment = NSTextAlignmentRight;
    _tfPeopleNumber.font = [UIFont systemFontOfSize:12.0f];
    [_levelGroupView addSubview:_tfPeopleNumber];
    
    [NSLayoutConstraint setWidht:140 height:30 forView:_tfPeopleNumber];
    [NSLayoutConstraint setRightPadding:kHorizontalPadding forView:_tfPeopleNumber inContainer:_levelGroupView];
    [NSLayoutConstraint setTopPadding:5 forView:_tfPeopleNumber inContainer:_levelGroupView];
}

#pragma mark -
#pragma mark Star icons
- (void) setupIconOneStar {
    _ivOneStar = [UIImageView new];
    _ivOneStar.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneStar.image = grayStarImage;
    [_levelGroupView addSubview:_ivOneStar];
    
    [NSLayoutConstraint setWidht:18 height:17 forView:_ivOneStar];
    [NSLayoutConstraint setBottomPadding:12 forView:_ivOneStar inContainer:_levelGroupView];
    [NSLayoutConstraint setRightDistance:20 fromView:_ivOneStar toView:_ivTwoStar inContainer:_levelGroupView];
}

- (void) setupIconTwoStar {
    _ivTwoStar = [UIImageView new];
    _ivTwoStar.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoStar.image = grayStarImage;
    [_levelGroupView addSubview:_ivTwoStar];
    
    [NSLayoutConstraint setWidht:18 height:17 forView:_ivTwoStar];
    [NSLayoutConstraint setBottomPadding:12 forView:_ivTwoStar inContainer:_levelGroupView];
    [NSLayoutConstraint setRightDistance:20 fromView:_ivTwoStar toView:_ivThreeStar inContainer:_levelGroupView];
}

- (void) setupIconThreeStar {
    _ivThreeStar = [UIImageView new];
    _ivThreeStar.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeStar.image = grayStarImage;
    [_levelGroupView addSubview:_ivThreeStar];
    
    [NSLayoutConstraint setWidht:18 height:17 forView:_ivThreeStar];
    [NSLayoutConstraint setBottomPadding:12 forView:_ivThreeStar inContainer:_levelGroupView];
    [NSLayoutConstraint setRightPadding:kHorizontalPadding forView:_ivThreeStar inContainer:_levelGroupView];
}

- (void) setLevelImagesGestureRecognizers {
    _ivOneStar.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapOneStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneStarClick)];
    [_ivOneStar addGestureRecognizer:tapOneStarGesture];
    
    _ivTwoStar.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapTwoStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoStarClick)];
    [_ivTwoStar addGestureRecognizer:tapTwoStarGesture];
    
    _ivThreeStar.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapThreeStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeStarClick)];
    [_ivThreeStar addGestureRecognizer:tapThreeStarGesture];
}

#pragma mark -
#pragma mark UI helper methods
- (void) setupSeparator:(UIView*)separator intoGroup:(UIView*)group {
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithRGBA:VIEW_SEPARATOR_COLOR];
    [group addSubview:separator];
    
    [NSLayoutConstraint setHeight:0.5f forView:separator];
    [NSLayoutConstraint stretchHorizontal:separator inContainer:group withPadding:kHorizontalPadding];
    [NSLayoutConstraint centerVertical:separator withView:group inContainer:group];
}

# pragma mark -
# pragma mark Navigation button click
- (void) btnCancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) btnCreateClick {
    [_tfKindOfSport resignFirstResponder];
    [_tfLocation resignFirstResponder];
    [_tfTime resignFirstResponder];
    [_tfAge resignFirstResponder];
    [_tfPeopleNumber resignFirstResponder];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    
    if(_isEditGameMode){
        [appNetworking editGame:newGame withId:_gameId completionHandler:^(NSString *errorMessage) {
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
                    if([self.delegate respondsToSelector:@selector(gameWasSavedWithController:gameId:)])
                        [self.delegate gameWasSavedWithController:self gameId:_gameId];
                    else
                        [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    }
    else{
        [appNetworking createNewGame:newGame completionHandler:^(NSUInteger gameId, NSString *errorMessage) {
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
                    if([self.delegate respondsToSelector:@selector(gameWasSavedWithController:gameId:)])
                        [self.delegate gameWasSavedWithController:self gameId:_gameId];
                    else
                        [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    }
}

- (void) btnReadyClick {
    [self.view endEditing:YES]; // hide keyboard
}

#pragma mark -
#pragma mark PlaceSearchViewControllerDelegate
- (void)gamePlaceDidChanged:(PlaceSearchViewController *)controller place:(FoursquareResponse *)placeLocation {
    if(placeLocation){
        //_tfLocation.text = placeLocation.name;
        
        if(placeLocation.address)
            _tfLocation.text = [NSString stringWithFormat:@"%@, %@", placeLocation.city, placeLocation.address];
        else
            _tfLocation.text = [NSString stringWithFormat:@"%@", placeLocation.name];
        
        newGame.placeName = placeLocation.name;
        newGame.country = placeLocation.country;
        newGame.city = placeLocation.city;
        newGame.address = placeLocation.address;
        newGame.latitude = placeLocation.lat;
        newGame.longitude = placeLocation.lng;
    }
}

#pragma mark -
#pragma mark Star icon click
- (void) oneStarClick {
    twoStarStatus = threeStarStatus = NO;
    _ivTwoStar.image = grayStarImage;
    _ivThreeStar.image = grayStarImage;
    
    oneStarStatus = YES;
    _ivOneStar.image = activeStarImage;
    newGame.level = PlayerLevelBeginner;
    
    /*
    if(oneStarStatus){
        oneStarStatus = NO;
        _ivOneStar.image = grayStarImage;
        
        newGame.level = LEVEL_UNKNOWN;
    }
    else{
        oneStarStatus = YES;
        _ivOneStar.image = activeStarImage;
        
        newGame.level = LEVEL_1;
    }
    */
    
    [self changeCreateButtonIfNeeded];
}

- (void) twoStarClick {
    oneStarStatus = twoStarStatus = YES;
    threeStarStatus = NO;
    _ivOneStar.image = activeStarImage;
    _ivTwoStar.image = activeStarImage;
    _ivThreeStar.image = grayStarImage;
    
    newGame.level = PlayerLevelMiddling;
    [self changeCreateButtonIfNeeded];
}

- (void) threeStarClick {
    oneStarStatus = twoStarStatus = threeStarStatus = YES;
    
    _ivOneStar.image = activeStarImage;
    _ivTwoStar.image = activeStarImage;
    _ivThreeStar.image = activeStarImage;
    
    newGame.level = PlayerLevelMaster;
    [self changeCreateButtonIfNeeded];
}

#pragma mark -
#pragma mark People number click
- (void) peopleNumberClick {
    _tfPeopleNumber.inputView = _peopleNumberPicker;
}

#pragma mark -
#pragma mark UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag == kPickerPeopleNumber)
        return [peopleNumberItems count];
    else if(pickerView.tag == kPickerAge)
        return [ageItems count];
    else if(pickerView.tag == kPickerSport)
        return [sportItems count];
    
    return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView.tag == kPickerPeopleNumber)
        return peopleNumberItems[row];
    else if(pickerView.tag == kPickerAge)
        return ageItems[row];
    else if(pickerView.tag == kPickerSport)
        return sportItems[row];
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag == kPickerPeopleNumber){
        _tfPeopleNumber.text = peopleNumberItems[row];
        newGame.players = row + 1;
        [self changeCreateButtonIfNeeded];
    }
    else if(pickerView.tag == kPickerAge){
        _tfAge.text = ageItems[row];
        newGame.age = row + 1;
        [self changeCreateButtonIfNeeded];
    }
    else if(pickerView.tag == kPickerSport){
        _tfKindOfSport.text = sportItems[row];
        newGame.sportType = row + 1;
        [self changeCreateButtonIfNeeded];
    }
}

#pragma mark -
#pragma mark UIDatePicker delegate
- (void) datePickerDateChanged:(UIDatePicker *)datePicker {
    if (datePicker == _dateTimePicker){
        _tfTime.text = [datePicker.date toFormat:@"d MMMM yyyy HH:mm"];
        
        newGame.time = [datePicker.date toJsonFormat];
        [self changeCreateButtonIfNeeded];
    }
}

#pragma mark -
#pragma mark UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _tfKindOfSport){
        textField.inputView = _sportPicker;
    }
    else if (textField == _tfPeopleNumber){
        textField.inputView = _peopleNumberPicker;
    }
    else if (textField == _tfAge){
        textField.inputView = _agePicker;
    }
    else if(textField == _tfTime){
        textField.inputView = _dateTimePicker;
    }
    else if(textField == _tfLocation){
        PlaceSearchViewController *controller = [[PlaceSearchViewController alloc] init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, kScrollContentHeight);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark -
#pragma mark Other methods
- (void) changeCreateButtonIfNeeded {
    if(newGame.sportType <= 0)
        return;
    
    if(newGame.time == nil)
        return;
    
    if(newGame.age == 0)
        return;
    
    if(newGame.level == 0)
        return;
    
    if(newGame.players == 0)
        return;
    
    [_btnCreate setEnabled:YES];
    [_btnCreate setUserInteractionEnabled:YES];
}

- (void) setReadyButtonForTextField:(UITextField *)textField {
    UIButton *btnReady = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnReady setFrame:CGRectMake(0, 0.0f, 51.0f, 36.0f)];
    [btnReady addTarget:self action:@selector(btnReadyClick) forControlEvents:UIControlEventTouchUpInside];
    [btnReady setTitle:NSLocalizedString(@"BTN_READY", nil) forState:UIControlStateNormal];
    [btnReady setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btnReady.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnReady setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    textField.rightView = btnReady;
}

- (GameInfo *) gameInfoFromNewGame:(NewGame *)game {
    GameInfo *gi = [GameInfo new];
    gi.sportType = game.sportType;
    gi.addressName = game.placeName;
    gi.address = game.address;
    gi.startAt = game.time;
    
    gi.age = game.age;
    gi.level = game.level;
    gi.numbers = game.players;
    
    NSDate *gameDate = [NSDate dateWithJsonString:gi.startAt];
    gi.time = [gameDate toFormat:@"HH:mm"];
    
    if([gameDate isToday]){
        gi.date = NSLocalizedString(@"TXT_TODAY", nil);
    }
    else {
        NSInteger days = [gameDate daysAfterDate:[NSDate new]];
        
        if(days < 0)
            gi.date = NSLocalizedString(@"TXT_GAME_OVER", nil);
        else
            gi.date = [NSString stringWithFormat:NSLocalizedString(@"TXT_IN_DAYS", nil), (long)days];
    }
    
    return gi;
}

@end























