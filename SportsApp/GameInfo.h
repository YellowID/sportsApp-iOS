//
//  GameInfo.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <Foundation/Foundation.h>

#define PARTICIPATE_STATUS_NO 1
#define PARTICIPATE_STATUS_YES 2
#define PARTICIPATE_STATUS_UNKNOWN 3

@interface GameInfo : NSObject

@property (nonatomic) NSUInteger gameId;
@property (nonatomic) NSUInteger gameType;
@property (copy, nonatomic) NSString *gameName;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *addressName;

@property (copy, nonatomic) NSString *startAt;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;

@property (nonatomic) NSUInteger age;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger numbers;

@property (nonatomic) NSUInteger adminId;
@property (nonatomic) NSUInteger participateStatus;

@property (retain, nonatomic) NSMutableArray *members;

//+ (NSString *) gameNameForTypeId:(NSUInteger)gameType;

//- (void) setGameType:(NSUInteger)gameType;

@end
