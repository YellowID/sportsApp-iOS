//
//  PlaceSearchViewController.m
//  SportsApp
//
//  Created by sergeyZ on 29.05.15.
//
//

#import "PlaceSearchViewController.h"
#import "AddressSearchViewController.h"
#import "UIViewController+Navigation.h"
#import "NSLayoutConstraint+Helper.h"
#import "CustomSearchBar.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"
#import "AppNetworking.h"
#import "MBProgressHUD.h"
#import "FoursquareResponse.h"
#import "CustomButton.h"
#import "UIImage+Utilities.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

static const CGFloat kNavbarHeight = 108.0f;
static const CGFloat kHUDProgressOffset = -60.0f;

static const NSUInteger kAlertGeoDeny = 1;

static const NSUInteger kDisplayPlaces = 1;
static const NSUInteger kDisplayAddresses = 2;

static NSString *const kSimpleTableIdentifier = @"SimpleTableIdentifier";

@interface PlaceSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, AddressSearchViewControllerDelegate>

@property (strong, nonatomic) UIView *fakeNavBarView;

@property (strong, nonatomic) UITableView* tableView;

@property (strong, nonatomic) UITextField* searchPlacesField;
@property (strong, nonatomic) UITextField* searchAddressField;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@end

@implementation PlaceSearchViewController {
    YandexGeoResponse *yandexGeoResponse;
    
    NSArray *places;
    NSArray *addresses;
    int itemsForDisplay;
    
    BOOL locationFound;
    BOOL wasDisplayedAfterAddressDelegate;
    
    NSTimer *searchTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"TXT_PLACE", nil)];
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    [self setupFakeNavigationBar];
    
    itemsForDisplay = kDisplayPlaces;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kNavbarHeight) style:UITableViewStyleGrouped];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    //_tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark NavigationBar View
- (void) setupFakeNavigationBar {
    _fakeNavBarView = [UIView new];
    _fakeNavBarView.frame = CGRectMake(0, 0, self.view.bounds.size.width, kNavbarHeight);
    _fakeNavBarView.backgroundColor = [UIColor colorWithRGBA:BG_SEARCH_NAVBAR_COLOR];
    [self.view addSubview:_fakeNavBarView];
    
    [self setupSearchViews];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setFrame:CGRectMake(0, 8.0f, 36.0f, 36.0f)];
    [btnClose addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_ACTIVE_COLOR] forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor colorWithRGBA:BTN_TITLE_INACTIVE_COLOR] forState:UIControlStateDisabled];
    [btnClose setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    btnClose.translatesAutoresizingMaskIntoConstraints = NO;
    [_fakeNavBarView addSubview:btnClose];
    
    [NSLayoutConstraint setWidht:28 height:28 forView:btnClose];
    [NSLayoutConstraint setTopPadding:30 forView:btnClose inContainer:_fakeNavBarView];
    [NSLayoutConstraint setLeftPadding:10 forView:btnClose inContainer:_fakeNavBarView];
}

