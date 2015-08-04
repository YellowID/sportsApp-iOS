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
#import "GameInfo.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIViewController+Navigation.h"

#define SECTION_MY_GAMES 0
#define SECTION_PUBLIC_GAMES 1
#define SECTION_HEIGHT 28.5f //35.0f //40.5f

@interface GamesListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myGames;
@property (strong, nonatomic) NSMutableArray *publicGames;

@end

@implementation GamesListViewController{
    NSUInteger currentUserId;
}

static NSString *GamesListCellTableIdentifier = @"GamesListCellTableIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"Игры"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationItems];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor colorWithRGBA:BG_GRAY_COLOR]];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor colorWithRGBA:CELL_SEPARATOR_COLOR];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //UINib *nib = [UINib nibWithNibName:@"GamesListTableViewCell" bundle:nil];
    //[self.tableView registerNib:nib forCellReuseIdentifier:GamesListCellTableIdentifier];
    [self.view addSubview:self.tableView];
    
    //[self prepareData:nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    currentUserId = [AppDelegate instance].user.uid;
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking gamesForCurrentUserCompletionHandler:^(NSMutableArray *myGames, NSMutableArray *publicGames, NSString *errorMessage) {
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
                if(!myGames)
                    _myGames = [NSMutableArray new];
                else
                    _myGames = myGames;
                
                if(!publicGames)
                    _publicGames = [NSMutableArray new];
                else
                    _publicGames = publicGames;
                
                [_tableView reloadData];
                
                //[self showData:arrayData];
            }
        });
    }];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    /*
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAdd setFrame:CGRectMake(0, 8.0f, 120.0f, 36.0f)];
    [btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitle:@"Создать игру" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [btnAdd setImage:[UIImage imageNamed:@"ic_plus.png"] forState:UIControlStateNormal];
    btnAdd.imageEdgeInsets = UIEdgeInsetsMake(-1, -21, 0, 0);
    btnAdd.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    */
    
    UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSettingClick)];
    self.navigationItem.leftBarButtonItem = btnSetting;
    
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_plus.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnAddClick)];
    self.navigationItem.rightBarButtonItem = btnAdd;
}

- (void) btnMyGamesClick {
    MemberViewController *controller = [[MemberViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) btnAddClick {
    NewEvenViewController *controller = [[NewEvenViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) btnSettingClick {
    MemberSettingViewController* controller = [[MemberSettingViewController alloc] init];
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
/*
- (NSString *) gameNameForTypeId:(NSUInteger)gameType {
    NSString *name = @"";
    
    if(gameType == 1)
        name = @"Футбол";
    else if(gameType == 2)
        name = @"Баскетбол";
    else if(gameType == 3)
        name = @"Волейбол";
    else if(gameType == 4)
        name = @"Гандбол";
    else if(gameType == 5)
        name = @"Тенис";
    else if(gameType == 6)
        name = @"Хоккей";
    else if(gameType == 7)
        name = @"Сквош";
        
    
    return name;
}
 */

- (void) showData:(NSMutableArray *)games {
    _myGames = [NSMutableArray new];
    _publicGames = [NSMutableArray new];
    
    for(GameInfo* game in games){
        if(game.adminId == currentUserId)
            [_myGames addObject:game];
        else
            [_publicGames addObject:game];
    }
    
    [_tableView reloadData];
}

@end






















