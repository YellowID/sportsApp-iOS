//
//  NSString+Common.h
//  SportsApp
//
//  Created by sergeyZ on 27.05.15.
//  Copyright (c) 2015 srgzah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

- (BOOL) isEmpty;
- (BOOL) contains:(NSString*)string;
- (BOOL) containsCaseInsensitive:(NSString*)str;

- (NSString*) removeSubstring:(NSString*)substr;
- (NSString*) trimWhitespace;
- (NSString*) trimByCharacters:(NSString*)chars;

- (NSString*) removeMultipleSymbols:(NSString*)symbol;
- (NSString*) removeSuffixFromFirstOccurrencesOfString:(NSString*)str;
- (NSString*) removeSuffixFromFirstOccurrencesOfCaseInsensitiveString:(NSString*)str;

- (BOOL) isValidEmail;

@end
