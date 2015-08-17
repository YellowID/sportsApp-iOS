//
//  QuickbloxWrapper.h
//  SportsApp
//
//  Created by sergeyZ on 13.08.15.
//
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

#import "AppUser.h"
#import "ChatMessage.h"

@protocol AppChatDelegate;

@interface AppChat : NSObject <QBChatDelegate>

@property (weak, nonatomic) id <AppChatDelegate> delegate;

+ (instancetype)sharedInstance;

+ (void) logout;

- (void) signUpWithLogin:(NSString *)login password:(NSString *)pass externalID:(NSUInteger)externalUserID fullName:(NSString *)fullName avatarUrl:(NSString *)avatarUrl  completionHandler:(void(^)(BOOL isSuccess))blockHandler;

- (void) loginWithName:(NSString *)userLogin password:(NSString *)userPassword completionHandler:(void(^)(BOOL isSuccess))blockHandler;

- (void) messagesForGameId:(NSUInteger)gameId completionHandler:(void(^)(NSArray *chatMessages))blockHandler;
- (void) sendMessage:(NSString *)message forGameId:(NSUInteger)gameId fromUser:(AppUser *)user completionHandler:(void(^)(BOOL isSent))blockHandler;

@end

@protocol AppChatDelegate <NSObject>
- (void)appChatDidReceiveMessage:(ChatMessage *)message;
@end