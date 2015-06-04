//
//  ChatTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 04.06.15.
//
//

#import "ChatTableViewCell.h"

#define PADDING_TOP 12
#define PADDING_BOTTOM 12
#define PADDING_LEFT 12
#define PADDING_RIGHT 12

#define SMALL_LABLE_HEIGHT 10

@implementation ChatTableViewCell {
    UIView *messageView;
    UIImageView *backgroundCallout;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _ivPhoto = [UIImageView new];
        _ivPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_ivPhoto];
        
        messageView = [UIView new];
        messageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:messageView];
        
        backgroundCallout = [UIImageView new];
        backgroundCallout.translatesAutoresizingMaskIntoConstraints = NO;
        [messageView addSubview:backgroundCallout];
        
        _userNameLabel = [UILabel new];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [messageView addSubview:_userNameLabel];
        //_userNameLabel.backgroundColor = [UIColor greenColor];
        
        _userMessageLabel = [UILabel new];
        _userMessageLabel.font = [UIFont systemFontOfSize:16.0f];
        [_userMessageLabel sizeToFit];
        _userMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [messageView addSubview:_userMessageLabel];
        //_userMessageLabel.backgroundColor = [UIColor greenColor];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
        [_timeLabel sizeToFit];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [messageView addSubview:_timeLabel];
        //_timeLabel.backgroundColor = [UIColor greenColor];
        
        
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutPhoto];
    [self layoutMessageView];
}

- (void) setBackgroundImageForMessageView:(UIImage *)backgroundImage {
    /*
    UIGraphicsBeginImageContext(messageView.frame.size);
    [backgroundImage drawInRect:messageView.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = messageView.layer.bounds;
    backgroundLayer.backgroundColor = [UIColor colorWithPatternImage:bgImage].CGColor;
    [backgroundLayer setTransform:CATransform3DMakeScale(1.0, -1.0, 1.0)];
    [[messageView layer] insertSublayer:backgroundLayer atIndex:0]; // send sublayer to back
    */
    
    //UIImage *stretchableImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *stretchableImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    //[messageView setBackgroundColor:[UIColor colorWithPatternImage:stretchableImage]];
    
    backgroundCallout.image = stretchableImage;
}

- (void) layoutPhoto {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivPhoto
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivPhoto
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [_ivPhoto addConstraint: [NSLayoutConstraint constraintWithItem:_ivPhoto
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:40]];
    
    [_ivPhoto addConstraint: [NSLayoutConstraint constraintWithItem:_ivPhoto
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:40]];
}

- (void) layoutMessageView {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:messageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:_ivPhoto
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    
    [messageView addConstraint: [NSLayoutConstraint constraintWithItem:messageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:200]];
    
    [messageView addConstraint: [NSLayoutConstraint constraintWithItem:messageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:80]];
    [self layoutBackgoundImage];
    [self layoutUserNameLabel];
    [self layoutMessageLabel];
    [self layoutTimeLabel];
}

- (void) layoutBackgoundImage {
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundCallout
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:0
                                                               toItem:messageView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundCallout
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:0
                                                               toItem:messageView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0]];
    
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundCallout
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:0
                                                               toItem:messageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0]];
    
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundCallout
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:0
                                                               toItem:messageView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0]];
}

- (void) layoutUserNameLabel {
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:messageView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:messageView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [_userNameLabel addConstraint: [NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:0
                                                                   toItem:nil
                                                                attribute:0
                                                               multiplier:1
                                                                 constant:18]];
}

- (void) layoutMessageLabel {
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userMessageLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:0
                                                               toItem:_userNameLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:1]];
    
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userMessageLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:0
                                                               toItem:messageView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:PADDING_LEFT]];
    
    [_userMessageLabel addConstraint: [NSLayoutConstraint constraintWithItem:_userMessageLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:0
                                                                   toItem:nil
                                                                attribute:0
                                                               multiplier:1
                                                                 constant:60]];
}

- (void) layoutTimeLabel {
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:0
                                                               toItem:_userMessageLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:1]];
    
    [messageView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:0
                                                               toItem:messageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:PADDING_RIGHT]];
    
    [_timeLabel addConstraint: [NSLayoutConstraint constraintWithItem:_timeLabel
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:0
                                                                      toItem:nil
                                                                   attribute:0
                                                                  multiplier:1
                                                                    constant:14]];
}

@end





















