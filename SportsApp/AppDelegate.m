//
//  AppDelegate.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIColor+Helper.h"
#import "AppColors.h"

#import "ChatViewController.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <VKSdk/VKSdk.h>
#import <Quickblox/Quickblox.h>

#define ALERT_APNS 1

@interface AppDelegate ()

@end

@implementation AppDelegate {
    AppNetworking *appNetworking;
    AppChat *appChat;
    
    NSUInteger notificationObjectId;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (launchOptions) { //launchOptions is not nil
        NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        NSDictionary *appdata = [userInfo objectForKey:@"appdata"];
        if (appdata) { //apsInfo is not nil
            NSString *notificationAction = [appdata objectForKey:@"event"];
            if([notificationAction isEqualToString:@"invite"]){
                NSString *objectId = [appdata objectForKey:@"objectId"];
                [self setLastNotificationObjectId:objectId];
            }
            
            //[self handlePushNotification:userInfo];
            application.applicationIconBadgeNumber = 0;
        }
    }
    
    LoginViewController *controller = [LoginViewController new];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-0.5,self.navigationController.navigationBar.frame.size.width, 0.1)];
    [navBorder setBackgroundColor:[UIColor colorWithRGBA:ROW_SEPARATOR_COLOR]];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    self.window.rootViewController = self.navigationController;
    
    [self setNavigationBarAppearanceDefault];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //[Fabric with:@[CrashlyticsKit]];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [QBApplication sharedApplication].applicationId = 23789;
    [QBConnection registerServiceKey:@"JL8zy5TG4avnDE9"];
    [QBConnection registerServiceSecret:@"jFhh6pUh-SzBkKu"];
    [QBSettings setAccountKey:@"aawJFzj4EfZLsw9tGY6N"];
    
    #if !TARGET_IPHONE_SIMULATOR
    [self registerForRemoteNotification];
    #endif

    return YES;
}

- (void) setNavigationBarAppearanceDefault {
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRGBA:BAR_TEXT_COLOR]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil]];
}

- (void) setNavigationBarAppearanceSearch {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRGBA:BG_SEARCH_NAVBAR_COLOR]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [AppChat logout];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [AppChat logout];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if(_user && !_user.isNewUser){
        AppChat *chat = [self appChatInstance];
        [chat loginWithName:_user.chatLogin password:_user.chatPassword completionHandler:^(BOOL isSuccess) {
            if(!isSuccess)
                NSLog(@"Something wrong when login");
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

#pragma mark -
#pragma mark - openURL
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL callBack = NO;
    if ([[url scheme] isEqualToString:@"fb900291803360698"]){
        callBack = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    }
    else if ([[url scheme] isEqualToString:@"vk4932732"]){
        callBack = [VKSdk processOpenURL:url fromApplication:sourceApplication];
    }
    return callBack;
}

#pragma mark -
#pragma mark - Other
+ (AppDelegate*) instance {
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (AppNetworking *) appNetworkingInstance {
    if(!appNetworking)
        appNetworking = [AppNetworking sharedInstance];
    
    return appNetworking;
}

- (AppChat *) appChatInstance {
    if(!appChat)
        appChat = [AppChat sharedInstance];
    
    return appChat;
}

#pragma mark -
- (void) setLastProvider:(NSString *)provider {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:provider forKey:@"last_provider"];
    [userDefaults synchronize];
}

- (NSString *) lastProvider {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"last_provider"];
}

#pragma mark -
- (void) setLastNotificationObjectId:(NSString *)objId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:objId forKey:@"lastNotificationObjectId"];
    [userDefaults synchronize];
}

- (NSString *) lastNotificationObjectId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastNotificationObjectId"];
}

#pragma mark -
#pragma mark Remote notifications
- (void)registerForRemoteNotification {
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did register for remote notifications: %@", deviceToken);
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"devicePushToken"];
    [userDefaults synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    
    if (application.applicationState == UIApplicationStateActive) {
        NSDictionary *appdata = [userInfo objectForKey:@"appdata"];
        NSString *notificationAction = [appdata objectForKey:@"event"];
        notificationObjectId = [[appdata objectForKey:@"objectId"] integerValue];
        
        if([notificationAction isEqualToString:@"invite"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                                message:NSLocalizedString(@"MSG_INVITE_NOTIFICATION", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"BTN_CANCEL_1", nil)
                                                      otherButtonTitles:NSLocalizedString(@"BTN_VIEW", nil), nil];
            alertView.tag = ALERT_APNS;
            [alertView show];
        }
    }
    else if(application.applicationState == UIApplicationStateInactive){
        //NSLog(@"UIApplicationStateInactive: APNS (%@)", message);
    }
    else if(application.applicationState == UIApplicationStateBackground){
        //NSLog(@"UIApplicationStateBackground: APNS (%@)", message);
    }
}

#pragma mark -
#pragma mark Notifications Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERT_APNS) {
        if(buttonIndex == 0){ // cancel
            
        }
        else if(buttonIndex == 1){ // open
            ChatViewController *controller = [[ChatViewController alloc] init];
            controller.gameId = notificationObjectId;
            controller.delegate = nil;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
