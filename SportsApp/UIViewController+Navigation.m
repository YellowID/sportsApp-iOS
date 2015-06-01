//
//  UIViewController+Navigation.m
//  SportsApp
//
//  Created by sergeyZ on 31.05.15.
//
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

- (void) setNavTitle:(NSString*)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    //titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}

@end
