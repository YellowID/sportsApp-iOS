//
//  NewGame.h
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NewGame : NSObject

@property (copy, nonatomic) NSString *placeName;

@property (nonatomic) NSInteger sport;
@property (nonatomic) NSUInteger time; // timestamp
@property (nonatomic) NSUInteger age;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger players;


@end
