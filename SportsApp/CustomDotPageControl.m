//
//  CustomDotPageControl.m
//  SportsApp
//
//  Created by sergeyZ on 04.06.15.
//
//

#import "CustomDotPageControl.h"

@implementation CustomDotPageControl {
    UIImage *dotActiveImage;
    UIImage *dotInactiveImage;
}

- (void) setDotImageActive:(UIImage*)image {
    dotActiveImage = image;
}

- (void) setDotImageInactive:(UIImage*)image {
    dotInactiveImage = image;
}

// overide the setCurrentPage
-(void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    for (UIView* dot in self.subviews){
        CGRect f = dot.frame;
        
        //sets all the dots to be 5x5
        f.size = CGSizeMake(5, 5);
        
        //need to reposition vertically as the dots get repositioned when selected
        f.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(f)/2;
        dot.frame = f;
        
        //update the cornerRadius to be sure that they are perfect circles
        dot.layer.cornerRadius = CGRectGetWidth(f)/2;
    }
}

-(void) updateDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *dotView = [self.subviews objectAtIndex:i];
        if ([dotView isKindOfClass:[UIImageView class]]) {
            UIImageView* dot = (UIImageView*)dotView;
            dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, dotActiveImage.size.width, dotActiveImage.size.height);
            if (i == self.currentPage)
                dot.image = dotActiveImage;
            else
                dot.image = dotInactiveImage;
        }
        else {
            dotView.frame = CGRectMake(dotView.frame.origin.x, dotView.frame.origin.y, dotActiveImage.size.width, dotActiveImage.size.height);
            if (i == self.currentPage)
                [dotView setBackgroundColor:[UIColor colorWithPatternImage:dotActiveImage]];
            else
                [dotView setBackgroundColor:[UIColor colorWithPatternImage:dotInactiveImage]];
        }
    }
}

-(void) updateDots2 {
    for (int i = 0; i < [self.subviews count]; i++){
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage)
        {
            if(dotActiveImage)
                dot.image = dotActiveImage;
        }
        else
        {
            if (dotInactiveImage)
                dot.image = dotInactiveImage;
        }
    }
}

-(void) updateDots3 {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImage *customDotImage = (i == self.currentPage) ? dotActiveImage : dotInactiveImage;
        UIView *dotView = [self.subviews objectAtIndex:i];
        dotView.frame = CGRectMake(dotView.frame.origin.x, dotView.frame.origin.y, customDotImage.size.width, customDotImage.size.height);
        if ([dotView isKindOfClass:[UIImageView class]]) { // in iOS 6, UIPageControl contains UIImageViews
            ((UIImageView *)dotView).image = customDotImage;
        }
        else { // in iOS 7, UIPageControl contains normal UIViews
            dotView.backgroundColor = [UIColor colorWithPatternImage:customDotImage];
        }
    }
}

@end
