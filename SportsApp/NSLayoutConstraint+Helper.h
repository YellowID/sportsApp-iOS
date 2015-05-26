//
//  NSLayoutConstraint+Helper.h
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Helper)

+ (void) setWidht:(CGFloat)w forView:(UIView*)view;
+ (void) setHeight:(CGFloat)w forView:(UIView*)view;
+ (void) setWidht:(CGFloat)w height:(CGFloat)h forView:(UIView*)view;
+ (void) centerHorizontal:(UIView*)view withView:(UIView*)anchorView inContainer:(UIView*)container;
+ (void) centerVertical:(UIView*)view withView:(UIView*)anchorView inContainer:(UIView*)container;
@end
