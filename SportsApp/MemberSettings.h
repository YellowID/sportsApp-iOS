//
//  MemberSettings.h
//  SportsApp
//
//  Created by sergeyZ on 12.06.15.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MemberSettings : NSObject

@property (nonatomic) PlayerAge age;
@property (nonatomic) PlayerLevel level;

@property (nonatomic) BOOL football;
@property (nonatomic) BOOL basketball;
@property (nonatomic) BOOL volleyball;
@property (nonatomic) BOOL handball;
@property (nonatomic) BOOL tennis;
@property (nonatomic) BOOL hockey;
@property (nonatomic) BOOL squash;

@end
