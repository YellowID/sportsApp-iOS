//
//  NewEventViewController.m
//  SportsApp
//
//  Created by sergeyZ on 21.05.15.
//
//

#import "NewEventViewController.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

@interface NewEventViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;

@property (strong, nonatomic) IBOutlet UIView* fielsGroupView;
@property (strong, nonatomic) IBOutlet UIView* timeGroupView;
@property (strong, nonatomic) IBOutlet UIView* gamerGroupView;

@property (strong, nonatomic) IBOutlet UITextField* tfKindOfSport;
@property (strong, nonatomic) IBOutlet UITextField* tfLocation;

@property (strong, nonatomic) IBOutlet UILabel* lblTime;

@property (strong, nonatomic) IBOutlet UIImageView* ivOneStar;
@property (strong, nonatomic) IBOutlet UIImageView* ivTwoStar;
@property (strong, nonatomic) IBOutlet UIImageView* ivThreeStar;

@end

@implementation NewEventViewController{
    UIImage* grayStarImage;
    UIImage* activeStarImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Новое событие";
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    _fielsGroupView.layer.borderWidth = 1.0;
    _fielsGroupView.layer.cornerRadius = 6.0;
    _fielsGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    
    _timeGroupView.layer.borderWidth = 1.0;
    _timeGroupView.layer.cornerRadius = 6.0;
    _timeGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    
    _gamerGroupView.layer.borderWidth = 1.0;
    _gamerGroupView.layer.cornerRadius = 6.0;
    _gamerGroupView.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
    
    /**/
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

- (void) btnCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnCreateClick {
    NSLog(@"btnCreateClick");
}

#pragma mark -
#pragma mark Stars methods
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
    CGFloat bottomView = _gamerGroupView.frame.origin.y + _gamerGroupView.frame.size.height + 160;
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_scrollView.contentInset.top, 0.0, kbSize.height, 0.0);
    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(_scrollView.contentInset.top, 0.0, bottomSide, 0.0);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, bottomView);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
