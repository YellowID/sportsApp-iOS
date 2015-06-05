//
//  NSLayoutConstraint+Helper.m
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import "NSLayoutConstraint+Helper.h"

@implementation NSLayoutConstraint (Helper)

+ (NSLayoutConstraint*) setWidht:(CGFloat)w forView:(UIView*)view {
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:w];
    [view addConstraint: constraint];
    return constraint;
}

+ (NSLayoutConstraint*) setHeight:(CGFloat)h forView:(UIView*)view {
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:h];
    
    [view addConstraint: constraint];
    return constraint;
}

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

+ (void) centerVertical:(UIView*)view withView:(UIView*)anchorView inContainer:(UIView*)container {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:0
                                                             toItem:anchorView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
}

+ (void) stretch:(UIView*)view inContainer:(UIView*)container {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
}

+ (void) stretchHorizontal:(UIView*)view inContainer:(UIView*)container {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
}

+ (void) stretchVertical:(UIView*)view inContainer:(UIView*)container {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
}

+ (void) alignBottom:(UIView*)view inContainer:(UIView*)container {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
}

@end
