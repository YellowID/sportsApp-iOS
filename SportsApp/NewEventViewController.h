//
//  NewEventViewController.h
//  SportsApp
//
//  Created by sergeyZ on 21.05.15.
//
//

#import <UIKit/UIKit.h>

@interface NewEventViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView* fielsGroupView;
@property (strong, nonatomic) IBOutlet UIView* timeGroupView;
@property (strong, nonatomic) IBOutlet UIView* gamerGroupView;

@property (strong, nonatomic) IBOutlet UITextField* tfKindOfSport;
@property (strong, nonatomic) IBOutlet UITextField* tfLocation;

@property (strong, nonatomic) IBOutlet UILabel* lblTime;

@property (strong, nonatomic) IBOutlet UIImageView* ivOneStar;
@property (strong, nonatomic) IBOutlet UIImageView* ivTwoStar;
@property (strong, nonatomic) IBOutlet UIImageView* ivThreeStar;

@end
