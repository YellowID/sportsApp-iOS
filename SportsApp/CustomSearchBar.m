//
//  CustomSearchBar.m
//  SportsApp
//
//  Created by sergeyZ on 27.05.15.
//
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

- (void) layoutSubviews {
    [super layoutSubviews];
    
    for (UIView* subView in self.subviews) {
        for (UIView* secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]]){
                UITextField *tf = (UITextField *)secondLevelSubview;
                
                CGRect frame = tf.frame;
                frame.size.height = 34;
                tf.frame = frame;
                tf.center = subView.center;
                
                break;
            }
        }
    }
}

- (void) setTextColorTF:(UIColor*)color {
    UITextField* tf = [self srchField];
    tf.textColor = color;
}

- (void) setBackgroundColorTF:(UIColor*)color {
    UITextField* tf = [self srchField];
    tf.backgroundColor = color;
}

- (UITextField*) srchField {
    for (UIView* subView in self.subviews) {
        for (UIView* secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]]){
                return (UITextField *)secondLevelSubview;
            }
        }
    }
    
    return nil;
}

@end
