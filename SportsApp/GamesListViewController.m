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
#import "InviteUserViewController.h"
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
#define SECTION_HEIGHT 28.5f

#define CELL_PADDING_FIRST 5.5f
#define CELL_PADDING_NORMAL 2.5f

@interface GamesListViewController () <UITableViewDataSource, UITableViewDelegate, CitiesViewControllerDelegate, NewEvenViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myGames;
@property (strong, nonatomic) NSMutableArray *publicGames;

@end

@implementation GamesListViewController {
    NSUInteger currentUserId;
    NSString *selectedCity;
    
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
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = [self navigationItemTitleView:[UIImage imageNamed:@"icon_arrow_down.png"]
                                                            title:@"Все города"
                                                            color:[UIColor blackColor]];
    [self updateGamesListForCity:nil];
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
    controller.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
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
- (void)gameWasSavedWithController:(NewEvenViewController *)controller gameId:(NSUInteger)gameID {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self updateGamesListForCity:selectedCity];
    
    InviteUserViewController *inviteController = [[InviteUserViewController alloc] init];
    inviteController.gameId = gameID;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inviteController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableView delegate methods
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
    
    if(indexPath.section == SECTION_MY_GAMES)
        isLastRowInSection = (indexPath.row == _myGames.count - 1);
    else if(indexPath.section == SECTION_PUBLIC_GAMES)
        isLastRowInSection = (indexPath.row == _publicGames.count - 1);
    
    if(isFirstRowInSection && isLastRowInSection)
        return 100 + CELL_PADDING_FIRST; //105.5f;
    else if(isFirstRowInSection || isLastRowInSection)
        return 100 + CELL_PADDING_NORMAL; //102.75f;
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
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_blue.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Публичные игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    else if(section == SECTION_MY_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_orange.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, SECTION_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Мои игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GamesListCellTableIdentifier];
    if(cell == nil){
        cell = [[GamesListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GamesListCellTableIdentifier];
        
        GamesListTableViewCell *gameCell = (GamesListTableViewCell *)cell;
        gameCell.addressLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
        gameCell.dateLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
        gameCell.timeLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [cell setPreservesSuperviewLayoutMargins:NO];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
    
    
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
        [gameCell setTopPadding:CELL_PADDING_FIRST];
    else
        [gameCell setTopPadding:CELL_PADDING_NORMAL];
    
    if(isLastRowInSection)
        [gameCell setBottomPadding:-CELL_PADDING_FIRST];
    else
        [gameCell setBottomPadding:-CELL_PADDING_NORMAL];
    
    gameCell.gameNameLabel.text = game.gameName;
    
    BOOL hasAddressName = (game.addressName.length > 0);
    BOOL hasAddress = (game.address.length > 0);
    if(hasAddressName && hasAddress)
        gameCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", game.addressName, game.address];
    else if(hasAddressName)
        gameCell.addressLabel.text = [NSString stringWithFormat:@"%@", game.addressName];
    else if(hasAddress)
        gameCell.addressLabel.text = [NSString stringWithFormat:@"%@", game.address];
    
    gameCell.dateLabel.text = game.date;
    gameCell.timeLabel.text = game.time;
    
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
- (void) updateGamesListForCity:(NSString *)city {
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
#pragma mark Other
- (void)cityDidChanged:(CitiesViewController *)controller city:(NSString *)city {
    selectedCity = city;
    navTitleLabel.text = selectedCity;
    [self updateGamesListForCity:selectedCity];
}

@end






