#pragma mark -
#pragma mark Search Views
- (void) setupSearchViews {
    UIView *searchContainer = [UIView new];
    searchContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [_fakeNavBarView addSubview:searchContainer];
    
    [NSLayoutConstraint setHeight:68 forView:searchContainer];
    [NSLayoutConstraint setTopPadding:30 forView:searchContainer inContainer:_fakeNavBarView];
    [NSLayoutConstraint setRightPadding:14 forView:searchContainer inContainer:_fakeNavBarView];
    [NSLayoutConstraint setLeftPadding:48 forView:searchContainer inContainer:_fakeNavBarView];
    
    // children
    _searchPlacesField = [[UITextField alloc] initWithFrame:CGRectZero];
    _searchPlacesField.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchPlacesField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _searchPlacesField.delegate = self;
    _searchPlacesField.placeholder = NSLocalizedString(@"TXT_PLACE_NAME", nil);
    [_searchPlacesField setBorderStyle:UITextBorderStyleRoundedRect];
    _searchPlacesField.backgroundColor = [UIColor whiteColor];
    _searchPlacesField.textAlignment = NSTextAlignmentLeft;
    _searchPlacesField.font = [UIFont systemFontOfSize:12.0f];
    
    UIImageView *iconSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_field_search.png"]];
    iconSearch.frame = CGRectMake(0, 0, 19.0f, 12.5f);
    _searchPlacesField.leftViewMode = UITextFieldViewModeAlways;
    _searchPlacesField.leftView = iconSearch;
    _searchPlacesField.textAlignment = NSTextAlignmentLeft;
    
    [searchContainer addSubview:_searchPlacesField];
    
    _searchAddressField = [[UITextField alloc] initWithFrame:CGRectZero];
    _searchAddressField.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchAddressField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _searchAddressField.delegate = self;
    _searchAddressField.placeholder = NSLocalizedString(@"TXT_CITY", nil);
    [_searchAddressField setBorderStyle:UITextBorderStyleRoundedRect];
    _searchAddressField.backgroundColor = [UIColor whiteColor];
    _searchAddressField.textAlignment = NSTextAlignmentLeft;
    _searchAddressField.font = [UIFont systemFontOfSize:12.0f];
    
    UIImageView *iconLocation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_field_location.png"]];
    iconLocation.frame = CGRectMake(0, 0, 19.0f, 12.5f);
    _searchAddressField.leftViewMode = UITextFieldViewModeAlways;
    _searchAddressField.leftView = iconLocation;
    _searchAddressField.textAlignment = NSTextAlignmentLeft;
    
    [searchContainer addSubview:_searchAddressField];
    
    [NSLayoutConstraint setHeight:30 forView:_searchPlacesField];
    [NSLayoutConstraint stretchHorizontal:_searchPlacesField inContainer:searchContainer withPadding:0];
    
    [NSLayoutConstraint setHeight:30 forView:_searchAddressField];
    [NSLayoutConstraint stretchHorizontal:_searchAddressField inContainer:searchContainer withPadding:0];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_searchPlacesField, _searchAddressField);
    
    NSString* vc_str = @"V:|[_searchPlacesField]-8-[_searchAddressField]";
    NSArray* vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vc_str options:0 metrics:nil views:views];
    [searchContainer addConstraints:vConstraints];
}

