//
//  ChatMessage.h
//  SportsApp
//
//  Created by sergeyZ on 05.06.15.
//
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

@property (copy, nonatomic) NSString *avatarLink;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *time;

@property (copy, nonatomic) NSString *userName;
@property (nonatomic) NSUInteger userId;

@property (copy, nonatomic) NSDate *fullDate;

@end
