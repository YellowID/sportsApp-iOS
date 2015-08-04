//
//  NSDate+Formater.h
//  SportsApp
//
//  Created by sergeyZ on 26.07.15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Formater)

+ (NSDate *)dateWithJsonString:(NSString *)dateString;
- (NSString *)toJsonFormat;
- (NSString *)toFormat:(NSString *)format;

@end
