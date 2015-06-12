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
#import "AppNetHelper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define SECTION_MY_GAMES 0
#define SECTION_PUBLIC_GAMES 1

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
    
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationItems];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    
    currentUserId = [AppDelegate instance].currentUserId;
    [AppNetHelper gamesForUser:currentUserId completionHandler:^(NSMutableArray *arrayData, NSString *errorMessage) {
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
                [self showData:arrayData];
            }
        });
    }];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // left
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
    
    //[btnAdd sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    
    //right
    NSMutableArray *rightBarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *btnExit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_exit.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnExitClick)];
    [rightBarItems addObject:btnExit];
    
    UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSettingClick)];
    [rightBarItems addObject:btnSetting];
    self.navigationItem.rightBarButtonItems = rightBarItems;
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
    return 81;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == SECTION_PUBLIC_GAMES)
        return 35.0f;
    else
        return 35.0f; //0.1
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = nil;
    
    if(section == SECTION_PUBLIC_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35.0f)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_blue.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, 35.0f)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Публичные игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    else if(section == SECTION_MY_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35.0f)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tbl_section_green.png"]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, 35.0f)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Мои игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    
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
        
        isLastRowInSection = (indexPath.row == _myGames.count - 1);
    }
    else if(indexPath.section == SECTION_PUBLIC_GAMES){
        game = _publicGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:PUBLIC_GAMES_SECTION_COLOR];
        
        isLastRowInSection = (indexPath.row == _publicGames.count - 1);
    }

    UIColor *highlightedColor = [UIColor colorWithRGBA:BG_SELECTED_ROW_COLOR];
    [gameCell setBackgroundColor:highlightedColor forState:UIControlStateHighlighted];
    
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
    
    gameCell.gameNameLabel.text = game.gameName;
    
    gameCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", game.addressName, game.address];
    gameCell.addressLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.dateLabel.text = game.date;
    gameCell.dateLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.timeLabel.text = game.time;
    gameCell.timeLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.ivLocation.image = [UIImage imageNamed:@"icon_location.png"];
    gameCell.ivTime.image = [UIImage imageNamed:@"icon_time.png"];
    gameCell.ivDate.image = [UIImage imageNamed:@"icon_date.png"];
    
    //
    
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
    ChatViewController* controller = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Other
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






















