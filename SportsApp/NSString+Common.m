//
//  NSString+Common.m
//  SportsApp
//
//  Created by sergeyZ on 27.05.15.
//  Copyright (c) 2015 srgzah. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (BOOL) isEmpty {
    return [[self trimWhitespace] isEqualToString:@""];
}

- (BOOL) contains:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    return (range.location != NSNotFound);
}

- (BOOL) containsCaseInsensitive:(NSString*)str {
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch];
    return (range.location != NSNotFound);
}

- (NSString*) trimWhitespace {
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*) trimByCharacters:(NSString*)chars {
    NSMutableCharacterSet *characters = [NSMutableCharacterSet new];
    [characters addCharactersInString:chars];
    return [self stringByTrimmingCharactersInSet: characters];
}

- (NSString*) removeSubstring:(NSString*)substr {
    return [self stringByReplacingOccurrencesOfString:substr withString:@""];
}

- (NSString*) removeMultipleSymbols:(NSString*)symbol {
    NSString* patern = [NSString stringWithFormat:@"%@%@+", symbol, symbol];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patern
                                                                           options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:symbol];
}

- (NSString*) removeSuffixFromFirstOccurrencesOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    if(range.location != NSNotFound)
        return [self substringToIndex:range.location];
    
    return self;
}

- (NSString*) removeSuffixFromFirstOccurrencesOfCaseInsensitiveString:(NSString*)str {
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch];
    if(range.location != NSNotFound)
        return [self substringToIndex:range.location];
    
    return self;
}

@end


















