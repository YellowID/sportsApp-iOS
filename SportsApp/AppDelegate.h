//
//  AppDelegate.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic) NSUInteger currentUserId;

+ (AppDelegate*) instance;

@end

