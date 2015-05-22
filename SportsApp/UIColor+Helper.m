//
//  UIColor+Helper.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//  Copyright (c) 2015 srgzah. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)
+ (UIColor *)colorWithRGBA:(NSUInteger)color
{
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}
@end
