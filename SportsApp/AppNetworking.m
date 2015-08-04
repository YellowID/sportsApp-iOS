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
        NSMutableDictionary *dic = nil;
        AppUser *user = nil;
        
        if(!error){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSInteger statusCode = [httpResponse statusCode];
            NSLog(@"statusCode: %lu", (long)statusCode);
            
            if(statusCode >= 200 && statusCode < 300){
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                user = [AppUser new];
                user.uid = [dic[@"id"] integerValue];
                //user.age = [dic[@"age"] integerValue];
                
                if(![dic[@"email"] isKindOfClass:[NSNull class]])
                    user.email = dic[@"email"];
                
                if(![dic[@"name"] isKindOfClass:[NSNull class]])
                    user.email = dic[@"name"];
                
                user.provider = dic[@"provider"];
                user.oauthToken = dic[@"oauth_token"];
                user.appToken = dic[@"token"];
                user.chatPassword = dic[@"chat_password"];
                
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

- (void) inviteUserWithId:(NSUInteger)userId forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    // GET
    // IN: userId, gameId
    // OUT: JSON data - null
    
    blockHandler(nil);
}

- (void) inviteUserWithEmail:(NSString *)email forGame:(NSUInteger)gameId completionHandler:(void(^)(NSString *errorMessage))blockHandler {
    // GET
    // IN: email, gameId
    // OUT: JSON data - null
    
    blockHandler(nil);
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
    
    
    /*
    for(int i = 0; i < 14; ++i){
        MemberInfo* member = [MemberInfo new];
        member.userId = 1;
        member.name = [NSString stringWithFormat:@"User Name %lu", (unsigned long)i];
        member.icon = @"http://pics.news.meta.ua/90x90/316/77/31677048-Chaku-Norrisu-ispolnilos-75-let.gif";
        member.invited = YES;
        
        [members addObject:member];
    }
     
     blockHandler(members, nil);
    */
    
    
}

- (BOOL) handleResponse:(NSURLResponse *)response data:(NSData *)data resultObject:(id*)jsonObj errorMessage:(NSString **)msg {
    BOOL hasError = YES;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"statusCode: %lu", (unsigned long)statusCode);
    
    NSError *error = nil;
    if(statusCode >= 200 && statusCode < 300){
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

- (void) gamesForCurrentUserCompletionHandler:(void(^)(NSMutableArray *myGames, NSMutableArray *publicGames, NSString *errorMessage))blockHandler {
    // GET
    // IN: userId
    // OUT: JSON data - [{gameName, address, addressName, date, time, adminId, participateStatus}, {...}, ...]
    
    NSString *url = @"https://start-sport.herokuapp.com:443/api/v1/games.json?api_key=JqwR7ncB-jss5vot23eaFQ";
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userToken forKey:@"user_token"];
    
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
                
                if([myG count] > 0){
                    for(NSMutableDictionary *gdic in myG){
                        GameInfo* game = [GameInfo new];
                        game.gameId = [gdic[@"id"] integerValue];
                        //game.gameName = sportDic[@"name"];
                        //game.gameType = [gdic[@"sport_type_id"] integerValue];
                        game.gameType = 1;
                        game.adminId = [gdic[@"user_id"] integerValue];
                        
                        game.addressName = @"Всем спорт"; //gdic[@"title"];
                        game.address = @"просп. Независимости 192б"; //gdic[@"address"]; //@"просп. Независимости 192б";
                        
                        game.time = @"25:00";
                        
                        NSDate *gameDate = [NSDate dateWithJsonString:gdic[@"start_at"]];
                        game.time = [gameDate toFormat:@"HH:mm"];
                        
                        if([gameDate isToday]){
                            game.date = @"сегодня";
                        }
                        else {
                            NSInteger days = [gameDate daysAfterDate:[NSDate new]];
                            
                            if(days < 0)
                                game.date = @"game over";
                            else
                                game.date = [NSString stringWithFormat:@"через %lu дня", (long)days];
                        }
                        
                        game.participateStatus = PARTICIPATE_STATUS_NO;
                        
                        [myGames addObject:game];
                    }
                }
                
                if([publicG count] > 0){
                    for(NSMutableDictionary *gdic in publicG){
                        GameInfo* game = [GameInfo new];
                        game.gameId = [gdic[@"id"] integerValue];
                        //game.gameName = sportDic[@"name"];
                        //game.gameType = [gdic[@"sport_type_id"] integerValue];
                        game.gameType = 1;
                        game.adminId = [gdic[@"user_id"] integerValue];
                        
                        game.addressName = @"Всем спорт"; //gdic[@"title"];
                        game.address = @"просп. Независимости 192б"; //gdic[@"address"]; //@"просп. Независимости 192б";
                        
                        game.time = @"25:00";
                        
                        NSDate *gameDate = [NSDate dateWithJsonString:gdic[@"start_at"]];
                        game.time = [gameDate toFormat:@"HH:mm"];
                        
                        if([gameDate isToday]){
                            game.date = @"сегодня";
                        }
                        else {
                            NSInteger days = [gameDate daysAfterDate:[NSDate new]];
                            //game.date = @"через 3 дня";
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
                
                
                game.gameId = [resultDic[@"id"] integerValue];
                game.gameType = 1;
                game.adminId = 4;
                game.participateStatus = PARTICIPATE_STATUS_NO;
                
                game.addressName = resultDic[@"title"];
                game.address = resultDic[@"address"]; //@"просп. Независимости 192б";
                
                game.time = @"25:00";
                
                NSDate *gameDate = [NSDate dateWithJsonString:resultDic[@"start_at"]];
                game.time = [gameDate toFormat:@"HH:mm"];
                
                if([gameDate isToday]){
                    game.date = @"сегодня";
                }
                else {
                    NSInteger days = [gameDate daysAfterDate:[NSDate new]];
                    game.date = [NSString stringWithFormat:@"через %lu дня", (long)days];
                }
                
                game.age = [resultDic[@"age"] integerValue];
                game.level = [resultDic[@"level"] integerValue];
                game.numbers = [resultDic[@"numbers"] integerValue];
                
                game.members = [NSMutableArray new];
                
                // members
                NSMutableArray *membersArr = resultDic[@"members"];
                
                for(NSMutableDictionary *mdic in membersArr){
                    MemberInfo* member = [MemberInfo new];
                    member.userId = 1;
                    member.name = @"User Name 111";
                    member.icon = @"http://pics.news.meta.ua/90x90/316/77/31677048-Chaku-Norrisu-ispolnilos-75-let.gif";
                    member.invited = YES;
                    
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
            
            [results addObject:place];
        }
    }
    
    return results;
}

#pragma mark -
+ (BOOL) isInternetAvaliable {
    return [NetManager isInternetAvaliable];
}

@end
