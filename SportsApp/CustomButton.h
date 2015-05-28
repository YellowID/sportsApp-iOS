//
//  ToggleButton.h
//  SportsApp
//
//  Created by sergeyZ on 28.05.15.
//
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

- (void) setBackgrounColor:(UIColor*)color forState:(UIControlState)state;
- (void) setBorderColor:(UIColor*)color forState:(UIControlState)state;

@end
