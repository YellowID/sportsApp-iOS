//
//  MemberInfo.h
//  SportsApp
//
//  Created by sergeyZ on 28.05.15.
//
//

#import <Foundation/Foundation.h>

@interface MemberInfo : NSObject

@property (nonatomic) NSUInteger userId;
@property (copy, nonatomic) NSString* icon;
@property (copy, nonatomic) NSString* name;

@property (nonatomic) BOOL invited;

@end
