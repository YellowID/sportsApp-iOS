//
//  PlaceSearchViewController.h
//  SportsApp
//
//  Created by sergeyZ on 29.05.15.
//
//

#import <UIKit/UIKit.h>
#import "FoursquareResponse.h"

@protocol PlaceSearchViewControllerDelegate;

@interface PlaceSearchViewController : UIViewController

@property (weak, nonatomic) id <PlaceSearchViewControllerDelegate> delegate;

@end

@protocol PlaceSearchViewControllerDelegate <NSObject>
- (void)gamePlaceDidChanged:(PlaceSearchViewController *)controller place:(FoursquareResponse *)placeLocation;
@end