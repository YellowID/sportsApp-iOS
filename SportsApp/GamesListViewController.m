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

#define SECTION_MY_GAMES 0
#define SECTION_PUBLIC_GAMES 1

@interface GamesListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myGames;
@property (strong, nonatomic) NSMutableArray *publicGames;

@end

@implementation GamesListViewController

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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRGBA:CELL_SEPARATOR_COLOR];
    
    //UINib *nib = [UINib nibWithNibName:@"GamesListTableViewCell" bundle:nil];
    //[self.tableView registerNib:nib forCellReuseIdentifier:GamesListCellTableIdentifier];
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

#pragma mark -
#pragma mark Navigation Items
- (void) setNavigationItems {
    // left
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAdd setFrame:CGRectMake(0, 8.0f, 40.0f, 36.0f)];
    [btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitle:@"Создать игру" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnAdd sizeToFit];
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
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == SECTION_PUBLIC_GAMES)
        return 34.0f;
    else
        return 34.0f; //0.1
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = nil;
    
    if(section == SECTION_PUBLIC_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34.0f)];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [[UIColor colorWithRGBA:PUBLIC_GAMES_SECTION_BORDER_COLOR] CGColor];
        view.layer.backgroundColor = [[UIColor colorWithRGBA:PUBLIC_GAMES_SECTION_COLOR] CGColor];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, 34.0f)];
        [label setFont:[UIFont systemFontOfSize:13]];
        label.text = @"Публичные игры";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
    }
    else if(section == SECTION_MY_GAMES){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34.0f)];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [[UIColor colorWithRGBA:MY_GAMES_SECTION_BORDER_COLOR] CGColor];
        view.layer.backgroundColor = [[UIColor colorWithRGBA:MY_GAMES_SECTION_COLOR] CGColor];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 0, tableView.frame.size.width, 34.0f)];
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
    
    if((indexPath.row % 2) == 0) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor colorWithRGBA:BG_GRAY_COLOR]];
    }
    
    GamesListTableViewCell* gameCell = (GamesListTableViewCell *)cell;
    
    GameInfo* game = nil;
    if(indexPath.section == SECTION_MY_GAMES){
        game = _myGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:MY_GAMES_SECTION_COLOR];
        
    }
    else if(indexPath.section == SECTION_PUBLIC_GAMES){
        game = _publicGames[indexPath.row];
        gameCell.gameNameLabel.textColor = [UIColor colorWithRGBA:PUBLIC_GAMES_SECTION_COLOR];
    }
    
    
    gameCell.gameNameLabel.text = game.gameName;
    
    gameCell.addressLabel.text = [NSString stringWithFormat:@"%@, %@", game.addressName, game.address];
    gameCell.addressLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.dateLabel.text = game.date;
    gameCell.dateLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.timeLabel.text = game.time;
    gameCell.timeLabel.textColor = [UIColor colorWithRGBA:TXT_LITTLE_COLOR];
    
    gameCell.ivAdmin.image = [UIImage imageNamed:@"icon_status_admin.png"];
    gameCell.ivStatus.image = [UIImage imageNamed:@"icon_status_go.png"];
    
    gameCell.ivLocation.image = [UIImage imageNamed:@"icon_location.png"];
    gameCell.ivTime.image = [UIImage imageNamed:@"icon_time.png"];
    gameCell.ivDate.image = [UIImage imageNamed:@"icon_date.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController* controller = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Other
- (void) loadData {
    _myGames = [NSMutableArray new];
    for(int i = 0; i < 4; ++i){
        GameInfo* game = [GameInfo new];
        game.gameName = [NSString stringWithFormat:@"My Game %lu", (unsigned long)i];
        game.address = @"просп. Независимости 192б";
        game.addressName = @"Всем спорт";
        game.date = @"через 3 дня";
        game.time = @"20:00";
        
        [_myGames addObject:game];
    }
    
    _publicGames = [NSMutableArray new];
    for(int i = 0; i < 4; ++i){
        GameInfo* game = [GameInfo new];
        game.gameName = [NSString stringWithFormat:@"Public Game %lu", (unsigned long)i];
        game.address = @"просп. Независимости 999 Ш/2";
        game.addressName = @"Ооочень длинный бассейн";
        game.date = @"через 13 дней";
        game.time = @"20:00";
        
        [_publicGames addObject:game];
    }
}

@end






















