//
//  AppNetHelper.m
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import "AppNetworking.h"
#import "NetManager.h"

#import "NSDate+Utilities.h"
#import "NSDate+Formater.h"

#define API_URL_CREATE_GAME @"http://sportsapp.com"
#define API_URL_GAMES_FOR_USER @"http://sportsapp.com"
#define API_URL_SETTINGS_FOR_USER @"http://sportsapp.com"

#define URL_YANDEX_GEOCODE_REVERS @"https://geocode-maps.yandex.ru/1.x/?sco=longlat&format=json&kind=locality&geocode=%f,%f"
#define URL_YANDEX_GEOCODE @"https://geocode-maps.yandex.ru/1.x/?format=json&kind=locality&geocode=%@"

#define URL_FOURSQUARE_PLACES @"https://api.foursquare.com/v2/venues/search?client_id=4VEAUGDRCSFZ2BD4ULIDIBJGGMJS3OSS5ZQGRV52RQ5MPF3H&client_secret=1PHGLVGY3ZTJH4EFN5AL0UX11NYOHGHAHG5GDBXEEA51CBD2&v=20130815&intent=browse&radius=10000&near=%@&query=%@"

@implementation AppNetworking {
    NSString *userToken;
}

// {error:0, data:{...} }
// {error:0, data:[...] }
// {error:3, data:null }

+ (instancetype)sharedInstance {
    static AppNetworking *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppNetworking alloc] init];
    });
    return sharedInstance;
}

- (void) setUserToken:(NSString *)token {
    userToken = token;
}

#pragma mark -
#pragma mark Login
- (void) loginUser:(NSDictionary *)params completionHandler:(void(^)(AppUser *user, NSString *errorMessage))blockHandler {
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/users/authentication.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    [NetManager sendPostMultipartFormData:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        AppUser *user = nil;
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            /*
             {"user":{"id":16,"provider":"vk","avatar":null,"provider_id":"244648174","email":null,"name":null,"age":null,"token":"yYo---X0u78hDXYwB-bpMQ","chat_password":"tVTY97LQvGc="},"new":false}
             */
            if(!hasError){
                user = [AppUser new];
                
                NSMutableDictionary *dic = (NSMutableDictionary *)resultJson;
                user.isNewUser = [dic[@"new"] boolValue];
                
                NSMutableDictionary *userDic = dic[@"user"];
                user.uid = [userDic[@"id"] integerValue];
                //user.age = [userDic[@"age"] integerValue];
                
                if(![userDic[@"email"] isKindOfClass:[NSNull class]])
                    user.email = userDic[@"email"];
                
                if(![userDic[@"name"] isKindOfClass:[NSNull class]])
                    user.name = userDic[@"name"];
                
                if(![userDic[@"avatar"] isKindOfClass:[NSNull class]])
                    user.avatar = userDic[@"avatar"];
                
                user.provider = userDic[@"provider"];
                //user.oauthToken = userDic[@"oauth_token"];
                user.oauthToken = params[@"oauth_token"];
                user.appToken = userDic[@"token"];
                
                user.chatLogin = [NSString stringWithFormat:@"AppChatLoginName_%lu", (unsigned long)user.uid];
                user.chatPassword = userDic[@"chat_password"];
                
                //user.chatLogin = @"TestUser2";
                //user.chatPassword = @"ahtrahtrahtr2";
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(nil, errorMessage);
        else
            blockHandler(user, nil);
    }];
}

#pragma mark -
#pragma mark Players
- (void) findUser:(NSString *)username completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler {
    // GET
    // IN: username
    // OUT: JSON data - [{userId, avatar, name}, {}, ...]
    
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/users/find_by_name.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    [params setValue:username forKey:@"name"];
    
    [NetManager sendGet:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL hasError = YES;
        NSString *errorMessage;
        NSMutableArray *members = [NSMutableArray new];
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableArray *arr = (NSMutableArray *)resultJson;
                
                for(NSMutableDictionary *dic in arr){
                    MemberInfo *member = [MemberInfo new];
                    member.userId = [dic[@"id"] integerValue];
                    member.name = dic[@"name"];
                    
                    if(![dic[@"avatar"] isKindOfClass:[NSNull class]])
                        member.icon = dic[@"avatar"];
                        
                    //member.icon = ; //@"http://pics.news.meta.ua/90x90/316/77/31677048-Chaku-Norrisu-ispolnilos-75-let.gif";
                    //member.invited = YES;
                    
                    [members addObject:member];
                }
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(nil, errorMessage);
        else
            blockHandler(members, nil);
    }];
}

