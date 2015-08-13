//
//  NewGame.h
//  SportsApp
//
//  Created by sergeyZ on 10.06.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface NewGame : NSObject

@property (nonatomic) NSUInteger sport;
@property (copy, nonatomic) NSString *time;
@property (nonatomic) NSUInteger age;
@property (nonatomic) NSUInteger level;
@property (nonatomic) NSUInteger players;

@property (copy, nonatomic) NSString *placeName; //title
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *address;

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;



@end
