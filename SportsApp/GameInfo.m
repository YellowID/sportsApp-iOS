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

/*
- (NSString *) gameName {
    NSString *name = @"Игра";
    
    if(_gameType == GAME_TYPE_FOOTBALL)
        name = @"Футбол";
    else if(_gameType == GAME_TYPE_BASKETBALL)
        name = @"Баскетбол";
    else if(_gameType == GAME_TYPE_VOLLEYBALL)
        name = @"Волейбол";
    else if(_gameType == GAME_TYPE_HANDBALL)
        name = @"Гандбол";
    else if(_gameType == GAME_TYPE_TENNIS)
        name = @"Тенис";
    else if(_gameType == GAME_TYPE_HOCKEY)
        name = @"Хоккей";
    else if(_gameType == GAME_TYPE_SQUASH)
        name = @"Сквош";
    
    return name;
}
*/

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
