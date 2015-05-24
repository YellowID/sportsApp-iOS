//
//  NewEvenTTTViewController.m
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import "NewEvenViewController.h"
#import "NSLayoutConstraint+Helper.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#define PADDING_H 12
#define MAIN_SCROLL_CONTENT_HEIGHT 230
#define SCROLL_ITEM_HEIGHT 99

@interface NewEvenViewController ()

#pragma mark -
#pragma mark Containers
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIView* containerView;

#pragma mark -
#pragma mark Groups view
@property (strong, nonatomic) UIView* fieldsGroupView;
@property (strong, nonatomic) UIView* timeGroupView;
@property (strong, nonatomic) UIView* levelGroupView;

@property (strong, nonatomic) UITextField* tfKindOfSport;
@property (strong, nonatomic) UITextField* tfLocation;

@property (strong, nonatomic) UILabel* lblTime;
@property (strong, nonatomic) UILabel* lblPeopleNumber;

@property (strong, nonatomic) UIImageView* ivOneStar;
@property (strong, nonatomic) UIImageView* ivTwoStar;
@property (strong, nonatomic) UIImageView* ivThreeStar;

@end

@implementation NewEvenViewController{
    UIImage* grayStarImage;
    UIImage* activeStarImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Новое событие";
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelClick)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIBarButtonItem *btnCreate = [[UIBarButtonItem alloc] initWithTitle:@"Создать" style:UIBarButtonItemStylePlain target:self action:@selector(btnCreateClick)];
    self.navigationItem.rightBarButtonItem = btnCreate;
    
    //[self setNavigationItems];
    
    grayStarImage = [UIImage imageNamed:@"icon_star_small.png"];
    activeStarImage = [UIImage imageNamed:@"icon_star_small_active.png"];
    
    _ivOneStar.userInteractionEnabled = YES;
    _ivOneStar.image = activeStarImage;
    UITapGestureRecognizer *tapOneStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneStarClick)];
    [_ivOneStar addGestureRecognizer:tapOneStarGesture];
    
    _ivTwoStar.userInteractionEnabled = YES;
    _ivTwoStar.image = grayStarImage;
    UITapGestureRecognizer *tapTwoStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoStarClick)];
    [_ivTwoStar addGestureRecognizer:tapTwoStarGesture];
    
    _ivThreeStar.userInteractionEnabled = YES;
    _ivThreeStar.image = grayStarImage;
    UITapGestureRecognizer *tapThreeStarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeStarClick)];
    [_ivThreeStar addGestureRecognizer:tapThreeStarGesture];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    [self setupContainers];
    [self setupFieldsGroup];
    [self setupTimeGroup];
    [self setupLevelGroup];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnCancel setTitle:@"Отмена" forState:UIControlStateNormal];
    //[btnCancel setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 3, 0.0)];
    [btnCancel sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCreate setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnCreate setTitle:@"Создать" forState:UIControlStateNormal];
    //[btnCreate setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 3, 0.0)];
    [btnCreate sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCreate];
}

# pragma mark -
# pragma mark Containers
- (void) setupContainers {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //_scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_scrollView];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, MAIN_SCROLL_CONTENT_HEIGHT)];
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
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_fieldsGroupView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_containerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:8]];
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_fieldsGroupView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:_containerView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_H]];
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_fieldsGroupView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:_containerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-PADDING_H]];
    
    [_fieldsGroupView addConstraint: [NSLayoutConstraint constraintWithItem:_fieldsGroupView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:77]];
    
    UIView* separator = [UIView new];
    [self setupSeparator:separator intoGroup:_fieldsGroupView];
    
    [self setupKindOfSportField];
    [self setupLocationField];
}

- (void) setupKindOfSportField {
    _tfKindOfSport = [UITextField new];
    _tfKindOfSport.translatesAutoresizingMaskIntoConstraints = NO;
    _tfKindOfSport.placeholder = @"Вид спорта";
    _tfKindOfSport.font = [UIFont systemFontOfSize:12.0f];
    [_fieldsGroupView addSubview:_tfKindOfSport];
    
    [_fieldsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_tfKindOfSport
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:0
                                                                    toItem:_fieldsGroupView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:4]];
    
    [_fieldsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_tfKindOfSport
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:0
                                                                    toItem:_fieldsGroupView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:PADDING_H]];
    
    [_fieldsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_tfKindOfSport
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:0
                                                                    toItem:_fieldsGroupView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-PADDING_H]];
    
    [_tfKindOfSport addConstraint: [NSLayoutConstraint constraintWithItem:_tfKindOfSport
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:0
                                                                   toItem:nil
                                                                attribute:0
                                                               multiplier:1
                                                                 constant:30]];
}

- (void) setupLocationField {
    _tfLocation = [UITextField new];
    _tfLocation.translatesAutoresizingMaskIntoConstraints = NO;
    _tfLocation.placeholder = @"Место";
    _tfLocation.font = [UIFont systemFontOfSize:12.0f];
    [_fieldsGroupView addSubview:_tfLocation];
    
    [_fieldsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_tfLocation
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:0
                                                                    toItem:_fieldsGroupView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:-4]];
    
    [_fieldsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_tfLocation
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:0
                                                                    toItem:_fieldsGroupView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:PADDING_H]];
    
    [_fieldsGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_tfLocation
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:0
                                                                    toItem:_fieldsGroupView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-PADDING_H]];
    
    [_tfLocation addConstraint: [NSLayoutConstraint constraintWithItem:_tfLocation
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:0
                                                            multiplier:1
                                                              constant:30]];
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
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeGroupView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_fieldsGroupView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:8]];
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeGroupView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:_containerView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:PADDING_H]];
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeGroupView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:_containerView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_H]];
    
    [_timeGroupView addConstraint: [NSLayoutConstraint constraintWithItem:_timeGroupView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:38]];
    
    [self setupTitleForTimeGroup];
    [self setupLableTime];
}

