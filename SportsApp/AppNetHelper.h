//
//  AppNetHelper.h
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import <Foundation/Foundation.h>
#import "NewGame.h"
#import "MemberInfo.h"
#import "MemberSettings.h"

@interface AppNetHelper : NSObject

+ (BOOL) isInternetAvaliable; 

+ (void) findUser:(NSString *)username completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler;
+ (void) inviteUserWithId:(NSUInteger)userId forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler;
+ (void) inviteUserWithEmail:(NSString *)email forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler;

+ (void) settingsForUser:(NSUInteger)userId completionHandler:(void(^)(MemberSettings *settings, NSString *errorMessage))blockHandler;
+ (void) saveSettings:(MemberSettings *)settings forUser:(NSUInteger)userId completionHandler:(void(^)(NSString *errorMessage))blockHandler;

+ (void) membersForGame:(NSUInteger)gameId completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler;
+ (void) gamesForUser:(NSUInteger)userId completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler;
+ (void) createNewGame:(NewGame *)game completionHandler:(void(^)(NSUInteger gameId, NSString *errorMessage))blockHandler;

@end