#pragma mark -
#pragma mark UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(itemsForDisplay == kDisplayPlaces)
        return places.count;
    else if(itemsForDisplay == kDisplayAddresses)
        return addresses.count;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(itemsForDisplay == kDisplayPlaces)
        return 100.0f;
    else
        return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100.0f)];
    view.clipsToBounds = YES;
    
    UILabel *label = [UILabel new];
    label.text = NSLocalizedString(@"TXT_PLACE_NOT_FOUND", nil);
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:11.0f];
    [view addSubview:label];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:20 forView:label];
    [NSLayoutConstraint stretchHorizontal:label inContainer:view withPadding:10];
    [NSLayoutConstraint setTopPadding:12 forView:label inContainer:view];
    
    //button
    CustomButton *btnChooseAddress = [CustomButton buttonWithType:UIButtonTypeCustom];
    [btnChooseAddress addTarget:self action:@selector(btnChooseAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [btnChooseAddress setTitle:NSLocalizedString(@"BTN_CHOOSE_ADDRESS", nil) forState:UIControlStateNormal];
    btnChooseAddress.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [btnChooseAddress setTitleColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateNormal];
    [btnChooseAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnChooseAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btnChooseAddress setBackgrounColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnChooseAddress setBackgrounColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateSelected];
    [btnChooseAddress setBackgrounColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateHighlighted];
    
    [btnChooseAddress setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateNormal];
    [btnChooseAddress setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateSelected];
    [btnChooseAddress setBorderColor:[UIColor colorWithRGBA:BTN_INVITE_COLOR] forState:UIControlStateHighlighted];
    
    btnChooseAddress.layer.borderWidth = 0.5;
    btnChooseAddress.layer.cornerRadius = 6.0;
    [view addSubview:btnChooseAddress];
    
    btnChooseAddress.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:110 height:36 forView:btnChooseAddress];
    [NSLayoutConstraint centerHorizontal:btnChooseAddress withView:view inContainer:view];
    [NSLayoutConstraint setTopDistance:8 fromView:btnChooseAddress toView:label inContainer:view];
    
    return view;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSimpleTableIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSimpleTableIdentifier];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [cell setPreservesSuperviewLayoutMargins:NO];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 14)];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
    
    if(itemsForDisplay == kDisplayPlaces){
        FoursquareResponse *placemark = places[indexPath.row];
        cell.textLabel.text = placemark.name;
        
        if(placemark.address)
            cell.detailTextLabel.text = placemark.address;
    }
    else if(itemsForDisplay == kDisplayAddresses){
        YandexGeoResponse *placemark = addresses[indexPath.row];
        cell.textLabel.text = placemark.name;
        
        if(placemark.descr)
            cell.detailTextLabel.text = placemark.descr;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(itemsForDisplay == kDisplayPlaces){
        FoursquareResponse *placemark = places[indexPath.row];
        [self.delegate gamePlaceDidChanged:self place:placemark];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(itemsForDisplay == kDisplayAddresses){
        YandexGeoResponse *placemark = addresses[indexPath.row];
        _searchAddressField.text = placemark.name;
        
        [_searchPlacesField becomeFirstResponder];
        itemsForDisplay = kDisplayPlaces;
        
        [searchTimer invalidate];
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(startSearchFoursquare:) userInfo:_searchPlacesField.text repeats:NO];
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Search
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _searchPlacesField){
        itemsForDisplay = kDisplayPlaces;
    }
    else if(textField == _searchAddressField){
        itemsForDisplay = kDisplayAddresses;
    }
    [_tableView reloadData];
    
    return YES;
}

- (void) textFieldDidChange:(UITextField *)textField {
    if (textField == _searchPlacesField){
        if(![textField.text isEmpty]){
            [searchTimer invalidate];
            searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startSearchFoursquare:) userInfo:_searchPlacesField.text repeats:NO];
        }
        else{
            places = [NSArray new];
            [_tableView reloadData];
        }
    }
    else if(textField == _searchAddressField){
        if(![textField.text isEmpty]){
            [searchTimer invalidate];
            searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startSearchYandex:) userInfo:_searchAddressField.text repeats:NO];
        }
        else{
            addresses = [NSArray new];
            [_tableView reloadData];
        }
    }
}

- (void) startSearchFoursquare:(NSTimer *)timer {
    NSString *searchText = timer.userInfo;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = kHUDProgressOffset;
    [hud show:YES];
    
    [AppNetworking findFoursquarePlacesInRegion:_searchAddressField.text search:searchText completionHandler:^(NSMutableArray *resp, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(!resp){
                places = [NSArray new];
            }
            else{
                places = resp;
            }
            
            [_tableView reloadData];
        });
    }];
}

- (void) startSearchYandex:(NSTimer *)timer {
    NSString *searchText = timer.userInfo;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = kHUDProgressOffset;
    [hud show:YES];
    
    [AppNetworking findYandexAddress:searchText completionHandler:^(NSMutableArray *items, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(!items){
                addresses = [NSArray new];
            }
            else{
                addresses = items;
            }
            
            [_tableView reloadData];
        });
    }];
}

