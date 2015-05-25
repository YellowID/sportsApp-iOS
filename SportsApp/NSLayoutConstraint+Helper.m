//
//  NSLayoutConstraint+Helper.m
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import "NSLayoutConstraint+Helper.h"

@implementation NSLayoutConstraint (Helper)

+ (void) setWidht:(CGFloat)w height:(CGFloat)h forView:(UIView*)view {
    [view addConstraint: [NSLayoutConstraint constraintWithItem:view
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:0
                                                         toItem:nil
                                                      attribute:0
                                                     multiplier:1
                                                       constant:w]];
    
    [view addConstraint: [NSLayoutConstraint constraintWithItem:view
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:0
                                                         toItem:nil
                                                      attribute:0
                                                     multiplier:1
                                                       constant:h]];
}

+ (void) centerHorizontal:(UIView*)view withView:(UIView*)anchorView inContainer:(UIView*)container {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:anchorView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
}

@end
