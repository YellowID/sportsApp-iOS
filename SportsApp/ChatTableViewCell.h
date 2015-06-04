//
//  ChatTableViewCell.h
//  SportsApp
//
//  Created by sergeyZ on 04.06.15.
//
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *ivPhoto;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *userMessageLabel;
@property (strong, nonatomic) UILabel *timeLabel;

- (void) setBackgroundImageForMessageView:(UIImage *)backgroundImage;

@end
