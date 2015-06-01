//
//  PlaceSearchViewController.m
//  SportsApp
//
//  Created by sergeyZ on 29.05.15.
//
//

#import "PlaceSearchViewController.h"
#import "UIViewController+Navigation.h"
#import "CustomSearchBar.h"
#import "NSString+Common.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//@import MapKit;

@interface PlaceSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation PlaceSearchViewController {
    NSArray *places;
    CLGeocoder *geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"Место";
    [self setNavTitle:@"Место"];
    self.view.backgroundColor = [UIColor colorWithRGBA:BG_GRAY_COLOR];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _searchBar.delegate = self;
    [_searchBar setPlaceholder:@"Место геопозиции "];
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark UITableView delegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return places.count;
    //return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    
    
    CLPlacemark *placemark = places[indexPath.row];
    CLLocation *location = placemark.location;
    
    cell.textLabel.text = placemark.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.thoroughfare, placemark.subThoroughfare];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString* selectedCity = members[indexPath.row];
    
    //[_tableView reloadData];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    
    /*
    CLLocationCoordinate2D theCenter = CLLocationCoordinate2DMake(53.657661, 28.125000);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:theCenter
                                                                 radius:800000
                                                             identifier:@"bel"];
    request.region = region;
    */
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        NSMutableArray *placemarks = [NSMutableArray array];
        
        for (MKMapItem *item in response.mapItems) {
            [placemarks addObject:item.placemark];
        }
        
        places = placemarks;
        [_tableView reloadData];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

# pragma mark -
# pragma mark Keyboard show/hide
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat bottom = _searchBar.frame.origin.y + 44;
    CGRect frame = _tableView.frame;
    frame.size.height = self.view.frame.size.height - kbSize.height - bottom;
    _tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
