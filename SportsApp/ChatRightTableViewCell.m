//
//  ChatRightTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 05.06.15.
//
//

#import "ChatRightTableViewCell.h"
#import "NSLayoutConstraint+Helper.h"

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
    [NSLayoutConstraint setWidht:PHOTO_SIZE height:PHOTO_SIZE forView:self.ivPhoto];
    [NSLayoutConstraint setTopPadding:PADDING_TOP forView:self.ivPhoto inContainer:self];
    [NSLayoutConstraint setRightPadding:PADDING_RIGHT forView:self.ivPhoto inContainer:self];
}

- (void) layoutMessageView {
    [NSLayoutConstraint setTopPadding:PADDING_TOP forView:self.messageView inContainer:self];
    [NSLayoutConstraint setBottomPadding:PADDING_BOTTOM forView:self.messageView inContainer:self];
    [NSLayoutConstraint setRightDistance:0 fromView:self.messageView toView:self.ivPhoto inContainer:self];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [self layoutBackgoundImage];
    [self layoutUserNameLabel];
    [self layoutMessageLabel];
    [self layoutTimeLabel];
}

- (void) layoutBackgoundImage {
    [NSLayoutConstraint stretch:self.backgroundCallout inContainer:self.messageView withPadding:0];
}

- (void) layoutUserNameLabel {
    [NSLayoutConstraint setHeight:USERNAME_LABLE_HEIGHT forView:self.userNameLabel];
    [NSLayoutConstraint setTopPadding:CONTENT_PADDING_TOP forView:self.userNameLabel inContainer:self.messageView];
    [NSLayoutConstraint setLeftPadding:CONTENT_PADDING_LEFT forView:self.userNameLabel inContainer:self.messageView];
}

- (void) layoutMessageLabel {
    [NSLayoutConstraint setLeftPadding:CONTENT_PADDING_LEFT forView:self.userMessage inContainer:self.messageView];
    [NSLayoutConstraint setRightPadding:CONTENT_PADDING_RIGHT forView:self.userMessage inContainer:self.messageView];
    [NSLayoutConstraint setTopDistance:1 fromView:self.userMessage toView:self.userNameLabel inContainer:self.messageView];
}

- (void) layoutTimeLabel {
    [NSLayoutConstraint setHeight:TIME_LABLE_HEIGHT forView:self.timeLabel];
    [NSLayoutConstraint setBottomPadding:CONTENT_PADDING_BOTTOM forView:self.timeLabel inContainer:self.messageView];
    [NSLayoutConstraint setRightPadding:CONTENT_PADDING_RIGHT forView:self.timeLabel inContainer:self.messageView];
    [NSLayoutConstraint setTopDistance:1 fromView:self.timeLabel toView:self.userMessage inContainer:self.messageView];
}

@end






