- (void) setupTitleForTimeGroup {
    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = @"Начало";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_timeGroupView addSubview:title];
    
    [NSLayoutConstraint setWidht:60 height:21 forView:title];
    
    [_timeGroupView addConstraint:[NSLayoutConstraint constraintWithItem:title
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:0
                                                             toItem:_timeGroupView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
    [_timeGroupView addConstraint:[NSLayoutConstraint constraintWithItem:title
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:_timeGroupView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:PADDING_H]];
}

- (void) setupLableTime {
    _lblTime = [UILabel new];
    _lblTime.translatesAutoresizingMaskIntoConstraints = NO;
    _lblTime.text = @"17 июля 2015 г. 17:00";
    _lblTime.textAlignment = NSTextAlignmentRight;
    _lblTime.font = [UIFont systemFontOfSize:12.0f];
    [_lblTime sizeToFit];
    [_timeGroupView addSubview:_lblTime];
    
    [_timeGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_lblTime
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:0
                                                                  toItem:_timeGroupView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
    
    [_timeGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_lblTime
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:_timeGroupView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_H]];
    
    [_lblTime addConstraint: [NSLayoutConstraint constraintWithItem:_lblTime
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:0
                                                          toItem:nil
                                                       attribute:0
                                                      multiplier:1
                                                        constant:21]];
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
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_levelGroupView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_timeGroupView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:8]];
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_levelGroupView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:_containerView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:PADDING_H]];
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_levelGroupView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:_containerView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_H]];
    
    [_levelGroupView addConstraint: [NSLayoutConstraint constraintWithItem:_levelGroupView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:77]];
    
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
    title.text = @"Количество людей";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_levelGroupView addSubview:title];
    
    [NSLayoutConstraint setWidht:152 height:21 forView:title];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:title
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_levelGroupView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:10]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:title
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:_levelGroupView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:PADDING_H]];
}

- (void) setupTitleForLevelRow {
    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = @"Требуемый уровень";
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [_levelGroupView addSubview:title];
    
    [NSLayoutConstraint setWidht:152 height:21 forView:title];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:title
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:0
                                                                   toItem:_levelGroupView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-10]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:title
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:0
                                                                   toItem:_levelGroupView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:PADDING_H]];
}

- (void) setupLablePeopleNumber {
    _lblPeopleNumber = [UILabel new];
    _lblPeopleNumber.translatesAutoresizingMaskIntoConstraints = NO;
    _lblPeopleNumber.text = @"15";
    _lblPeopleNumber.textAlignment = NSTextAlignmentRight;
    _lblPeopleNumber.font = [UIFont systemFontOfSize:12.0f];
    [_levelGroupView addSubview:_lblPeopleNumber];
    
    [NSLayoutConstraint setWidht:40 height:21 forView:_lblPeopleNumber];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_lblPeopleNumber
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_levelGroupView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:10]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_lblPeopleNumber
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:_levelGroupView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_H]];
}

#pragma mark -
#pragma mark Star icons
- (void) setupIconOneStar {
    _ivOneStar = [UIImageView new];
    _ivOneStar.translatesAutoresizingMaskIntoConstraints = NO;
    _ivOneStar.image = activeStarImage;
    [_levelGroupView addSubview:_ivOneStar];
    [NSLayoutConstraint setWidht:18 height:17 forView:_ivOneStar];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivOneStar
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:0
                                                                   toItem:_levelGroupView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-10]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivOneStar
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:0
                                                                   toItem:_ivTwoStar
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:-20]];
}

- (void) setupIconTwoStar {
    _ivTwoStar = [UIImageView new];
    _ivTwoStar.translatesAutoresizingMaskIntoConstraints = NO;
    _ivTwoStar.image = grayStarImage;
    [_levelGroupView addSubview:_ivTwoStar];
    [NSLayoutConstraint setWidht:18 height:17 forView:_ivTwoStar];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivTwoStar
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:0
                                                                   toItem:_levelGroupView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-10]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivTwoStar
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:0
                                                                   toItem:_ivThreeStar
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:-20]];
}

- (void) setupIconThreeStar {
    _ivThreeStar = [UIImageView new];
    _ivThreeStar.translatesAutoresizingMaskIntoConstraints = NO;
    _ivThreeStar.image = grayStarImage;
    [_levelGroupView addSubview:_ivThreeStar];
    [NSLayoutConstraint setWidht:18 height:17 forView:_ivThreeStar];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivThreeStar
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:0
                                                                   toItem:_levelGroupView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:-10]];
    
    [_levelGroupView addConstraint:[NSLayoutConstraint constraintWithItem:_ivThreeStar
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:0
                                                                   toItem:_levelGroupView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:-PADDING_H]];
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

# pragma mark -
# pragma mark Navigation button click
- (void) btnCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnCreateClick {
    NSLog(@"btnCreateClick");
}

#pragma mark -
#pragma mark Star icon click
- (void) oneStarClick {
    _ivTwoStar.image = grayStarImage;
    _ivThreeStar.image = grayStarImage;
}

- (void) twoStarClick {
    _ivTwoStar.image = activeStarImage;
    _ivThreeStar.image = grayStarImage;
}

- (void) threeStarClick {
    _ivTwoStar.image = activeStarImage;
    _ivThreeStar.image = activeStarImage;
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, MAIN_SCROLL_CONTENT_HEIGHT);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}



@end























