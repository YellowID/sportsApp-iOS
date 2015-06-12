//
//  GameInfo.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <Foundation/Foundation.h>

#define PARTICIPATE_STATUS_NO 0
#define PARTICIPATE_STATUS_YES 1
#define PARTICIPATE_STATUS_UNKNOWN 3

@interface GameInfo : NSObject

@property (copy, nonatomic) NSString *gameName;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *addressName;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;

@property (nonatomic) NSUInteger adminId;
@property (nonatomic) NSUInteger participateStatus;

@end
