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
@property (strong, nonatomic) UITextView *userMessage;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIView *messageView;
@property (strong, nonatomic) UIImageView *backgroundCallout;

- (void) setBackgroundImageForMessageView:(UIImage *)backgroundImage;
+ (CGFloat) heightRowForMessage:(NSString*)message andWidth:(CGFloat)width;

@end
