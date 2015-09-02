//
//  QuickbloxWrapper.m
//  SportsApp
//
//  Created by sergeyZ on 13.08.15.
//
//

#import "AppChat.h"
#import "NSDate+Utilities.h"
#import "NSDate+Formater.h"

#define UNIQUE_APP_DIALOG_NAME @"DialogName_WTfbLpVwJO"

@implementation AppChat {
    NSMutableDictionary *dialogsCache;
    QBChatDialog *lastUsedChatDialog;
}

+ (instancetype)sharedInstance {
    static AppChat *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppChat alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 
#pragma mark App specific methods
+ (void) logout {
    if([[QBChat instance] isLoggedIn])
        [[QBChat instance] logout];
}

- (void) signUpWithLogin:(NSString *)login password:(NSString *)pass externalID:(NSUInteger)externalUserID fullName:(NSString *)fullName avatarUrl:(NSString *)avatarUrl completionHandler:(void(^)(BOOL isSuccess))blockHandler {
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        QBUUser *newUser = [QBUUser user];
        newUser.login = login;
        newUser.password = pass;
        newUser.externalUserID = externalUserID;
        newUser.fullName = fullName;
        newUser.customData = avatarUrl;
        
        [QBRequest signUp:newUser successBlock:^(QBResponse *response, QBUUser *user) {
            blockHandler(YES);
        } errorBlock:^(QBResponse *response) {
            NSLog(@"QBRequest signUp newUser: %@", response.error.debugDescription);
            blockHandler(NO);
        }];
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"createSessionWithSuccessBlock: %@", response.error.debugDescription);
        blockHandler(NO);
    }];
}

- (void) loginWithName:(NSString *)userLogin password:(NSString *)userPassword completionHandler:(void(^)(BOOL isSuccess))blockHandler {
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        [[QBChat instance] addDelegate:self];
        [QBChat instance].autoReconnectEnabled = YES;
        
        // login to QBChat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
        currentUser.password = userPassword;
        
        if([[QBChat instance] loginWithUser:currentUser])
            NSLog(@"QBChat loginWithUser - OK");
        else
            NSLog(@"QBChat loginWithUser - ERR");
        
        blockHandler(YES);
    } errorBlock:^(QBResponse *response) {
        NSLog(@"error: %@", response.error);
        blockHandler(NO);
    }];
}

- (void) messagesForGameId:(NSUInteger)gameId completionHandler:(void(^)(NSArray *chatMessages))blockHandler {
    if(!dialogsCache)
        dialogsCache = [NSMutableDictionary new];
    
    NSString *dialogName = [NSString stringWithFormat:@"%@_%lu", UNIQUE_APP_DIALOG_NAME, (unsigned long)gameId];
    
    [self dialogForName:dialogName completionHandler:^(QBChatDialog *chatDialog) {
        if(chatDialog){
            [dialogsCache setObject:chatDialog forKey:dialogName];
            lastUsedChatDialog = chatDialog;
            
            [self messagesForDialog:chatDialog completionHandler:^(NSArray *chatMessages) {
                if(chatMessages){
                    NSMutableArray *result = [self qbChatMessagesToAppFormat:chatMessages];
                    blockHandler(result);
                }
                else{
                    blockHandler(nil);
                }
            }];
        }
        else{
            [self createDialogWithName:dialogName completionHandler:^(QBChatDialog *chatDialog) {
                if(chatDialog){
                    [dialogsCache setObject:chatDialog forKey:dialogName];
                    lastUsedChatDialog = chatDialog;
                }
                    
                blockHandler(nil);
            }];
        }
    }];
}

