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
#import "NSLayoutConstraint+Helper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <VKSdk/VKSdk.h>

#define VK_APP_ID 4932732

static NSArray* SCOPE = nil;

@interface LoginViewController () <VKSdkDelegate>

@end

@implementation LoginViewController{
    UIImageView* ivLogo;
    UILabel* lbAppName;
    UIButton* btnVK;
    UIButton* btnFB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    SCOPE = @[VK_PER_EMAIL];
    
    ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    ivLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:ivLogo];
    
    lbAppName = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 30)];
    lbAppName.translatesAutoresizingMaskIntoConstraints = NO;
    lbAppName.textAlignment = NSTextAlignmentCenter;
    [lbAppName setText: @"Sports app"];
    [lbAppName setTextColor:[UIColor whiteColor]];
    [lbAppName setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 24.0f]];
    [lbAppName sizeToFit];
    [self.view addSubview:lbAppName];
    
    
    btnFB = [self createButtonFB];
    [self.view addSubview:btnFB];
    btnFB.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:229.0f height:40.0f forView:btnFB];
    [NSLayoutConstraint centerHorizontal:btnFB withView:self.view inContainer:self.view];
    
    btnVK = [self createButtonVK];
    [self.view addSubview:btnVK];
    btnVK.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:229.0f height:40.0f forView:btnVK];
    [NSLayoutConstraint centerHorizontal:btnVK withView:self.view inContainer:self.view];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(ivLogo, lbAppName, btnVK, btnFB);
    NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-108-[ivLogo]-30-[lbAppName]-(>=20)-[btnVK]-25-[btnFB]-45-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self.view addConstraints:verticalConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:ivLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lbAppName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTempClick)];
    [ivLogo addGestureRecognizer:tapGesture];
    ivLogo.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

#pragma mark -
#pragma mark create VK button
- (UIButton*) createButtonVK {
    btnVK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnVK addTarget:self action:@selector(loginWithVkontakte) forControlEvents:UIControlEventTouchUpInside];
    [btnVK setTitle:@"Войти через Вконтакте" forState:UIControlStateNormal];
    btnVK.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    [btnVK setBackgroundImage:[UIImage imageNamed:@"bg_btn_vk.png"] forState:UIControlStateNormal];
    [btnVK setTintColor:[UIColor whiteColor]];
    btnVK.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return btnVK;
}

- (UIButton*) createButtonFB {
    btnFB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnFB addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [btnFB setTitle:@"Войти через Facebook" forState:UIControlStateNormal];
    btnFB.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    [btnFB setBackgroundImage:[UIImage imageNamed:@"bg_btn_fb.png"] forState:UIControlStateNormal];
    [btnFB setTintColor:[UIColor whiteColor]];
    btnFB.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return btnFB;
}

#pragma mark -
#pragma mark Buttons handler
- (void) btnTempClick {
    [self goToNextScreen];
}

- (void) goToNextScreen {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    GamesListViewController *controller = [[GamesListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark LOGIN
- (void) loginWithFacebook {
    FBSDKAccessToken* fbToken = [FBSDKAccessToken currentAccessToken];
    if (fbToken) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"FB: %@",  fbToken.tokenString);
        [self goToNextScreen];
    }
    else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                NSLog(@"FB Error: %@", error.debugDescription);
            }
            else if (result.isCancelled) {
                NSLog(@"FB Cancelled");
            }
            else {
                if ([result.grantedPermissions containsObject:@"email"]) {
                    NSLog(@"FB email Permissions granted!");
                }
                else{
                    NSLog(@"FB email Permissions deny!");
                }
            }
        }];
    }
}

- (void) loginWithVkontakte {
    [VKSdk initializeWithDelegate:self andAppId:[NSString stringWithFormat:@"%lu", (unsigned long)VK_APP_ID]];
    if ([VKSdk wakeUpSession]){
        NSLog(@"VK: %@", [VKSdk getAccessToken].accessToken);
        [self goToNextScreen];
    }
    else{
        [VKSdk authorize:SCOPE revokeAccess:YES];
    }
}

#pragma mark -
#pragma mark VK delegate
- (void) vkSdkReceivedNewToken:(VKAccessToken*) newToken {
    NSLog(@"VK: %@", newToken.accessToken);
    [self goToNextScreen];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) vkSdkUserDeniedAccess:(VKError*) authorizationError {
    NSLog(@"VK Error: %@", authorizationError.debugDescription);
}

- (void) vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    NSLog(@"VK expiredToken: %@",  expiredToken.accessToken);
}

- (void) vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    NSLog(@"VK captchaError: %@",  captchaError.debugDescription);
}


@end
