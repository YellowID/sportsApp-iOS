//
//  MemberViewController.m
//  SportsApp
//
//  Created by sergeyZ on 21.05.15.
//
//

#import "MemberViewController.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#define PHOTO_SIZE 40

@interface MemberViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *members;

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Участники";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnClose setFrame:CGRectMake(0, 0.0f, 40.0f, 36.0f)];
    [btnClose setTitle:@"Закрыть" forState:UIControlStateNormal];
    [btnClose sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor colorWithRGBA:BG_GRAY_COLOR]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRGBA:VIEW_SEPARATOR_COLOR];
    [self.view addSubview:self.tableView];
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
        //[cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 14)];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return _members.count;
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIImage* im = [UIImage imageNamed:@"photo.png"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PHOTO_SIZE, PHOTO_SIZE), YES, 0);
    [im drawInRect:CGRectMake(0, 0, PHOTO_SIZE, PHOTO_SIZE)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = im2;
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    cell.imageView.layer.borderWidth = 0.0;
    cell.imageView.layer.cornerRadius = PHOTO_SIZE / 2;
    cell.imageView.layer.masksToBounds = YES;
    
    cell.textLabel.text = @"Павел Бурленко";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
