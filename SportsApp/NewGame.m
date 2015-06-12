//
//  NewGame.m
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import "NewGame.h"

@implementation NewGame

- (instancetype) init {
    self = [super init];
    if(self){
        self.sport = -1;
        self.time = 0;
        self.age = 0;
        self.level = 0;
        self.players = 0;
    }
    
    return self;
}

@end