- (void) inviteUserWithId:(NSUInteger)userId forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/invitations.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)userId] forKey:@"user_id"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)gameId] forKey:@"game_id"];
    
    [NetManager sendPostMultipartFormData:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL hasError = YES;
        NSString *errorMessage;
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableDictionary *resultDic = (NSMutableDictionary *)resultJson;
                
                NSString *result = resultDic[@"result"];
                if(![result isEqualToString:@"success"])
                    errorMessage = @"Не удалось пригласить пользователя.";
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(errorMessage);
        else
            blockHandler(nil);
    }];
}

- (void) inviteUserWithEmail:(NSString *)email completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/mail_invitations.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    [params setValue:email forKey:@"email"];
    
    [NetManager sendPostMultipartFormData:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL hasError = YES;
        NSString *errorMessage;
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableDictionary *resultDic = (NSMutableDictionary *)resultJson;
                
                NSString *result = resultDic[@"result"];
                if(![result isEqualToString:@"success"])
                    errorMessage = @"Не удалось пригласить пользователя.";
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(errorMessage);
        else
            blockHandler(nil);
    }];
}

- (void) setUserStatusForGame:(NSUInteger)gameId status:(NSUInteger)status completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/invitations.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)status] forKey:@"state"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)gameId] forKey:@"game_id"];
    
    [NetManager sendPatch:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL hasError = YES;
        NSString *errorMessage;
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableDictionary *resultDic = (NSMutableDictionary *)resultJson;
                
                NSString *result = resultDic[@"result"];
                if(![result isEqualToString:@"success"])
                    errorMessage = @"Не получилось, что-то пошло не так.";
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(errorMessage);
        else
            blockHandler(nil);
    }];
}

#pragma mark - 
#pragma mark Settings
- (void) settingsForCurrentUserCompletionHandler:(void(^)(MemberSettings *settings, NSString *errorMessage))blockHandler {
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

- (void) saveSettingsForCurrentUser:(MemberSettings *)settings completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    // POST
    // IN: userId, age, level, football, squash, tennis, basketball, volleyball, hockey, handball
    // OUT: JSON data - null
    
    blockHandler(nil);
}

#pragma mark -
#pragma mark Game
- (void) membersForGame:(NSUInteger)gameId completionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler {
    // GET
    // IN: gameId
    // OUT: JSON data - [{userId, avatar, name}, {}, ...]
    
    
    //get /api/v1/games/{id}/members.json
    
    NSString *url = [NSString stringWithFormat:@"https://start-sport.herokuapp.com:443/api/v1/games/%lu/members.json?api_key=JqwR7ncB-jss5vot23eaFQ", (unsigned long)gameId];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
    [NetManager sendGet:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        NSMutableArray *members = [NSMutableArray new];
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableArray *arr = (NSMutableArray *)resultJson;
                
                for(NSMutableDictionary *dic in arr){
                    MemberInfo* member = [MemberInfo new];
                    member.userId = 1;
                    member.name = @"User Name 111";
                    member.icon = @"http://pics.news.meta.ua/90x90/316/77/31677048-Chaku-Norrisu-ispolnilos-75-let.gif";
                    member.invited = YES;
                    
                    [members addObject:member];
                }
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(nil, errorMessage);
        else
            blockHandler(members, nil);
    }];
}

- (BOOL) handleResponse:(NSURLResponse *)response data:(NSData *)data resultObject:(id*)jsonObj errorMessage:(NSString **)msg {
    BOOL hasError = YES;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"statusCode: %lu", (unsigned long)statusCode);
    
    NSError *error = nil;
    if(statusCode >= 200 && statusCode < 300){
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        hasError = NO;
    }
    else{
        NSLog(@"Something wrong!");
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        *msg = dic[@"error"];
    }
    
    return hasError;
}

