//
//  AppDelegate.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <UIKit/UIKit.h>
#import "AppChat.h"
#import "AppNetworking.h"
#import "AppUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic) NSUInteger currentUserId;

@property (strong, nonatomic) AppUser *user;

+ (AppDelegate *) instance;
- (AppNetworking *) appNetworkingInstance;
- (AppChat *) appChatInstance;

- (void) setNavigationBarAppearanceDefault;
- (void) setNavigationBarAppearanceSearch;

- (void) setLastProvider:(NSString *)provider;
- (NSString *) lastProvider;

@end

