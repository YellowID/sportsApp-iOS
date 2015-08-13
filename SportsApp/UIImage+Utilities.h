//
//  UIImage+Utilities.h
//  SportsApp
//
//  Created by sergeyZ on 05.08.15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

+ (UIImage *) imageForAvatar:(UIImage *)image;
+ (UIImage *) imageForAvatarDefault:(UIImage *)image text:(NSString *)text;

+ (UIImage *) imageForPlace:(UIImage *)image;

@end
