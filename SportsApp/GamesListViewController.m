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

static const NSUInteger kAlertAPNS = 1;

static const NSUInteger kSectionMyGames = 0;
static const NSUInteger kSectionPublicGames = 1;

static const CGFloat kSectionHeaderHeight = 28.5f;
static const CGFloat kCellPaddingNormal = 2.5f;
static const CGFloat kCellPaddingFirst = 5.5f;

@interface GamesListViewController () <UITableViewDataSource, UITableViewDelegate, CitiesViewControllerDelegate, NewEvenViewControllerDelegate, ChatViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myGames;
@property (strong, nonatomic) NSMutableArray *publicGames;

@end

@implementation GamesListViewController {
    NSUInteger currentUserId;
    NSString *selectedCity;
    
    UILabel *navTitleLabel;
}

static NSString *const kGamesListCellTableIdentifier = @"GamesListCellTableIdentifier";

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
                                                            title:NSLocalizedString(@"TITLE_ALL_CITIES", nil)
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

- (void)needUpdateGamesWithController:(ChatViewController *)controller {
    [self updateGamesListForCity:selectedCity];
}

#pragma mark -
#pragma mark UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == kSectionMyGames)
        return _myGames.count;
    else if(section == kSectionPublicGames)
        return _publicGames.count;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isFirstRowInSection = (indexPath.row == 0);
    BOOL isLastRowInSection = NO;
    
    if(indexPath.section == kSectionMyGames)
        isLastRowInSection = (indexPath.row == _myGames.count - 1);
    else if(indexPath.section == kSectionPublicGames)
        isLastRowInSection = (indexPath.row == _publicGames.count - 1);
    
    if(isFirstRowInSection && isLastRowInSection)
        return 100 + kCellPaddingFirst; //105.5f;
    else if(isFirstRowInSection || isLastRowInSection)
        return 100 + kCellPaddingNormal; //102.75f;
    else
        return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = nil;
    
    if(section == kSectionPublicGames){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_blue.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, kSectionHeaderHeight)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = NSLocalizedString(@"TITLE_PUBLIC_GAMES", nil);
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    else if(section == kSectionMyGames){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_orange.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, kSectionHeaderHeight)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = NSLocalizedString(@"TITLE_MY_GAMES", nil);
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGamesListCellTableIdentifier];
    if(cell == nil){
        cell = [[GamesListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGamesListCellTableIdentifier];
        
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
    if(indexPath.section == kSectionMyGames){
        game = _myGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:MY_GAMES_SECTION_COLOR];
        
        gameCell.ivLocation.image = [UIImage imageNamed:@"icon_location_orange.png"];
        gameCell.ivTime.image = [UIImage imageNamed:@"icon_time_orange.png"];
        gameCell.ivDate.image = [UIImage imageNamed:@"icon_date_orange.png"];
        
        isLastRowInSection = (indexPath.row == _myGames.count - 1);
    }
    else if(indexPath.section == kSectionPublicGames){
        game = _publicGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:PUBLIC_GAMES_SECTION_COLOR];
        
        gameCell.ivLocation.image = [UIImage imageNamed:@"icon_location_blue.png"];
        gameCell.ivTime.image = [UIImage imageNamed:@"icon_time_blue.png"];
        gameCell.ivDate.image = [UIImage imageNamed:@"icon_date_blue.png"];
        
        isLastRowInSection = (indexPath.row == _publicGames.count - 1);
    }
    BOOL isFirstRowInSection = (indexPath.row == 0);
    
    if(isFirstRowInSection)
        [gameCell setTopPadding:kCellPaddingFirst];
    else
        [gameCell setTopPadding:kCellPaddingNormal];
    
    if(isLastRowInSection)
        [gameCell setBottomPadding:-kCellPaddingFirst];
    else
        [gameCell setBottomPadding:-kCellPaddingNormal];
    
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
    
    if(game.participateStatus == UserGameParticipateStatusNo)
        gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_no.png"];
    else if(game.participateStatus == UserGameParticipateStatusYes)
        gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_go.png"];
    else
        gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_q.png"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *games = (indexPath.section == 0) ? _myGames : _publicGames;
    GameInfo *game = games[indexPath.row];
        
    ChatViewController *controller = [[ChatViewController alloc] init];
    controller.gameId = game.gameId;
    controller.delegate = self;
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
                [self setNavTitle:NSLocalizedString(@"GAMES", nil)];
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:errorMessage
                                      delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
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
                
                [self notifyForInviteIfNeeded];
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

- (void) notifyForInviteIfNeeded {
    NSString *notificationObjectId = [[AppDelegate instance] lastNotificationObjectId];
    if(notificationObjectId){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                            message:NSLocalizedString(@"MSG_INVITE_NOTIFICATION", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL_1", nil)
                                                  otherButtonTitles:NSLocalizedString(@"BTN_VIEW", nil), nil];
        alertView.tag = kAlertAPNS;
        [alertView show];
    }
}

#pragma mark -
#pragma mark Notifications Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kAlertAPNS) {
        if(buttonIndex == 0){ // cancel
            
        }
        else if(buttonIndex == 1){ // open
            ChatViewController *controller = [[ChatViewController alloc] init];
            controller.gameId = [[[AppDelegate instance] lastNotificationObjectId] integerValue];
            controller.delegate = nil;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        [[AppDelegate instance] setLastNotificationObjectId:nil];
    }
}

@end






















