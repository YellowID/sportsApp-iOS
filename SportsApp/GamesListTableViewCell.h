//
//  GamesListTableViewCell.h
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import <UIKit/UIKit.h>

@interface GamesListTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* gameNameLabel;
@property (strong, nonatomic) UILabel* addressLabel;
@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UILabel* dateLabel;

@property (strong, nonatomic) UIImageView* ivAdmin;
@property (strong, nonatomic) UIImageView* ivStatus;
@property (strong, nonatomic) UIImageView* ivLocation;
@property (strong, nonatomic) UIImageView* ivTime;
@property (strong, nonatomic) UIImageView* ivDate;

- (void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

- (void) setTopPadding:(CGFloat)padding;
- (void) setBottomPadding:(CGFloat)padding;

@end