- (void) sendMessage:(NSString *)message forGameId:(NSUInteger)gameId fromUser:(AppUser *)user completionHandler:(void(^)(BOOL isSent))blockHandler {
    NSString *dialogName = [NSString stringWithFormat:@"%@_%lu", UNIQUE_APP_DIALOG_NAME, (unsigned long)gameId];
    
    QBChatDialog *chatDialog = [dialogsCache objectForKey:dialogName];
    if(chatDialog){
        [self joinToDialog:chatDialog completionHandler:^(BOOL isJioned) {
            if(isJioned){
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"app_user_id"] = @(user.uid);
                
                if(user.name)
                    params[@"app_user_name"] = user.name;
                
                if(user.avatar)
                    params[@"app_user_avatar"] = user.avatar;
                
                BOOL sendResult = [self sendMessage:message toChat:chatDialog withParams:params];
                blockHandler(sendResult);
            }
            else{
                blockHandler(NO);
            }
        }];
    }
    else{
        [self dialogForName:dialogName completionHandler:^(QBChatDialog *chatDialog) {
            if(chatDialog){
                [self joinToDialog:chatDialog completionHandler:^(BOOL isJioned) {
                    if(isJioned){
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        params[@"app_user_id"] = @(user.uid);
                        
                        if(user.name)
                            params[@"app_user_name"] = user.name;
                        
                        if(user.avatar)
                            params[@"app_user_avatar"] = user.avatar;
                        
                        BOOL sendResult = [self sendMessage:message toChat:chatDialog withParams:params];
                        blockHandler(sendResult);
                    }
                    else{
                        blockHandler(NO);
                    }
                }];
            }
            else{
                [self createDialogWithName:dialogName completionHandler:^(QBChatDialog *chatDialog) {
                    if(chatDialog){
                        [self joinToDialog:chatDialog completionHandler:^(BOOL isJioned) {
                            if(isJioned){
                                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                                params[@"app_user_id"] = @(user.uid);
                                
                                if(user.name)
                                    params[@"app_user_name"] = user.name;
                                
                                if(user.avatar)
                                    params[@"app_user_avatar"] = user.avatar;
                                
                                BOOL sendResult = [self sendMessage:message toChat:chatDialog withParams:params];
                                blockHandler(sendResult);
                            }
                            else{
                                blockHandler(NO);
                            }
                        }];
                    }
                    else{
                        blockHandler(NO);
                    }
                }];
            }
        }];
    }
}

#pragma mark -
- (void) dialogForName:(NSString *)dialogName completionHandler:(void(^)(QBChatDialog *chatDialog))blockHandler {
    NSMutableDictionary *extendedRequest = @{@"name" : dialogName}.mutableCopy;
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:10 skip:0];
    
    [QBRequest dialogsForPage:page extendedRequest:extendedRequest successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
        
        if(dialogObjects.count > 0)
            blockHandler(dialogObjects[0]);
        else
            blockHandler(nil);
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"dialogsForPage errorBlock: %@", response.error.debugDescription);
        blockHandler(nil);
    }];
}

- (void) createDialogWithName:(NSString *)dialogName completionHandler:(void(^)(QBChatDialog *chatDialog))blockHandler {
    QBChatDialog *chatDialog = [QBChatDialog new];
    chatDialog.name = dialogName;
    chatDialog.type = QBChatDialogTypePublicGroup;
    
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        NSLog(@"createDialog: %@", createdDialog);
        blockHandler(createdDialog);
    } errorBlock:^(QBResponse *response) {
        NSLog(@"createDialog errorBlock: %@", response.error.debugDescription);
        blockHandler(nil);
    }];
}

- (void) joinToDialog:(QBChatDialog *)chatDialog completionHandler:(void(^)(BOOL isJioned))blockHandler {
    if(!chatDialog.isJoined){
        [chatDialog setOnJoin:^() {
            blockHandler(YES);
        }];
        
        [chatDialog setOnJoinFailed:^(NSError *error) {
            blockHandler(NO);
        }];
        
        [chatDialog setOnLeave:^{
            NSLog(@"QBChatDialog: Leave");
        }];
        
        if(![chatDialog join])
            blockHandler(NO);
    }
    else{
        blockHandler(YES);
    }
}

- (void) messagesForDialog:(QBChatDialog *)chatDialog completionHandler:(void(^)(NSArray *chatMessages))blockHandler {
    NSMutableDictionary *extendedRequest = @{@"sort_asc" : @"date_sent"}.mutableCopy;
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:1000 skip:0];
    
    [QBRequest messagesWithDialogID:chatDialog.ID extendedRequest:extendedRequest forPage:page successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *responcePage) {
        NSLog(@"messagesWithDialogID: OK");
        blockHandler(messages);
    } errorBlock:^(QBResponse *response) {
        NSLog(@"messagesWithDialogID: %@", response.error);
        blockHandler(nil);
    }];
}

