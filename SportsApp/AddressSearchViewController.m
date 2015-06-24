//
//  AddressSearchViewController.m
//  SportsApp
//
//  Created by sergeyZ on 23.06.15.
//
//

#import "AddressSearchViewController.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "AppNetHelper.h"

@interface AddressSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UITextField* searchField;
@property (strong, nonatomic) UITableView* tableView;


@end

@implementation AddressSearchViewController{
    NSArray *items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *btnChoose = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnChooseClick)];
    self.navigationItem.rightBarButtonItem = btnChoose;
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 490, 30)];
    [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _searchField.delegate = self;
    _searchField.placeholder = @"Адрес";
    [_searchField setBorderStyle:UITextBorderStyleRoundedRect];
    _searchField.backgroundColor = [UIColor colorWithRGBA:BG_SEARCH_FIELD_COLOR];
    _searchField.textAlignment = NSTextAlignmentLeft;
    _searchField.font = [UIFont systemFontOfSize:12.0f];
    self.navigationItem.titleView = _searchField;
    
    //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark UITableView delegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
    //return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    
    YandexGeoResponse *placemark = items[indexPath.row];
    cell.textLabel.text = placemark.name;
    if(placemark.descr)
        cell.detailTextLabel.text = placemark.descr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(addressDidChanged:place:)]){
        YandexGeoResponse *placemark = items[indexPath.row];
        [self.delegate addressDidChanged:self place:placemark];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark TextField delegate
- (void) textFieldDidChange:(UITextField *)textField {
    if (textField == _searchField){
        if(![textField.text isEmpty]){
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startSearchYandex) userInfo:nil repeats:NO];
        }
        else{
            items = [NSArray new];
            [_tableView reloadData];
        }
    }
}

- (void) startSearchYandex {
    [AppNetHelper findYandexAddress:_searchField.text completionHandler:^(NSMutableArray *resp, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!resp){
                items = [NSArray new];
            }
            else{
                items = resp;
            }
            
            [_tableView reloadData];
        });
    }];
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

# pragma mark -
- (void) btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnChooseClick {
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //CGFloat bottom = _searchBar.frame.origin.y + 44;
    CGRect frame = _tableView.frame;
    frame.size.height = self.view.frame.size.height - kbSize.height;// - bottom;
    _tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
