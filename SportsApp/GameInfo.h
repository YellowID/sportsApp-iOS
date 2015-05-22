//
//  GameInfo.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <Foundation/Foundation.h>

@interface GameInfo : NSObject

@property (copy, nonatomic) NSString *gameName;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *addressName;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;

@property (nonatomic) BOOL flag;

@end