- (BOOL) sendMessage:(NSString *)msg toChat:(QBChatDialog *)chat withParams:(NSMutableDictionary *)params {
    QBChatMessage *message = [QBChatMessage message];
    [message setText:msg];
    
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    /*
    [chat sendMessage:message sentBlock:^(NSError *error) {
        if(error == nil){
            // message is sent
        }else{
            // message wasn't delivered, try to resend it
        }
    }];
    */
    
    return [chat sendMessage:message];
}

#pragma mark -
- (NSMutableArray *) qbChatMessagesToAppFormat:(NSArray *)chatMessages {
    NSMutableArray *gameMessages = [NSMutableArray new];
    
    NSDate *lastMessageDate;
    NSMutableArray *messagesOfDay;
    
    for(QBChatMessage *message in chatMessages){
        ChatMessage *appMsg = [self qbChatMessageToAppFormat:message];
        
        if(lastMessageDate == nil){ // first item/message
            messagesOfDay = [NSMutableArray new];
            [gameMessages addObject:messagesOfDay];
        }
        else{
            if(![message.dateSent isEqualToDateIgnoringTime:lastMessageDate]){ // new day
                messagesOfDay = [NSMutableArray new];
                [gameMessages addObject:messagesOfDay];
            }
        }
        
        lastMessageDate = message.dateSent;
        
        [messagesOfDay addObject:appMsg];
    }
    
    return gameMessages;
}

- (ChatMessage *)qbChatMessageToAppFormat:(QBChatMessage *)message {
    ChatMessage *gameMsg = [ChatMessage new];
    gameMsg.message = message.text;
    gameMsg.time = [message.dateSent toFormat:@"HH:mm"];
    gameMsg.fullDate = message.dateSent;
    
    if(![message.customParameters[@"app_user_id"] isKindOfClass:[NSNull class]])
        gameMsg.userId = [message.customParameters[@"app_user_id"] integerValue];
    
    if(![message.customParameters[@"app_user_name"] isKindOfClass:[NSNull class]])
        gameMsg.userName = message.customParameters[@"app_user_name"];
    
    if(![message.customParameters[@"app_user_avatar"] isKindOfClass:[NSNull class]])
        gameMsg.avatarLink = message.customParameters[@"app_user_avatar"];
    
    return gameMsg;
}

#pragma mark -
#pragma mark QBChatDelegate
-(void) chatDidLogin{
    NSLog(@"chatDidLogin");
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
}

- (void)chatDidNotLoginWithError:(NSError *)error {
    NSLog(@"chatDidNotLoginWithError: %@", error.debugDescription);
}

- (void)chatDidConnect {
    NSLog(@"chatDidConnect");
}

- (void)chatDidAccidentallyDisconnect {
    NSLog(@"chatDidAccidentallyDisconnect");
}

#pragma mark -
#pragma mark Private chat message
- (void)chatDidReceiveMessage:(QBChatMessage *)message {
    NSLog(@"chatDidReceiveMessage: %@", message.text);
}

- (void)chatDidNotSendMessage:(QBChatMessage *)message error:(NSError *)error {
    NSLog(@"chatDidNotSendMessage: %@", error.debugDescription);
}

#pragma mark -
#pragma mark Group chat message
- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJid {
    NSLog(@"chatRoomDidReceiveMessage: %@", message.text);
    NSLog(@"RoomJID: %@", roomJid);
    
    if([lastUsedChatDialog.roomJID isEqualToString:roomJid]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(appChatDidReceiveMessage:)]){
            ChatMessage *appMsg = [self qbChatMessageToAppFormat:message];
            [self.delegate appChatDidReceiveMessage:appMsg];
        }
    }
}

- (void)chatDidNotSendMessage:(QBChatMessage *)message toRoomJid:(NSString *)roomJid error:(NSError *)error {
    NSLog(@"chatDidNotSendMessage: %@", error.debugDescription);
    NSLog(@"RoomJID: %@", roomJid);
}

@end
