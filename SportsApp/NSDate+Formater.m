//
//  NSDate+Formater.m
//  SportsApp
//
//  Created by sergeyZ on 26.07.15.
//
//

#import "NSDate+Formater.h"

@implementation NSDate (Formater)

+ (NSDate *)dateWithJsonString:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    //[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"]; //2015-10-18T10:34:14.998Z
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"]; //2015-10-18T10:34:14.998Z
    
    //@"yyyy’-’MM’-’dd’T’HH’:’mm’:’ssZ"
    //2013-06-05T06:13:29+0000
    
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

- (NSString *)toJsonFormat {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    NSString *date_str = [dateFormat stringFromDate:self];
    return date_str;
}

- (NSString *)toFormat:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    
    NSString *date_str = [dateFormat stringFromDate:self];
    return date_str;
}



@end