#pragma mark -
#pragma mark AddressSearchViewControllerDelegate
- (void)addressDidChanged:(AddressSearchViewController *)controller place:(YandexGeoResponse *)address {
    wasDisplayedAfterAddressDelegate = YES;
    
    if(address){
        if([self.delegate respondsToSelector:@selector(gamePlaceDidChanged:place:)]){
            FoursquareResponse *place = [FoursquareResponse new];
            place.name = address.name;
            
            place.country = address.country;
            place.city = address.city;
            place.address = address.address;
            
            place.lat = address.lat;
            place.lng = address.lng;
            
            [self.delegate gamePlaceDidChanged:self place:place];
        }
    }
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    if(wasDisplayedAfterAddressDelegate){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    if(!locationFound)
        [self startFindingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
- (void) btnBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnChooseAddressClick {
    AddressSearchViewController *controller = [[AddressSearchViewController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Locations
- (void) startFindingLocation {
    [self setLocationManager];
    [_locationManager startUpdatingLocation];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"TXT_LOCATING", nil);
}

- (void) setLocationManager {
    if([CLLocationManager locationServicesEnabled]){
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if(status == kCLAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MSG_GEO_ACCESS_DEIED", nil)
                                                            message:NSLocalizedString(@"MSG_GEO_ALLOW_ACCESS", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                                                  otherButtonTitles:NSLocalizedString(@"BTN_SETTINGS", nil), nil];
            alert.tag = kAlertGeoDeny;
            [alert show];
        }
        else {
            if(_locationManager == nil){
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.delegate = self;
                _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                _locationManager.pausesLocationUpdatesAutomatically = YES;
                _locationManager.activityType = CLActivityTypeOther;
                
                if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
                    [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"MSG_GEOLOCATION_IS_DISABLED", nil)
                              message:NSLocalizedString(@"MSG_GEOLOCATION_ENABLE", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                              otherButtonTitles:NSLocalizedString(@"BTN_SETTINGS", nil), nil];
        alert.tag = kAlertGeoDeny;
        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = nil;
    if(locations != nil){
        loc = locations[locations.count-1];
        _currentLocation = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude);
        [_locationManager stopUpdatingLocation];
        locationFound = YES;
        
        [AppNetworking findYandexAddressForLatitude:_currentLocation.latitude longitude:_currentLocation.longitude completionHandler:^(YandexGeoResponse *resp, NSString *errorMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
                    yandexGeoResponse = resp;
                    _searchAddressField.text = yandexGeoResponse.name;
                }
            });
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *errorString;
    switch([error code]) {
        case kCLErrorDenied:
            errorString = NSLocalizedString(@"MSG_GEO_ACCESS_DEIED", nil);
            break;
        case kCLErrorLocationUnknown:
            errorString = NSLocalizedString(@"MSG_LOCATION_IS_UNKNOWN", nil);
            break;
        default:
            errorString = NSLocalizedString(@"MSG_LOCATION_IS_UNKNOWN", nil);
            break;
    }
    
    UIAlertView *alert = nil;
    if(kCLErrorDenied == [error code]){
        alert = [[UIAlertView alloc]
                 initWithTitle:NSLocalizedString(@"TXT_LOCATION", nil)
                 message:errorString
                 delegate:self
                 cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                 otherButtonTitles:NSLocalizedString(@"BTN_SETTINGS", nil), nil];
        alert.tag = kAlertGeoDeny;
    }
    else{
        alert = [[UIAlertView alloc]
                 initWithTitle:NSLocalizedString(@"TXT_LOCATION", nil)
                 message:errorString
                 delegate:nil
                 cancelButtonTitle:NSLocalizedString(@"BTN_OK", nil)
                 otherButtonTitles:nil];
    }
    
    [alert show];
}

#pragma mark -
#pragma mark Alerts handler
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == kAlertGeoDeny){
        if(buttonIndex == 1){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
        }
    }
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = _tableView.frame;
    frame.size.height = self.view.frame.size.height - kbSize.height - kNavbarHeight;
    _tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    CGRect fullRect = CGRectMake(0, kNavbarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kNavbarHeight);
    _tableView.frame = fullRect;
}

@end
