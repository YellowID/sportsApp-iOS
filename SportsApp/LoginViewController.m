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
#import "AppNetworking.h"
#import "AppDelegate.h"
#import "AppColors.h"
#import "UIColor+Helper.h"
#import "MBProgressHUD.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <VKSdk/VKSdk.h>
#import <Quickblox/Quickblox.h>

#define VK_APP_ID 4932732

static NSArray* SCOPE = nil;

@interface LoginViewController () <VKSdkDelegate>

@end

@implementation LoginViewController{
    UIImageView* ivLogo;
    UILabel* lbAppName;
    UIButton* btnVK;
    UIButton* btnFB;
    
    BOOL loginButtonWasPressed;
    BOOL userWasLogged;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    SCOPE = @[VK_PER_EMAIL];
    
    ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    ivLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:ivLogo];
    
    lbAppName = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 30)];
    lbAppName.translatesAutoresizingMaskIntoConstraints = NO;
    lbAppName.textAlignment = NSTextAlignmentCenter;
    [lbAppName setText: @"Start Sport"];
    //[lbAppName setTextColor:[UIColor whiteColor]];
    [lbAppName setTextColor:[UIColor colorWithRGBA:APP_NAME_TEXT_COLOR]];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    if(loginButtonWasPressed || userWasLogged)
        return;
    
    NSString *lastProvider = [[AppDelegate instance] lastProvider];
    if([lastProvider isEqualToString:@"vk"]){
        [self loginWithVkontakte];
    }
    else if([lastProvider isEqualToString:@"facebook"]){
        [self loginWithFacebook];
    }
}

#pragma mark -
#pragma mark create VK button
- (UIButton*) createButtonVK {
    btnVK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnVK addTarget:self action:@selector(btnVKClick) forControlEvents:UIControlEventTouchUpInside];
    [btnVK setTitle:@"Войти через Вконтакте" forState:UIControlStateNormal];
    btnVK.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    [btnVK setBackgroundImage:[UIImage imageNamed:@"bg_btn_vk.png"] forState:UIControlStateNormal];
    [btnVK setTintColor:[UIColor colorWithRGBA:APP_NAME_TEXT_COLOR]];
    btnVK.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return btnVK;
}

- (UIButton*) createButtonFB {
    btnFB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnFB addTarget:self action:@selector(btnFBClick) forControlEvents:UIControlEventTouchUpInside];
    [btnFB setTitle:@"Войти через Facebook" forState:UIControlStateNormal];
    btnFB.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    [btnFB setBackgroundImage:[UIImage imageNamed:@"bg_btn_fb.png"] forState:UIControlStateNormal];
    [btnFB setTintColor:[UIColor colorWithRGBA:APP_NAME_TEXT_COLOR]];
    btnFB.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    return btnFB;
}

#pragma mark -
#pragma mark Buttons handler
- (void) btnTempClick {
    //[self goToNextScreen];
}

- (void) btnFBClick {
    loginButtonWasPressed = YES;
    [self loginWithFacebook];
}

- (void) btnVKClick {
    loginButtonWasPressed = YES;
    [self loginWithVkontakte];
}

- (void) goToNextScreen {
    userWasLogged = YES;
    GamesListViewController *controller = [[GamesListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark LOGIN
- (void) loginWithFacebook {
    if(![AppNetworking isInternetAvaliable]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Нет подключения к интернету"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Ок"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Авторизация...";
    //hud.color = [UIColor greenColor];
    
    FBSDKAccessToken* fbToken = [FBSDKAccessToken currentAccessToken];
    if (fbToken) {
        [self appLoginWithProvider:@"facebook" oauthToken:fbToken.tokenString oauthId:fbToken.userID email:nil name:nil avatar:nil];
    }
    else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email", @"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                NSLog(@"FB Error: %@", error.debugDescription);
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:nil
                                          message:error.description
                                          delegate:nil
                                          cancelButtonTitle:@"Ок"
                                          otherButtonTitles: nil];
                    [alert show];
                });
            }
            else if (result.isCancelled) {
                NSLog(@"FB Cancelled");
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else {
                if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]) {
                    NSLog(@"FB email Permissions granted!");
                    
                    FBSDKGraphRequest *fbGraphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture, email, name"}];
                    [fbGraphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             FBSDKAccessToken *fbToken = [FBSDKAccessToken currentAccessToken];
                             
                             NSString *avatarUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", fbToken.userID];
                             
                             [self appLoginWithProvider:@"facebook" oauthToken:fbToken.tokenString oauthId:fbToken.userID email:result[@"email"] name:result[@"name"] avatar:avatarUrl];
                         }
                     }];
                }
                else{
                    NSLog(@"FB email Permissions deny!");
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }
        }];
    }
}

