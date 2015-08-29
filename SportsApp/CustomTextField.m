//
//  CustomTextField.m
//  SportsApp
//
//  Created by sergeyZ on 27.08.15.
//
//

#import "CustomTextField.h"

@implementation CustomTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGFloat padding = self.rightView.frame.size.width;
    return CGRectInset( bounds , padding+10 , 10 );
}

@end
