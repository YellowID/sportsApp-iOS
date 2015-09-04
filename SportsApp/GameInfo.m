//
//  GameInfo.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "GameInfo.h"

@implementation GameInfo

@synthesize sportType = _sportType;

- (void) setSportType:(SportType)type {
    _sportType = type;
    
    switch(type){
        case SportTypeFootball:
            self.gameName = @"Футбол";
            break;
        case SportTypeBasketball:
            self.gameName = @"Баскетбол";
            break;
        case SportTypeVolleyball:
            self.gameName = @"Волейбол";
            break;
        case SportTypeHandball:
            self.gameName = @"Гандбол";
            break;
        case SportTypeTennis:
            self.gameName = @"Тенис";
            break;
        case SportTypeHockey:
            self.gameName = @"Хоккей";
            break;
        case SportTypeSquash:
            self.gameName = @"Сквош";
            break;
            
        default:
            self.gameName = nil;
            break;
    }
}

@end
