//
//  GamesListViewController.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "GamesListViewController.h"
#import "MemberViewController.h"
#import "NewEvenViewController.h"
#import "GamesListTableViewCell.h"
#import "MemberSettingViewController.h"
#import "ChatViewController.h"
#import "CitiesViewController.h"
#import "GameInfo.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIViewController+Navigation.h"
#import "UIView+Utility.h"
#import "NSLayoutConstraint+Helper.h"

#define SECTION_MY_GAMES 0
#define SECTION_PUBLIC_GAMES 1
#define SECTION_HEIGHT 28.5f //35.0f //40.5f

@interface GamesListViewController () <UITableViewDataSource, UITableViewDelegate, CitiesViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myGames;
@property (strong, nonatomic) NSMutableArray *publicGames;

@end

@implementation GamesListViewController {
    NSUInteger currentUserId;
    
    UILabel *navTitleLabel;
}

static NSString *GamesListCellTableIdentifier = @"GamesListCellTableIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationItems];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor colorWithRGBA:BG_GRAY_COLOR]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //UINib *nib = [UINib nibWithNibName:@"GamesListTableViewCell" bundle:nil];
    //[self.tableView registerNib:nib forCellReuseIdentifier:GamesListCellTableIdentifier];
    [self.view addSubview:self.tableView];
    
    //[self prepareData:nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    currentUserId = [AppDelegate instance].user.uid;
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking gamesInCity:nil completionHandler:^(NSMutableArray *myGames, NSMutableArray *publicGames, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(errorMessage){
                [self setNavTitle:@"Игры"];
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:errorMessage
                                      delegate:nil
                                      cancelButtonTitle:@"Ок"
                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                self.navigationItem.titleView = [self navigationItemTitleView:[UIImage imageNamed:@"icon_arrow_down.png"]
                                                                        title:@"Все города"
                                                                        color:[UIColor blackColor]];
                
                if(!myGames)
                    _myGames = [NSMutableArray new];
                else
                    _myGames = myGames;
                
                if(!publicGames)
                    _publicGames = [NSMutableArray new];
                else
                    _publicGames = publicGames;
                
                [_tableView reloadData];
            }
        });
    }];
}

#pragma mark -
#pragma mark Navigation Bar
- (void) setNavigationItems {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSettingClick)];
    self.navigationItem.leftBarButtonItem = btnSetting;
    
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_plus.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnAddClick)];
    self.navigationItem.rightBarButtonItem = btnAdd;
}

- (UIView *) navigationItemTitleView: (UIImage *)icon title:(NSString *)text color:(UIColor *)c {
    UIView *navigationTitleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 32)];
    [navigationTitleContainer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [navigationTitleContainer setClipsToBounds:YES];
    //[navigationTitleContainer setBackgroundColor:[UIColor greenColor]];
    
    UIView *titleView = [UIView new];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView setBackgroundColor:[UIColor grayColor]];
    [navigationTitleContainer addSubview:titleView];
    
    [NSLayoutConstraint centerVertical:titleView withView:navigationTitleContainer inContainer:navigationTitleContainer];
    [NSLayoutConstraint centerHorizontal:titleView withView:navigationTitleContainer inContainer:navigationTitleContainer];
    
    NSDictionary* constr_views = NSDictionaryOfVariableBindings(titleView);
    NSString* hc_str = @"H:|-(>=0)-[titleView]-(>=0)-|";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:constr_views];
    [navigationTitleContainer addConstraints:hzConstraints];
    
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = icon;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView addSubview:imageView];
    
    navTitleLabel = [UILabel new];
    navTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    navTitleLabel.numberOfLines = 1;
    navTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//UILineBreakModeTailTruncation;
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.font = [UIFont systemFontOfSize:14];
    [navTitleLabel setText: text];
    [navTitleLabel setTextColor:c];
    
    [titleView addSubview:navTitleLabel];
    
    [NSLayoutConstraint setWidht:9.5f height:5.5f forView:imageView];
    [NSLayoutConstraint centerVertical:imageView withView:titleView inContainer:titleView];
    
    [NSLayoutConstraint setHeight:30 forView:navTitleLabel];
    [NSLayoutConstraint centerVertical:navTitleLabel withView:titleView inContainer:titleView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(imageView, navTitleLabel);
    NSString* hc_str2 = @"H:|-(>=2)-[navTitleLabel]-4-[imageView]-(>=2)-|";
    NSArray* hzConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:hc_str2 options:0 metrics:nil views:views];
    [titleView addConstraints:hzConstraints2];
    
    navigationTitleContainer.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCity)];
    [navigationTitleContainer addGestureRecognizer:tapGesture];
    
    return navigationTitleContainer;
}