- (void) gamesInCity:(NSString *)city completionHandler:(void(^)(NSMutableArray *myGames, NSMutableArray *publicGames, NSString *errorMessage))blockHandler {
    // GET
    // IN: userId
    // OUT: JSON data - [{gameName, address, addressName, date, time, adminId, participateStatus}, {...}, ...]
    
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/games.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
    if(city)
        [params setValue:city forKey:@"city"];
    
    [NetManager sendGet:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        
        NSMutableArray *myGames = [NSMutableArray new];
        NSMutableArray *publicGames = [NSMutableArray new];
        
        if(!error){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSInteger statusCode = [httpResponse statusCode];
            NSLog(@"statusCode: %lu", (long)statusCode);
            
            if(statusCode >= 200 && statusCode < 300){
                NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                NSMutableArray *myG = resultDic[@"my"];
                NSMutableArray *publicG = resultDic[@"public"];
                
                // "id":5,"user_id":4,"sport_type_id":2,"start_at":"2015-08-10T10:00:41.000Z","age":4,"numbers":8,"level":3,"title":"Большой спорт зал школы №163","address":"Ул. Тикоцкого,9","participate_status":"possible"
                
                if([myG count] > 0){
                    for(NSMutableDictionary *gdic in myG){
                        GameInfo* game = [GameInfo new];
                        game.gameId = [gdic[@"id"] integerValue];
                        game.gameType = [gdic[@"sport_type_id"] integerValue];
                        //game.gameType = 1;
                        game.adminId = [gdic[@"user_id"] integerValue];
                        
                        game.addressName = gdic[@"title"];
                        game.address = gdic[@"address"]; //@"просп. Независимости 192б";
                        
                        NSDate *gameDate = [NSDate dateWithJsonString:gdic[@"start_at"]];
                        game.time = [gameDate toFormat:@"HH:mm"];
                        
                        if([gameDate isToday]){
                            game.date = @"сегодня";
                        }
                        else {
                            NSInteger days = [gameDate daysAfterDate:[NSDate new]];
                            
                            if(days < 0)
                                game.date = @"Игра окончена";
                            else
                                game.date = [NSString stringWithFormat:@"через %lu дня", (long)days];
                        }
                        
                        if([gdic[@"title"] isEqualToString:@"possible"]) //confirmed, 
                            game.participateStatus = PARTICIPATE_STATUS_YES;
                        
                        [myGames addObject:game];
                    }
                }
                
                if([publicG count] > 0){
                    for(NSMutableDictionary *gdic in publicG){
                        GameInfo* game = [GameInfo new];
                        game.gameId = [gdic[@"id"] integerValue];
                        game.gameType = [gdic[@"sport_type_id"] integerValue];
                        //game.gameType = 1;
                        game.adminId = [gdic[@"user_id"] integerValue];
                        
                        game.addressName = @"Всем спорт"; //gdic[@"title"];
                        game.address = @"просп. Независимости 192б"; //gdic[@"address"]; //@"просп. Независимости 192б";
                        
                        NSDate *gameDate = [NSDate dateWithJsonString:gdic[@"start_at"]];
                        game.time = [gameDate toFormat:@"HH:mm"];
                        
                        if([gameDate isToday]){
                            game.date = @"сегодня";
                        }
                        else {
                            NSInteger days = [gameDate daysAfterDate:[NSDate new]];
                            
                            if(days < 0)
                                game.date = @"Игра окончена";
                            else
                                game.date = [NSString stringWithFormat:@"через %lu дня", (long)days];
                        }
                        
                        game.participateStatus = PARTICIPATE_STATUS_NO;
                        
                        [publicGames addObject:game];
                    }
                }
                
                hasError = NO;
            }
            else{
                NSLog(@"Something wrong!");
                
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error];
                errorMessage = dic[@"error"];
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(nil, nil, errorMessage);
        else
            blockHandler(myGames, publicGames, nil);
    }];
}

