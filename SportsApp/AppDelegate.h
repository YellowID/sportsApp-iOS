//
//  AppDelegate.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <UIKit/UIKit.h>
#import "AppUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic) NSUInteger currentUserId;

@property (strong, nonatomic) AppUser *user;

+ (AppDelegate*) instance;

@end

