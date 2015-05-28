//
//  ToggleButton.m
//  SportsApp
//
//  Created by sergeyZ on 28.05.15.
//
//

#import "CustomButton.h"
 
@implementation CustomButton {
    UIColor* bgColorNormal;
    UIColor* bgColorSelected;
    UIColor* bgColorHighlighted;
    UIColor* bgColorDisabled;
    
    UIColor* borderColorNormal;
    UIColor* borderColorSelected;
    UIColor* borderColorHighlighted;
    UIColor* borderColorDisabled;
}

- (void) drawRect:(CGRect)rect {
    switch (self.state) {
        case UIControlStateNormal:
            self.layer.borderColor = [borderColorNormal CGColor];
            self.layer.backgroundColor = [bgColorNormal CGColor];
            break;
        case UIControlStateSelected:
            self.layer.borderColor = [borderColorSelected CGColor];
            self.layer.backgroundColor = [bgColorSelected CGColor];
            break;
        case UIControlStateHighlighted:
            self.layer.borderColor = [borderColorHighlighted CGColor];
            self.layer.backgroundColor = [bgColorHighlighted CGColor];
            break;
        case UIControlStateDisabled:
            self.layer.borderColor = [borderColorDisabled CGColor];
            self.layer.backgroundColor = [bgColorDisabled CGColor];
            break;
        default:
            break;
    }
    
    [super drawRect:rect];
}

- (void) setBackgrounColor:(UIColor*)color forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            bgColorNormal = color;
            break;
        case UIControlStateSelected:
            bgColorSelected = color;
            break;
        case UIControlStateHighlighted:
            bgColorHighlighted = color;
            break;
        case UIControlStateDisabled:
            bgColorDisabled = color;
            break;
        default:
            break;
    }
}

- (void) setBorderColor:(UIColor*)color forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            borderColorNormal = color;
            break;
        case UIControlStateSelected:
            borderColorSelected = color;
            break;
        case UIControlStateHighlighted:
            borderColorHighlighted = color;
            break;
        case UIControlStateDisabled:
            borderColorDisabled = color;
            break;
        default:
            break;
    }
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay]; // Force redraw of button
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay]; // Force redraw of button
}

@end
