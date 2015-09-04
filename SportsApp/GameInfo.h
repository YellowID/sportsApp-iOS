//
//  GameInfo.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

enum UserGameParticipateStatus : NSUInteger {
    UserGameParticipateStatusNo = 1,
    UserGameParticipateStatusYes,
    UserGameParticipateStatusPossible
};
typedef enum UserGameParticipateStatus UserGameParticipateStatus;

@interface GameInfo : NSObject

@property (nonatomic) NSUInteger gameId;
@property (nonatomic) SportType sportType;
@property (copy, nonatomic) NSString *gameName;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *addressName;

@property (copy, nonatomic) NSString *startAt;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;

@property (nonatomic) PlayerAge age;
@property (nonatomic) PlayerLevel level;
@property (nonatomic) NSUInteger numbers;

@property (nonatomic) NSUInteger adminId;
@property (nonatomic) UserGameParticipateStatus participateStatus;

@property (retain, nonatomic) NSMutableArray *members;

@end
