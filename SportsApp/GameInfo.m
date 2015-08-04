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
    
    if(type == 1)
        self.gameName = @"Футбол";
    else if(type == 2)
        self.gameName = @"Баскетбол";
    else if(type == 3)
        self.gameName = @"Волейбол";
    else if(type == 4)
        self.gameName = @"Гандбол";
    else if(type == 5)
        self.gameName = @"Тенис";
    else if(type == 6)
        self.gameName = @"Хоккей";
    else if(type == 7)
        self.gameName = @"Сквош";
}

@end
