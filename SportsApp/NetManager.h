//
//  NetHelper.h
//
//  Created by sergeyZ on 23.12.14.
//  Copyright (c) 2014 srgzah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

+(BOOL)isInternetAvaliable;

+ (void) sendGet:(NSString *)urlString withParams:(NSDictionary *)params completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))blockHandler;

+ (void) sendPostMultipartFormData:(NSString *)urlString withParams:(NSDictionary *)params completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))blockHandler;

+ (void) sendPostJson:(NSString *)urlString withJSONObject:(id)jsonObject completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))blockHandler;

@end
