//
//  NSLayoutConstraint+Helper.h
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Helper)

+ (NSLayoutConstraint*) setWidht:(CGFloat)w forView:(UIView*)view;
+ (NSLayoutConstraint*) setHeight:(CGFloat)w forView:(UIView*)view;
+ (void) setWidht:(CGFloat)w height:(CGFloat)h forView:(UIView*)view;
+ (void) centerHorizontal:(UIView*)view withView:(UIView*)anchorView inContainer:(UIView*)container;
+ (void) centerVertical:(UIView*)view withView:(UIView*)anchorView inContainer:(UIView*)container;

+ (void) stretch:(UIView*)view inContainer:(UIView*)container;
+ (void) stretchHorizontal:(UIView*)view inContainer:(UIView*)container;
+ (void) stretchVertical:(UIView*)view inContainer:(UIView*)container;

+ (void) alignBottom:(UIView*)view inContainer:(UIView*)container withPadding:(CGFloat)padding;
@end
