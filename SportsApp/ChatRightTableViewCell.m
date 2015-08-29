//
//  ChatRightTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 05.06.15.
//
//

#import "ChatRightTableViewCell.h"

#define PADDING_TOP 8
#define PADDING_BOTTOM 8
#define PADDING_LEFT 60
#define PADDING_RIGHT 6

#define CONTENT_PADDING_TOP 3
#define CONTENT_PADDING_BOTTOM 6
#define CONTENT_PADDING_LEFT 9
#define CONTENT_PADDING_RIGHT 14

#define NAME_FONT_SIZE 12.0f
#define MSG_FONT_SIZE 14.0f
#define TIME_FONT_SIZE 10.0f

#define USERNAME_LABLE_HEIGHT 0
#define TIME_LABLE_HEIGHT 10

#define PHOTO_SIZE 40

@implementation ChatRightTableViewCell

+ (CGFloat) heightRowForMessage:(NSString*)message andWidth:(CGFloat)cellWidth showUserName:(BOOL)showUserName {
    UITextView *tv = [UITextView new];
    tv.textAlignment = NSTextAlignmentLeft;
    [tv setFont:[UIFont systemFontOfSize:MSG_FONT_SIZE + 1]];
    tv.textContainerInset = UIEdgeInsetsZero;
    tv.textContainer.lineFragmentPadding = 0;
    tv.text = message;
    
    CGFloat contentWidth = cellWidth - PADDING_LEFT - PHOTO_SIZE - PADDING_RIGHT;
    CGSize newSize = [tv sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
    CGFloat cellHeight = newSize.height + PADDING_TOP + PADDING_BOTTOM + CONTENT_PADDING_TOP + CONTENT_PADDING_BOTTOM + TIME_LABLE_HEIGHT;
    
    return cellHeight;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void) layoutPhoto {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ivPhoto
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.ivPhoto
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-PADDING_RIGHT]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.ivPhoto
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:PHOTO_SIZE]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.ivPhoto
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:PHOTO_SIZE]];
}

- (void) layoutMessageView {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:self.ivPhoto
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageView
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
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCallout
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCallout
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:0]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCallout
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCallout
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0]];
}

- (void) layoutUserNameLabel {
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:CONTENT_PADDING_TOP]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:CONTENT_PADDING_LEFT]];
    
    [self.messageView addConstraint: [NSLayoutConstraint constraintWithItem:self.userNameLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:0
                                                                 toItem:nil
                                                              attribute:0
                                                             multiplier:1
                                                               constant:USERNAME_LABLE_HEIGHT]];
}

- (void) layoutMessageLabel {
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.userMessage
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:self.userNameLabel
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:1]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.userMessage
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:CONTENT_PADDING_LEFT]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.userMessage
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:0 //NSLayoutRelationLessThanOrEqual
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-CONTENT_PADDING_RIGHT]];
}

- (void) layoutTimeLabel {
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:-CONTENT_PADDING_BOTTOM]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:0
                                                                toItem:self.userMessage
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:1]];
    
    [self.messageView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:0
                                                                toItem:self.messageView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-CONTENT_PADDING_RIGHT]];
    
    [self.timeLabel addConstraint: [NSLayoutConstraint constraintWithItem:self.timeLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:0
                                                               toItem:nil
                                                            attribute:0
                                                           multiplier:1
                                                             constant:TIME_LABLE_HEIGHT]];
}

@end






















