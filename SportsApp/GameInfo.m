//
//  GameInfo.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "GameInfo.h"

@implementation GameInfo

@synthesize gameType = _gameType;

- (void) setGameType:(NSUInteger)type {
    _gameType = type;
    
    if(type == GAME_TYPE_FOOTBALL)
        self.gameName = @"Футбол";
    else if(type == GAME_TYPE_BASKETBALL)
        self.gameName = @"Баскетбол";
    else if(type == GAME_TYPE_VOLLEYBALL)
        self.gameName = @"Волейбол";
    else if(type == GAME_TYPE_HANDBALL)
        self.gameName = @"Гандбол";
    else if(type == GAME_TYPE_TENNIS)
        self.gameName = @"Тенис";
    else if(type == GAME_TYPE_HOCKEY)
        self.gameName = @"Хоккей";
    else if(type == GAME_TYPE_SQUASH)
        self.gameName = @"Сквош";
}

@end
