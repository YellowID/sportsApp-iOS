//
//  ChatTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 04.06.15.
//
//

#import "ChatTableViewCell.h"

#define PADDING_TOP 14
#define PADDING_BOTTOM 14
#define PADDING_LEFT 14
#define PADDING_RIGHT 60

#define CONTENT_PADDING_TOP 8
#define CONTENT_PADDING_BOTTOM 8
#define CONTENT_PADDING_LEFT 14
#define CONTENT_PADDING_RIGHT 12

#define NAME_FONT_SIZE 14.0f
#define MSG_FONT_SIZE 18.0f
#define TIME_FONT_SIZE 12.0f

#define USERNAME_LABLE_HEIGHT 15
#define TIME_LABLE_HEIGHT 15

#define PHOTO_SIZE 40

@implementation ChatTableViewCell

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
        
        _messageView = [UIView new];
        _messageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_messageView];
        
        _backgroundCallout = [UIImageView new];
        _backgroundCallout.translatesAutoresizingMaskIntoConstraints = NO;
        [_messageView addSubview:_backgroundCallout];
         //backgroundCallout.backgroundColor = [UIColor blueColor];
        
        _userNameLabel = [UILabel new];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:NAME_FONT_SIZE];
        _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_messageView addSubview:_userNameLabel];
        //_userNameLabel.backgroundColor = [UIColor greenColor];
        
        _userMessage = [UITextView new];
        _userMessage.translatesAutoresizingMaskIntoConstraints = NO;
        _userMessage.editable = NO;
        _userMessage.scrollEnabled = NO;
        _userMessage.textAlignment = NSTextAlignmentLeft;
        _userMessage.dataDetectorTypes = UIDataDetectorTypeAll;
        [_userMessage setBackgroundColor:[UIColor clearColor]];
        [_userMessage setFont:[UIFont systemFontOfSize:MSG_FONT_SIZE]];
        [_messageView addSubview:_userMessage];
         //_userMessage.backgroundColor = [UIColor greenColor];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        [_timeLabel sizeToFit];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_messageView addSubview:_timeLabel];
        //_timeLabel.backgroundColor = [UIColor greenColor];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutPhoto];
    [self layoutMessageView];
}

+ (CGFloat) heightRowForMessage:(NSString*)message andWidth:(CGFloat)cellWidth {
    UITextView *tv = [UITextView new];
    tv.textAlignment = NSTextAlignmentLeft;
    [tv setFont:[UIFont systemFontOfSize:MSG_FONT_SIZE + 1]];
    tv.text = message;
    
    CGFloat contentWidth = cellWidth - PADDING_LEFT - PHOTO_SIZE - PADDING_RIGHT;
    CGSize newSize = [tv sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
    
    CGFloat cellHeight = newSize.height + PADDING_TOP + PADDING_BOTTOM + CONTENT_PADDING_TOP + CONTENT_PADDING_BOTTOM + USERNAME_LABLE_HEIGHT + TIME_LABLE_HEIGHT;
    
    return cellHeight;
}

- (void) setBackgroundImageForMessageView:(UIImage *)backgroundImage {
    UIImage *stretchableImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    _backgroundCallout.image = stretchableImage;
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
                                                            constant:PHOTO_SIZE]];
    
    [_ivPhoto addConstraint: [NSLayoutConstraint constraintWithItem:_ivPhoto
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:PHOTO_SIZE]];
}

- (void) layoutMessageView {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:_ivPhoto
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:0
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-PADDING_RIGHT]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:0
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:-PADDING_BOTTOM]];
    
    [self layoutBackgoundImage];
    [self layoutUserNameLabel];
    [self layoutMessageLabel];
    [self layoutTimeLabel];
}

- (void) layoutBackgoundImage {
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundCallout
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundCallout
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundCallout
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundCallout
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0]];
}

- (void) layoutUserNameLabel {
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:_messageView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:CONTENT_PADDING_TOP]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:_messageView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:CONTENT_PADDING_LEFT]];
    
    [_messageView addConstraint: [NSLayoutConstraint constraintWithItem:_userNameLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:0
                                                                   toItem:nil
                                                                attribute:0
                                                               multiplier:1
                                                                 constant:USERNAME_LABLE_HEIGHT]];
}

- (void) layoutMessageLabel {
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userMessage
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:0
                                                               toItem:_userNameLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:1]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userMessage
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:CONTENT_PADDING_LEFT]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userMessage
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-CONTENT_PADDING_RIGHT]];
}

- (void) layoutTimeLabel {
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:-CONTENT_PADDING_BOTTOM]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:0
                                                               toItem:_userMessage
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:1]];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:0
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-CONTENT_PADDING_RIGHT]];
    
    [_timeLabel addConstraint: [NSLayoutConstraint constraintWithItem:_timeLabel
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:0
                                                                      toItem:nil
                                                                   attribute:0
                                                                  multiplier:1
                                                                    constant:TIME_LABLE_HEIGHT]];
}

@end





















