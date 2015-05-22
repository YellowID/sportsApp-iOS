//
//  GamesListTableViewCell.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <UIKit/UIKit.h>

@interface GamesListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* gameNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* addressLabel;
@property (strong, nonatomic) IBOutlet UILabel* timeLabel;
@property (strong, nonatomic) IBOutlet UILabel* dateLabel;

@property (strong, nonatomic) IBOutlet UIImageView* ivAdmin;
@property (strong, nonatomic) IBOutlet UIImageView* ivStatus;
@property (strong, nonatomic) IBOutlet UIImageView* ivLocation;
@property (strong, nonatomic) IBOutlet UIImageView* ivTime;
@property (strong, nonatomic) IBOutlet UIImageView* ivDate;

@end
