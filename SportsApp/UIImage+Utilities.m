//
//  UIImage+Utilities.m
//  SportsApp
//
//  Created by sergeyZ on 05.08.15.
//
//

#import "UIImage+Utilities.h"

#define PHOTO_SIZE 40
#define PLACE_ICON_SIZE 40

@implementation UIImage (Utilities)

#pragma mark -
+ (UIImage *) imageForPlace:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PLACE_ICON_SIZE, PLACE_ICON_SIZE), NO, 0);
    [image drawInRect:CGRectMake(0, 0, PLACE_ICON_SIZE, PLACE_ICON_SIZE)];
    
    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return avatar;
}


#pragma mark -
+ (UIImage *) imageForAvatar:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PHOTO_SIZE, PHOTO_SIZE), NO, 0);
    [image drawInRect:CGRectMake(0, 0, PHOTO_SIZE, PHOTO_SIZE)];
    
    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return avatar;
}

+ (UIImage *) imageForAvatarDefault:(UIImage *)image text:(NSString *)text {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(PHOTO_SIZE, PHOTO_SIZE), NO, 0);
    [image drawInRect:CGRectMake(0, 0, PHOTO_SIZE, PHOTO_SIZE)];
    
    NSString *avatarText = @"?";
    
    if(![text isKindOfClass:[NSNull class]] && text.length > 0){
        NSString *temp = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSArray *parts = [temp componentsSeparatedByString: @" "];
        
        if([parts count] > 0){
            NSString *str = parts[0];
            NSString *firstNameChar = (str.length > 1) ? [str substringToIndex:1] : @"";
            
            if([parts count] > 1){
                str = parts[1];
                //NSString *lastNameChar = [parts[1] substringToIndex:1];
                NSString *lastNameChar = (str.length > 1) ? [str substringToIndex:1] : @"";
                
                avatarText = [NSString stringWithFormat:@"%@%@", firstNameChar, lastNameChar];
            }
            else{
                avatarText = firstNameChar;
            }
        }
    }
    
    CGSize size = [avatarText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0f]}];
    CGFloat x = (PHOTO_SIZE - size.width) / 2;
    CGFloat y = (PHOTO_SIZE - size.height) / 2;
    CGRect textRect = CGRectMake(x, y, size.width, size.height);
    
    if([avatarText respondsToSelector:@selector(drawInRect:withAttributes:)]){
        //[[UIColor clearColor] setFill];
        //[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, PHOTO_SIZE, PHOTO_SIZE)] fill];
        
        NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [avatarText drawInRect:textRect withAttributes:att];
    }
    
    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return avatar;
}

@end
