//
//  NetHelper.m
//
//  Created by sergeyZ on 23.12.14.
//  Copyright (c) 2014 srgzah. All rights reserved.
//

#import "NetManager.h"
#import "Reachability.h"

@implementation NetManager

+ (void) sendGet:(NSString *)urlString withParams:(NSDictionary *)params completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))blockHandler {
    NSURL* url = nil;
    if(params){
        bool isFirstPair = YES;
        NSMutableString *paramsString = [NSMutableString new];
        for(NSString *key in [params allKeys]){
            NSString *value = [params objectForKey:key];
            
            if(isFirstPair){
                isFirstPair = NO;
                [paramsString appendFormat:@"%@=%@", key, value];
            }
            else{
                [paramsString appendFormat:@"&%@=%@", key, value];
            }
        }
        
        NSString *str_url = [NSString stringWithFormat:@"%@&%@", urlString, paramsString];
        url = [NSURL URLWithString:[str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        //url = [NSURL URLWithString:urlString];
        url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task =[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil)
            blockHandler(data, response, error);
    }];
    [task resume];
}

+ (void) sendPostJson:(NSString *)urlString withJSONObject:(id)jsonObject completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))blockHandler {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil)
            blockHandler(data, response, error);
    }];
    
    [postDataTask resume];
}

+ (void) sendPostMultipartFormData:(NSString *)urlString withParams:(NSDictionary *)params completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))blockHandler {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----Asrf456BGe4h---------------";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urlRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    if(params){
        NSMutableData *body = [NetManager dictionaryToPostBody:params withBoundary:boundary];
        [urlRequest setHTTPBody:body];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    }
    
    NSURLSessionDataTask *task = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(blockHandler != nil)
            blockHandler(data, response, error);
    }];
    [task resume];
}

+ (NSMutableData *) dictionaryToPostBody:(NSDictionary *)params withBoundary:(NSString *)boundary {
    NSMutableData *body = [NSMutableData data];
    NSMutableDictionary *images = [NSMutableDictionary new];
    
    for(NSString *key in [params allKeys]){
        id value = [params objectForKey:key];
        
        if([value isKindOfClass:[NSData class]]){
            [images setValue:value forKey:key];
        }
        else {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    for(NSString *key in [images allKeys]){
        NSData *imageData = [images objectForKey:key];
        
        if(imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

/**/
+(BOOL)isInternetAvaliable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


@end
