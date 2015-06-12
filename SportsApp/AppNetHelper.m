//
//  AppNetHelper.m
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import "AppNetHelper.h"
#import "ZSNetManager.h"
#import "GameInfo.h"

#define API_URL_CREATE_GAME @"http://sportsapp.com"
#define API_URL_GAMES_FOR_USER @"http://sportsapp.com"
#define API_URL_SETTINGS_FOR_USER @"http://sportsapp.com"

#define ERR_TOKEN 1
#define ERR_ACTION_NOT_FOUND 2
#define ERR_SERVER 3
#define ERR_PARAMS 4

@implementation AppNetHelper

// {error:0, data:{...} }
// {error:0, data:[...] }
// {error:3, data:null }

#pragma mark -
#pragma mark Players
+ (void) findUser:(NSString *)username completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler {
    // GET
    // IN: username
    // OUT: JSON data - [{userId, avatar, name}, {}, ...]
    
    NSMutableArray *members = [NSMutableArray new];
    for(int i = 0; i < 14; ++i){
        MemberInfo* member = [MemberInfo new];
        member.userId = 1;
        member.name = [NSString stringWithFormat:@"User Name %lu", (unsigned long)i];
        member.icon = @"http://pics.news.meta.ua/90x90/316/77/31677048-Chaku-Norrisu-ispolnilos-75-let.gif";
        member.invited = YES;
        
        [members addObject:member];
    }
    
    blockHandler(members, nil);
}

+ (void) inviteUserWithId:(NSUInteger)userId forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    // GET
    // IN: userId, gameId
    // OUT: JSON data - null
    
    blockHandler(nil);
}

+ (void) inviteUserWithEmail:(NSString *)email forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    // GET
    // IN: email, gameId
    // OUT: JSON data - null
    
    blockHandler(nil);
}

#pragma mark - 
#pragma mark Settings
+ (void) settingsForUser:(NSUInteger)userId completionHandler:(void(^)(MemberSettings *settings, NSString *errorMessage))blockHandler {
    // GET
    // IN: userId
    // OUT: JSON data - {age, level, football, squash, tennis, basketball, volleyball, hockey, handball}
    
    MemberSettings *settings = [MemberSettings new];
    settings.age = AGE_28_35;
    settings.level = LEVEL_3;
    
    settings.football = YES;
    settings.basketball = NO;
    settings.volleyball = YES;
    settings.handball = NO;
    settings.tennis = YES;
    settings.hockey = NO;
    settings.squash = YES;
    
    blockHandler(settings, nil);
}

+ (void) saveSettings:(MemberSettings *)settings forUser:(NSUInteger)userId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    // POST
    // IN: userId, age, level, football, squash, tennis, basketball, volleyball, hockey, handball
    // OUT: JSON data - null
    
    blockHandler(nil);
}

#pragma mark -
#pragma mark Game
+ (void) membersForGame:(NSUInteger)gameId completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler {
    // GET
    // IN: gameId
    // OUT: JSON data - [{userId, avatar, name}, {}, ...]
    
    NSMutableArray *members = [NSMutableArray new];
    for(int i = 0; i < 14; ++i){
        MemberInfo* member = [MemberInfo new];
        member.userId = 1;
        member.name = [NSString stringWithFormat:@"User Name %lu", (unsigned long)i];
        member.icon = @"http://pics.news.meta.ua/90x90/316/77/31677048-Chaku-Norrisu-ispolnilos-75-let.gif";
        member.invited = YES;
        
        [members addObject:member];
    }
    
    blockHandler(members, nil);
}

+ (void) gamesForUser:(NSUInteger)userId completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler {
    // GET
    // IN: userId
    // OUT: JSON data - [{gameName, address, addressName, date, time, (bool)admin, participateStatus}, {...}, ...]
    
    NSMutableArray *games = [NSMutableArray new];
    for(int i = 0; i < 10; ++i){
        GameInfo* game = [GameInfo new];
        game.address = @"просп. Независимости 192б";
        game.addressName = @"Всем спорт";
        game.date = @"через 3 дня";
        game.time = @"20:00";
        
        if(i < 5){
            game.adminId = userId;
            game.gameName = [NSString stringWithFormat:@"My Game %lu", (unsigned long)i];
            [games addObject:game];
        }
        else{
            game.adminId = 999;
            game.gameName = [NSString stringWithFormat:@"Public Game %lu", (unsigned long)i];
            [games addObject:game];
        }
        
        if(i%2 == 0){
            game.participateStatus = PARTICIPATE_STATUS_NO;
        }
        else if(i%3 == 0){
            game.participateStatus = PARTICIPATE_STATUS_YES;
        }
        else{
            game.participateStatus = PARTICIPATE_STATUS_UNKNOWN;
        }
    }
    
    blockHandler(games, nil);
}

+ (void) createNewGame:(NewGame *)game completionHandler:(void(^)(NSUInteger gameId, NSString *errorMessage))blockHandler {
    //NSString *url = [NSString stringWithFormat:API_URL_CREATE_GAME];
    
    /*
    [ZSNetManager sendGet:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSMutableDictionary *result = [NetHepler parceResponse:data error:&error];
        
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
            }
            else{
                if([result[@"data"] isKindOfClass:[NSNull class]])
                    blockHandler(nil, nil);
                else
                    blockHandler(result[@"data"], nil);
            }
        }
    }];
    */
    
    blockHandler(1, nil);
}

+ (BOOL) isInternetAvaliable {
    return [ZSNetManager isInternetAvaliable];
}

@end
