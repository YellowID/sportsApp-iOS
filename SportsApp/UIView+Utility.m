//
//  UIView+Utility.m
//  SportsApp
//
//  Created by sergeyZ on 05.08.15.
//
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

+ (void) resizeToFitSubviews:(UIView *)v {
    float w = 0;
    float h = 0;
    for (UIView *sbv in [v subviews]) {
        float fw = sbv.frame.origin.x + sbv.frame.size.width;
        float fh = sbv.frame.origin.y + sbv.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, w, h)];
}

@end
