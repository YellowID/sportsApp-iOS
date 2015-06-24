//
//  AppNetHelper.m
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import "AppNetHelper.h"
#import "ZSNetManager.h"

#define API_URL_CREATE_GAME @"http://sportsapp.com"
#define API_URL_GAMES_FOR_USER @"http://sportsapp.com"
#define API_URL_SETTINGS_FOR_USER @"http://sportsapp.com"

#define URL_YANDEX_GEOCODE_REVERS @"https://geocode-maps.yandex.ru/1.x/?sco=longlat&format=json&kind=locality&geocode=%f,%f"
#define URL_YANDEX_GEOCODE @"https://geocode-maps.yandex.ru/1.x/?format=json&kind=locality&geocode=%@"

#define URL_FOURSQUARE_PLACES @"https://api.foursquare.com/v2/venues/search?client_id=4VEAUGDRCSFZ2BD4ULIDIBJGGMJS3OSS5ZQGRV52RQ5MPF3H&client_secret=1PHGLVGY3ZTJH4EFN5AL0UX11NYOHGHAHG5GDBXEEA51CBD2&v=20130815&intent=browse&radius=10000&near=%@&query=%@"

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
    // OUT: JSON data - [{gameName, address, addressName, date, time, adminId, participateStatus}, {...}, ...]
    
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

#pragma mark -
#pragma mark Yandex
+ (void) findYandexAddressForLatitude:(CGFloat)lat longitude:(CGFloat)lng completionHandler:(void(^)(YandexGeoResponse *resp, NSString *errorMessage))blockHandler {
    NSString *url = [NSString stringWithFormat:URL_YANDEX_GEOCODE_REVERS, lng, lat];
    
    [ZSNetManager sendGet:url withParams:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
            }
            else{
                YandexGeoResponse *yandexResp = [AppNetHelper parceYandexAddressResponse:data];
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
    
    [ZSNetManager sendGet:url withParams:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
            }
            else{
                NSMutableArray *yandexResp = [AppNetHelper parceYandexAddressListResponse:data];
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
            
            NSMutableDictionary *point = GeoObject[@"point"];
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
    
    [ZSNetManager sendGet:url withParams:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil){
            if(error){
                blockHandler(nil, error.localizedDescription);
                NSLog(@"%@", error.debugDescription);
            }
            else{
                NSMutableArray *foursquareResp = [AppNetHelper parceFoursquareResponse:data];
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
    return [ZSNetManager isInternetAvaliable];
}

@end
