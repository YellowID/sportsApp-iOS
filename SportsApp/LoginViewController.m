//
//  LoginViewController.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "LoginViewController.h"
#import "GamesListViewController.h"
#import "MemberViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UIImageView* ivLogo;
    UILabel* lbAppName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [button addTarget:self action:@selector(btnTempClick)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    ivLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:ivLogo];
    
    lbAppName = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 30)];
    lbAppName.translatesAutoresizingMaskIntoConstraints = NO;
    lbAppName.textAlignment = NSTextAlignmentCenter;
    [lbAppName setText: @"Sports app"];
    [lbAppName setTextColor:[UIColor whiteColor]];
    [lbAppName setFont:[UIFont fontWithName: @"Trebuchet MS" size: 24.0f]];
    [lbAppName sizeToFit];
    [self.view addSubview:lbAppName];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(ivLogo, lbAppName);
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[ivLogo]-20-[lbAppName]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self.view addConstraints:verticalConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ivLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lbAppName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTempClick)];
    [ivLogo addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void) btnTempClick {
    GamesListViewController *controller = [[GamesListViewController alloc] init];
    //MemberViewController *controller = [[MemberViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