- (void) createNewGame:(NewGame *)game completionHandler:(void(^)(NSUInteger gameId, NSString *errorMessage))blockHandler {
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/games.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.sport] forKey:@"sport_type_id"];
    [params setValue:game.time forKey:@"start_at"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.age] forKey:@"age"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.players] forKey:@"numbers"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.level] forKey:@"level"];
    
    if(game.placeName)
        [params setValue:game.placeName forKey:@"title"];
    else
        [params setValue:@"Place Name" forKey:@"title"];
    
    if(game.country)
        [params setValue:game.country forKey:@"country"];
    else
        [params setValue:@"" forKey:@"country"];
    
    if(game.city)
        [params setValue:game.city forKey:@"city"];
    else
        [params setValue:@"" forKey:@"city"];
    
    if(game.address)
        [params setValue:game.address forKey:@"address"];
    else
        [params setValue:@"" forKey:@"address"];
    
    [params setValue:[NSString stringWithFormat:@"%f", game.latitude] forKey:@"latitude"];
    [params setValue:[NSString stringWithFormat:@"%f", game.longitude] forKey:@"longitude"];
    
    [NetManager sendPostMultipartFormData:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        NSMutableDictionary *dic = nil;
        NSUInteger gameId = 0;
        
        if(!error){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSInteger statusCode = [httpResponse statusCode];
            NSLog(@"statusCode: %lu", (long)statusCode);
            
            if(statusCode >= 200 && statusCode < 300){
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                gameId = [dic[@"id"] integerValue];
                hasError = NO;
            }
            else{
                NSLog(@"Something wrong!");
                errorMessage = dic[@"error"];
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(0, errorMessage);
        else
            blockHandler(gameId, nil);
    }];
}

- (void) editGame:(NewGame *)game withId:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
     NSString *url = [NSString stringWithFormat:@"https://start-sport.herokuapp.com:443/api/v1/games/%lu.json?api_key=JqwR7ncB-jss5vot23eaFQ", (unsigned long)gameId];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)gameId] forKey:@"id"];
    [params setValue:game.time forKey:@"start_at"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.age] forKey:@"age"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.players] forKey:@"numbers"];
    [params setValue:[NSString stringWithFormat:@"%lu", (unsigned long)game.level] forKey:@"level"];
    
    if(game.placeName)
        [params setValue:game.placeName forKey:@"title"];
    else
        [params setValue:@"Place Name" forKey:@"title"];
    
    if(game.country)
        [params setValue:game.country forKey:@"country"];
    else
        [params setValue:@"" forKey:@"country"];
    
    if(game.city)
        [params setValue:game.city forKey:@"city"];
    else
        [params setValue:@"" forKey:@"city"];
    
    if(game.address)
        [params setValue:game.address forKey:@"address"];
    else
        [params setValue:@"" forKey:@"address"];
    
    [params setValue:[NSString stringWithFormat:@"%f", game.latitude] forKey:@"latitude"];
    [params setValue:[NSString stringWithFormat:@"%f", game.longitude] forKey:@"longitude"];
    
    [NetManager sendPatch:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(errorMessage);
        else
            blockHandler(nil);
    }];
}

- (void) gameById:(NSUInteger)gameId completionHandler:(void(^)(GameInfo *gameInfo, NSString *errorMessage))blockHandler {
    NSString *url = [NSString stringWithFormat:@"https://start-sport.herokuapp.com:443/api/v1/games/%lu.json?api_key=JqwR7ncB-jss5vot23eaFQ", (unsigned long)gameId];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
    [NetManager sendGet:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        GameInfo *game = [GameInfo new];
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableDictionary *resultDic = (NSMutableDictionary *)resultJson;
                
                /*
                {"id":10,"user_id":24,"sport_type_id":7,"start_at":"2015-11-01T11:47:37.000Z","title":"Делта-Спорт Nike","country":"Беларусь","city":"Минск","address":"ул. Ленина, 16","latitude":"53.899731","longitude":"27.560171","age":2,"numbers":21,"level":3,"members":
                    */
                
                game.gameId = [resultDic[@"id"] integerValue];
                game.gameType = [resultDic[@"sport_type_id"] integerValue];
                game.adminId = [resultDic[@"user_id"] integerValue];
                game.participateStatus = PARTICIPATE_STATUS_UNKNOWN;
                
                if(![resultDic[@"title"] isKindOfClass:[NSNull class]])
                    game.addressName = resultDic[@"title"];
                
                if(![resultDic[@"address"] isKindOfClass:[NSNull class]])
                    game.address = resultDic[@"address"];
                
                game.startAt = resultDic[@"start_at"];
                NSDate *gameDate = [NSDate dateWithJsonString:resultDic[@"start_at"]];
                game.time = [gameDate toFormat:@"HH:mm"];
                
                if([gameDate isToday]){
                    game.date = @"сегодня";
                }
                else {
                    NSInteger days = [gameDate daysAfterDate:[NSDate new]];
                    
                    if(days < 0)
                        game.date = @"Игра окончена";
                    else
                        game.date = [NSString stringWithFormat:@"через %lu дня", (long)days];
                }
                
                game.age = [resultDic[@"age"] integerValue];
                game.level = [resultDic[@"level"] integerValue];
                game.numbers = [resultDic[@"numbers"] integerValue];
                
                // members
                game.members = [NSMutableArray new];
                NSMutableArray *membersArr = resultDic[@"members"];
                
                for(NSMutableDictionary *dic in membersArr){
                    MemberInfo *member = [MemberInfo new];
                    member.userId = [dic[@"id"] integerValue];
                    member.name = dic[@"name"];
                    
                    if(![dic[@"avatar"] isKindOfClass:[NSNull class]])
                        member.icon = dic[@"avatar"];
                    
                    [game.members addObject:member];
                }
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(nil, errorMessage);
        else
            blockHandler(game, nil);
    }];
}

