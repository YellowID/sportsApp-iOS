//
//  AddressSearchViewController.h
//  SportsApp
//
//  Created by sergeyZ on 23.06.15.
//
//

#import <UIKit/UIKit.h>
#import "YandexGeoResponse.h"

@protocol AddressSearchViewControllerDelegate;

@interface AddressSearchViewController : UIViewController

@property (weak, nonatomic) id <AddressSearchViewControllerDelegate> delegate;

@end

@protocol AddressSearchViewControllerDelegate <NSObject>
- (void)addressDidChanged:(AddressSearchViewController *)controller place:(YandexGeoResponse *)address;
@end