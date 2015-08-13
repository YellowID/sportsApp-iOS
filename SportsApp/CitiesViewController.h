//
//  CitiesViewController.h
//  SportsApp
//
//  Created by sergeyZ on 05.08.15.
//
//

#import <UIKit/UIKit.h>

@protocol CitiesViewControllerDelegate;

@interface CitiesViewController : UIViewController

@property (weak, nonatomic) id <CitiesViewControllerDelegate> delegate;

@end

@protocol CitiesViewControllerDelegate <NSObject>
- (void)cityDidChanged:(CitiesViewController *)controller city:(NSString *)city;
@end