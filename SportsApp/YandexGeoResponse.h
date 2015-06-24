//
//  AppGeoAddress.h
//  SportsApp
//
//  Created by sergeyZ on 24.06.15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YandexGeoResponse : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *descr;

@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lng;

@end
