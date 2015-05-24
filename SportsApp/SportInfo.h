//
//  SportInfo.h
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SportInfo : NSObject

@property (copy, nonatomic) UIImage* activeImage;
@property (copy, nonatomic) UIImage* inactiveImage;
@property (copy, nonatomic) NSString* title;

@end