- (void) btnMyGamesClick {
    MemberViewController *controller = [[MemberViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) btnAddClick {
    NewEvenViewController *controller = [[NewEvenViewController alloc] init];
    controller.isEditGameMode = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) btnSettingClick {
    MemberSettingViewController *controller = [[MemberSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) chooseCity {
    CitiesViewController *controller = [[CitiesViewController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) btnExitClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView delegate methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == SECTION_MY_GAMES)
        return _myGames.count;
    else if(section == SECTION_PUBLIC_GAMES)
        return _publicGames.count;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isFirstRowInSection = (indexPath.row == 0);
    BOOL isLastRowInSection = NO;
    
    if(indexPath.section == SECTION_MY_GAMES){
        isLastRowInSection = (indexPath.row == _myGames.count - 1);
    }
    else if(indexPath.section == SECTION_PUBLIC_GAMES){
        isLastRowInSection = (indexPath.row == _publicGames.count - 1);
    }
    
    if(isFirstRowInSection && isLastRowInSection)
        return 105.5f;
    else if(isFirstRowInSection || isLastRowInSection)
        return 102.75f;
    else
        return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == SECTION_PUBLIC_GAMES)
        return SECTION_HEIGHT;
    else
        return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = nil;
    
    if(section == SECTION_PUBLIC_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        //view = [UIView new];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_blue.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Публичные игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    else if(section == SECTION_MY_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        //view = [UIView new];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_orange.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Мои игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    
    /*
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:mainView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:2.75]];
    
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:mainView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-2.75]];
    
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:mainView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    
    [mainView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:mainView
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    
    [mainView addSubview:view];
    */
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GamesListCellTableIdentifier];
    if(cell == nil)
        cell = [[GamesListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GamesListCellTableIdentifier];
    
    GamesListTableViewCell* gameCell = (GamesListTableViewCell *)cell;
    
    BOOL isLastRowInSection = NO;
    GameInfo* game = nil;
    if(indexPath.section == SECTION_MY_GAMES){
        game = _myGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:MY_GAMES_SECTION_COLOR];
        
        gameCell.ivLocation.image = [UIImage imageNamed:@"icon_location_orange.png"];
        gameCell.ivTime.image = [UIImage imageNamed:@"icon_time_orange.png"];
        gameCell.ivDate.image = [UIImage imageNamed:@"icon_date_orange.png"];
        
        isLastRowInSection = (indexPath.row == _myGames.count - 1);
    }
    else if(indexPath.section == SECTION_PUBLIC_GAMES){
        game = _publicGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:PUBLIC_GAMES_SECTION_COLOR];
        
        gameCell.ivLocation.image = [UIImage imageNamed:@"icon_location_blue.png"];
        gameCell.ivTime.image = [UIImage imageNamed:@"icon_time_blue.png"];
        gameCell.ivDate.image = [UIImage imageNamed:@"icon_date_blue.png"];
        
        isLastRowInSection = (indexPath.row == _publicGames.count - 1);
    }
    BOOL isFirstRowInSection = (indexPath.row == 0);
    
    if(isFirstRowInSection)
        [gameCell setTopPadding:5.5f];
    else
        [gameCell setTopPadding:2.75f];
        
    if(isLastRowInSection)
        [gameCell setBottomPadding:-5.5f];
    else
        [gameCell setBottomPadding:-2.75f];
    
    

    UIColor *highlightedColor = [UIColor colorWithRGBA:BG_SELECTED_ROW_COLOR];
    [gameCell setBackgroundColor:highlightedColor forState:UIControlStateHighlighted];
    
    /*
    if((indexPath.row % 2) == 0) {
        if(isLastRowInSection){
            UIColor *colorFormImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_cell_white.png"]];
            [gameCell setBackgroundColor:colorFormImage forState:UIControlStateNormal];
        }
        else{
            UIColor *colorFormImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_cell_white_line.png"]];
            [gameCell setBackgroundColor:colorFormImage forState:UIControlStateNormal];
        }
    }
    else {
        if(isLastRowInSection){
            UIColor *colorFormImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_cell_gray.png"]];
            [gameCell setBackgroundColor:colorFormImage forState:UIControlStateNormal];
        }
        else{
            UIColor *colorFormImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_cell_gray_line.png"]];
            [gameCell setBackgroundColor:colorFormImage forState:UIControlStateNormal];
        }
    }
     */
    
    gameCell.gameNameLabel.text = game.gameName; // [self gameNameForTypeId:game.gameId];
    
    gameCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", game.addressName, game.address];
    gameCell.addressLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.dateLabel.text = game.date;
    gameCell.dateLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.timeLabel.text = game.time;
    gameCell.timeLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    if(game.adminId == currentUserId)
        gameCell.ivAdmin.image = [UIImage imageNamed:@"icon_status_admin.png"];
    else
        gameCell.ivAdmin.image = nil;
    
    if(game.participateStatus == PARTICIPATE_STATUS_NO)
        gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_no.png"];
    else if(game.participateStatus == PARTICIPATE_STATUS_YES)
        gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_go.png"];
    else
        gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_q.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *games = (indexPath.section == 0) ? _myGames : _publicGames;
    GameInfo *game = games[indexPath.row];
        
    ChatViewController *controller = [[ChatViewController alloc] init];
    controller.gameId = game.gameId;
    [self.navigationController pushViewController:controller animated:YES];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Other
- (void)cityDidChanged:(CitiesViewController *)controller city:(NSString *)city {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    currentUserId = [AppDelegate instance].user.uid;
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking gamesInCity:city completionHandler:^(NSMutableArray *myGames, NSMutableArray *publicGames, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(errorMessage){
                [self setNavTitle:@"Игры"];
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:errorMessage
                                      delegate:nil
                                      cancelButtonTitle:@"Ок"
                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                navTitleLabel.text = city;
                //navTitleLabel.text = @"Санкт-Петербург и еще длиннее название ыдвла";
                
                if(!myGames)
                    _myGames = [NSMutableArray new];
                else
                    _myGames = myGames;
                
                if(!publicGames)
                    _publicGames = [NSMutableArray new];
                else
                    _publicGames = publicGames;
                
                [_tableView reloadData];
            }
        });
    }];
}

@end






