- (void) citiesCompletionHandler:(void(^)(NSMutableArray *arrayData, NSString *errorMessage))blockHandler {
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/games/cityes.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
    [NetManager sendGet:url withParams:params completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        BOOL hasError = YES;
        NSString *errorMessage;
        NSMutableArray *cities = [NSMutableArray new];
        
        if(!error){
            id resultJson = nil;
            hasError = [self handleResponse:response data:data resultObject:&resultJson errorMessage:&errorMessage];
            
            if(!hasError){
                NSMutableArray *arr = (NSMutableArray *)resultJson;
                
                cities = arr;
            }
        }
        else {
            NSLog(@"error: %@", error.debugDescription);
            errorMessage = error.description;
        }
        
        if(hasError)
            blockHandler(nil, errorMessage);
        else
            blockHandler(cities, nil);
    }];
}

#pragma mark -
#pragma mark Yandex
+ (void) findYandexAddressForLatitude:(CGFloat)lat longitude:(CGFloat)lng completionHandler:(void(^)(YandexGeoResponse *resp, NSString *errorMessage))blockHandler {
    NSString *url = [NSString stringWithFormat:URL_YANDEX_GEOCODE_REVERS, lng, lat];
    
    [NetManager sendGet:url withParams:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
            }
            else{
                YandexGeoResponse *yandexResp = [AppNetworking parceYandexAddressResponse:data];
                if(!yandexResp)
                    blockHandler(nil, @"Ничего не найдено");
                else
                    blockHandler(yandexResp, nil);
            }
        }
    }];
}

+ (YandexGeoResponse *) parceYandexAddressResponse:(NSData *)data {
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!error){
        NSMutableDictionary *response = json[@"response"];
        NSMutableDictionary *GeoObjectCollection = response[@"GeoObjectCollection"];
        NSMutableArray *featureMember = GeoObjectCollection[@"featureMember"];
        
        if(featureMember.count == 0)
            return nil;
        
        NSMutableDictionary *GeoObject = featureMember[0][@"GeoObject"];
        
        YandexGeoResponse *resp = [YandexGeoResponse new];
        resp.name = GeoObject[@"name"];
        resp.descr = GeoObject[@"description"];
        
        NSMutableDictionary *point = GeoObject[@"point"];
        NSString *pos = point[@"pos"];
        NSArray *location = [pos componentsSeparatedByString: @" "];
        if([location count] > 1){
            resp.lng = [location[0] floatValue];
            resp.lat = [location[1] floatValue];
        }
        
        return resp;
    }
    
    return nil;
}

+ (void) findYandexAddress:(NSString *)query completionHandler:(void(^)(NSMutableArray *items, NSString *errorMessage))blockHandler {
    NSString *url = [NSString stringWithFormat:URL_YANDEX_GEOCODE, query];
    
    [NetManager sendGet:url withParams:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Yandex response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
            }
            else{
                NSMutableArray *yandexResp = [AppNetworking parceYandexAddressListResponse:data];
                if(!yandexResp)
                    blockHandler(nil, @"Ничего не найдено");
                else
                    blockHandler(yandexResp, nil);
            }
        }
    }];
}

