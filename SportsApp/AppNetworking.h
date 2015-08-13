//
//  AppNetHelper.h
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NewGame.h"
#import "MemberInfo.h"
#import "MemberSettings.h"
#import "GameInfo.h"
#import "YandexGeoResponse.h"
#import "FoursquareResponse.h"
#import "AppUser.h"

@interface AppNetworking : NSObject

+ (instancetype)sharedInstance;
+ (BOOL) isInternetAvaliable;

- (void) setUserToken:(NSString *)token;
- (void) loginUser:(NSDictionary *)params completionHandler:(void(^)(AppUser *user, NSString *errorMessage))blockHandler;

- (void) createNewGame:(NewGame *)game completionHandler:(void(^)(NSUInteger gameId, NSString *errorMessage))blockHandler;
- (void) editGame:(NewGame *)game withId:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler;
- (void) gameById:(NSUInteger)gameId completionHandler:(void(^)(GameInfo *gameInfo, NSString *errorMessage))blockHandler;
- (void) membersForGame:(NSUInteger)gameId completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler;
- (void) gamesInCity:(NSString *)city completionHandler:(void(^)(NSMutableArray *myGames, NSMutableArray *publicGames, NSString *errorMessage))blockHandler;

- (void) findUser:(NSString *)username completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler;
- (void) inviteUserWithId:(NSUInteger)userId forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler;
- (void) inviteUserWithEmail:(NSString *)email completionHandler:(void(^)(NSString *errorMessage))blockHandler;

- (void) setUserStatusForGame:(NSUInteger)gameId status:(NSUInteger)status completionHandler:(void(^)(NSString *errorMessage))blockHandler;

- (void) settingsForCurrentUserCompletionHandler:(void(^)(MemberSettings *settings, NSString *errorMessage))blockHandler;
- (void) saveSettingsForCurrentUser:(MemberSettings *)settings completionHandler:(void(^)(NSString *errorMessage))blockHandler;

- (void) citiesCompletionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler;

+ (void) findYandexAddressForLatitude:(CGFloat)lat longitude:(CGFloat)lng completionHandler:(void(^)(YandexGeoResponse *resp, NSString *errorMessage))blockHandler;
+ (void) findYandexAddress:(NSString *)query completionHandler:(void(^)(NSMutableArray *items, NSString *errorMessage))blockHandler;

+ (void) findFoursquarePlacesInRegion:(NSString *)regionName search:(NSString *)query completionHandler:(void(^)(NSMutableArray *resp, NSString *errorMessage))blockHandler;

+ (void) downloadImageWithUrl:(NSString *)imageUrl completionHandler:(void(^)(NSData *imageData))blockHandler;
@end
