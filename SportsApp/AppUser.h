//
//  AppUser.h
//  SportsApp
//
//  Created by sergeyZ on 24.07.15.
//
//

#import <Foundation/Foundation.h>

@interface AppUser : NSObject

@property (nonatomic) NSUInteger uid;
@property (nonatomic) NSUInteger age;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *avatar;

@property (copy, nonatomic) NSString *provider;
@property (copy, nonatomic) NSString *oauthToken;
@property (copy, nonatomic) NSString *appToken;

@property (copy, nonatomic) NSString *chatLogin;
@property (copy, nonatomic) NSString *chatPassword;

@property (nonatomic) BOOL isNewUser;

@end