+ (NSMutableArray *) parceYandexAddressListResponse:(NSData *)data {
    NSMutableArray *results = nil;
    
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!error){
        results = [NSMutableArray new];
        
        NSMutableDictionary *response = json[@"response"];
        NSMutableDictionary *GeoObjectCollection = response[@"GeoObjectCollection"];
        NSMutableArray *featureMember = GeoObjectCollection[@"featureMember"];
        
        for(NSMutableDictionary *item in featureMember){
            NSMutableDictionary *GeoObject = item[@"GeoObject"];
            NSString *name = GeoObject[@"name"];
            
            if(!name)
                continue;
            
            YandexGeoResponse *resp = [YandexGeoResponse new];
            resp.name = name;
            
            NSString *descr = GeoObject[@"description"];
            resp.descr = descr;
            
            NSMutableDictionary *metaDataProperty = GeoObject[@"metaDataProperty"];
            NSMutableDictionary *GeocoderMetaData = metaDataProperty[@"GeocoderMetaData"];
            
            //Беларусь, Минская область, Минск, Победы улица, 101
            NSString *fullAddress = GeocoderMetaData[@"text"];
            if(fullAddress){
                NSArray *part = [fullAddress componentsSeparatedByString: @","];
                if([part count] > 0)
                    resp.country = [part[0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                
                if([part count] > 2)
                    resp.city = [part[2] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                
                if([part count] > 3){
                    NSString *street = [part[3] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    
                    NSString *build = nil;
                    if([part count] > 4)
                        build = [part[4] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                    
                    if(build){
                        resp.address = [NSString stringWithFormat:@"%@, %@", street, build];
                    }
                    else{
                        resp.address = street;
                    }
                }
            }
            
            NSMutableDictionary *point = GeoObject[@"Point"];
            NSString *pos = point[@"pos"];
            NSArray *location = [pos componentsSeparatedByString: @" "];
            if([location count] > 1){
                resp.lng = [location[0] floatValue];
                resp.lat = [location[1] floatValue];
            }
            
            [results addObject:resp];
        }
    }
    
    return results;
}

#pragma mark -
#pragma mark Foursquare
+ (void) findFoursquarePlacesInRegion:(NSString *)regionName search:(NSString *)query completionHandler:(void(^)(NSMutableArray *resp, NSString *errorMessage))blockHandler {
    NSString *url = [NSString stringWithFormat:URL_FOURSQUARE_PLACES, regionName, query];
    
    [NetManager sendGet:url withParams:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
                NSLog(@"%@", error.debugDescription);
            }
            else{
                NSMutableArray *foursquareResp = [AppNetworking parceFoursquareResponse:data];
                if(!foursquareResp)
                    blockHandler(nil, @"Ничего не найдено");
                else
                    blockHandler(foursquareResp, nil);
            }
        }
    }];
}

+ (NSMutableArray *) parceFoursquareResponse:(NSData *)data {
    NSMutableArray *results = nil;
    
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(!error){
        results = [NSMutableArray new];
        
        NSMutableDictionary *response = json[@"response"];
        NSMutableArray *venues = response[@"venues"];
        
        for(NSMutableDictionary *item in venues){
            FoursquareResponse *place = [FoursquareResponse new];
            place.name = item[@"name"];
            
            NSMutableDictionary *location = item[@"location"];
            
            place.country = location[@"country"];
            place.city = location[@"city"];
            place.address = location[@"address"];
            
            place.lat = [location[@"lat"] floatValue];
            place.lng = [location[@"lng"] floatValue];
            
            /*
            NSMutableArray *categories = item[@"categories"];
            if(categories.count > 0){
                NSMutableDictionary *icon = categories[0][@"icon"];
                
                if(icon)
                    place.icon = [NSString stringWithFormat:@"%@88%@", icon[@"prefix"], icon[@"suffix"]];
            }
             */
            
            [results addObject:place];
        }
    }
    
    return results;
}

#pragma mark -
+ (void) downloadImageWithUrl:(NSString *)imageUrl completionHandler:(void(^)(NSData *imageData))blockHandler {
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *loc, NSURLResponse *response, NSError *error) {
        if(!error){
            if(blockHandler != nil){
                NSData *d = [NSData dataWithContentsOfURL:loc];
                blockHandler(d);
            }
        }
    }];
    [task resume];
}

+ (BOOL) isInternetAvaliable {
    return [NetManager isInternetAvaliable];
}

@end
