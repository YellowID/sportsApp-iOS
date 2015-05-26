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

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <VKSdk/VKSdk.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginViewController *controller = [LoginViewController new];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.navigationController.navigationBar.translucent = NO;
    
    self.window.rootViewController = self.navigationController;
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRGBA:BAR_TEXT_COLOR]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //[Fabric with:@[CrashlyticsKit]];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

#pragma mark -
#pragma mark - FB openURL
/*
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
*/
#pragma mark -
#pragma mark - VK openURL
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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
