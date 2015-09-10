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
            self.gameName = NSLocalizedString(@"STORT_FOOTBALL", nil);
            break;
        case SportTypeBasketball:
            self.gameName = NSLocalizedString(@"STORT_BASKETBALL", nil);
            break;
        case SportTypeVolleyball:
            self.gameName = NSLocalizedString(@"STORT_VOLLEYBALL", nil);
            break;
        case SportTypeHandball:
            self.gameName = NSLocalizedString(@"STORT_HANDBALL", nil);
            break;
        case SportTypeTennis:
            self.gameName = NSLocalizedString(@"STORT_TENNIS", nil);
            break;
        case SportTypeHockey:
            self.gameName = NSLocalizedString(@"STORT_HOCKEY", nil);
            break;
        case SportTypeSquash:
            self.gameName =NSLocalizedString(@"STORT_SQUASH", nil);
            break;
            
        default:
            self.gameName = nil;
            break;
    }
}

@end