- (void) loginWithVkontakte {
    if(![AppNetworking isInternetAvaliable]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Нет подключения к интернету"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"Отмена"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Авторизация...";
    
    [VKSdk initializeWithDelegate:self andAppId:[NSString stringWithFormat:@"%lu", (unsigned long)VK_APP_ID]];
    if ([VKSdk wakeUpSession]){
        NSLog(@"VK: %@", [VKSdk getAccessToken].accessToken);
        NSLog(@"userId: %@", [VKSdk getAccessToken].userId);
        NSString *oauthId = [VKSdk getAccessToken].userId;
        [self appLoginWithProvider:@"vk" oauthToken:[VKSdk getAccessToken].accessToken oauthId:oauthId email:nil name:nil avatar:nil];
    }
    else{
        [VKSdk authorize:SCOPE revokeAccess:YES];
    }
}

#pragma mark -
#pragma mark VK delegate
- (void) vkSdkReceivedNewToken:(VKAccessToken*) newToken {
    NSLog(@"VK: %@", newToken.accessToken);
    
    NSString *userId = [VKSdk getAccessToken].userId;
    NSString *email = [VKSdk getAccessToken].email;
    
    VKRequest *vkRequest = [[VKApi users] get:@{VK_API_FIELDS:@"photo_200", VK_API_USER_IDS:userId}];
    
    [vkRequest executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Json result: %@", response.json);
        
        NSString *oauthId = nil;
        NSString *name = nil;
        NSString *avatar = nil;
        if([response.json isKindOfClass:[NSArray class]]){
            oauthId = [NSString stringWithFormat:@"%lu", (unsigned long)[[[response.json firstObject] objectForKey:@"id"] integerValue]];
            
            NSString *firstName = [[response.json firstObject] objectForKey:@"first_name"];
            NSString *lastName = [[response.json firstObject] objectForKey:@"last_name"];
            name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            avatar = [[response.json firstObject] objectForKey:@"photo_200"];
        }
        else if([response.json isKindOfClass:[NSDictionary class]]){
            oauthId = [NSString stringWithFormat:@"%lu", (unsigned long)[[response.json objectForKey:@"id"] integerValue]];
            
            NSString *firstName = [response.json objectForKey:@"first_name"];
            NSString *lastName = [response.json objectForKey:@"last_name"];
            name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            avatar = [response.json objectForKey:@"photo_200"];
        }
        else{
            name = @"BagUser";
        }
        
        [self appLoginWithProvider:@"vk" oauthToken:newToken.accessToken oauthId:oauthId email:email name:name avatar:avatar];
        
        }
        errorBlock:^(NSError *error) {
           if (error.code != VK_API_ERROR) {
               [error.vkError.request repeat];
           } else {
               NSLog(@"VK error: %@", error);
               
               [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
               [MBProgressHUD hideHUDForView:self.view animated:YES];
           } 
    }];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) vkSdkUserDeniedAccess:(VKError*) authorizationError {
    NSLog(@"VK Error: %@", authorizationError.debugDescription);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    NSLog(@"VK expiredToken: %@",  expiredToken.accessToken);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    NSLog(@"VK captchaError: %@",  captchaError.debugDescription);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark -
#pragma mark LOGIN
- (void) appLoginWithProvider:(NSString *)provider oauthToken:(NSString *)oauthToken oauthId:(NSString *)userId email:(NSString *)email name:(NSString *)name avatar:(NSString *)avatar {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:provider forKey:@"provider"];
    [params setValue:oauthToken forKey:@"oauth_token"];
    
    if(email)
        [params setValue:email forKey:@"email"];
    
    if(name)
        [params setValue:name forKey:@"name"];
    
    if(avatar)
        [params setValue:avatar forKey:@"avatar"];
    
    if(userId)
        [params setValue:userId forKey:@"provider_id"];
    
    AppNetworking *appNetworking = [[AppDelegate instance] appNetworkingInstance];
    [appNetworking loginUser:params completionHandler:^(AppUser *user, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if(user){
                [[AppDelegate instance] setUser:user];
                [[AppDelegate instance] setLastProvider:user.provider];
                [appNetworking setUserToken:user.appToken];
                
                AppChat *appChat = [[AppDelegate instance] appChatInstance];
                if(user.isNewUser){
                    [appChat signUpWithLogin:user.chatLogin password:user.chatPassword externalID:user.uid fullName:user.name avatarUrl:user.avatar completionHandler:^(BOOL isSuccess) {
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        if(isSuccess)
                            NSLog(@"appChat signUp - OK");
                        else
                            NSLog(@"appChat signUp - ERR");
                        
                        [self goToNextScreen];
                    }];
                }
                else{
                    [appChat loginWithName:user.chatLogin password:user.chatPassword completionHandler:^(BOOL isSuccess) {
                        if(!isSuccess){
                            NSLog(@"Probably user is not registered. Trying to sing up.");
                            
                            [appChat signUpWithLogin:user.chatLogin password:user.chatPassword externalID:user.uid fullName:user.name avatarUrl:user.avatar completionHandler:^(BOOL isSuccess) {
                                if(isSuccess){
                                    NSLog(@"appChat signUp - OK");
                                    
                                    [appChat loginWithName:user.chatLogin password:user.chatPassword completionHandler:^(BOOL isSuccess) {
                                        if(isSuccess){
                                            NSLog(@"appChat login - OK");
                                        }
                                        else{
                                            NSLog(@"appChat login - ERR");
                                        }
                                        
                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        
                                        [self goToNextScreen];
                                    }];
                                }
                                else{
                                    NSLog(@"appChat signUp - ERR");
                                    
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    
                                    [self goToNextScreen];
                                }
                            }];
                        }
                        else{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                            [self goToNextScreen];
                        }
                    }];
                }
            }
            else{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:errorMessage
                                      delegate:nil
                                      cancelButtonTitle:@"Ок"
                                      otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

@end
