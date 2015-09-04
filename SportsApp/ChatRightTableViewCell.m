//
//  ChatRightTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 05.06.15.
//
//

#import "ChatRightTableViewCell.h"
#import "NSLayoutConstraint+Helper.h"

static const CGFloat kPaddingTop = 8.0f;
static const CGFloat kPaddingBottom = 8.0f;
static const CGFloat kPaddingLeft = 60.0f;
static const CGFloat kPaddingRight = 6.0f;

static const CGFloat kPaddingContentTop = 3.0f;
static const CGFloat kPaddingContentBottom = 6.0f;
static const CGFloat kPaddingContentLeft = 9.0f;
static const CGFloat kPaddingContentRight = 14.0f;

static const CGFloat kUsernameLableHeight = 0.0f;
static const CGFloat kTimeLableHeight = 10.0f;
static const CGFloat kPhotoSize = 40.0f;

static const CGFloat kFontSizeMessage = 14.0f;


@implementation ChatRightTableViewCell

+ (CGFloat) heightRowForMessage:(NSString*)message andWidth:(CGFloat)cellWidth showUserName:(BOOL)showUserName {
    UITextView *tv = [UITextView new];
    tv.textAlignment = NSTextAlignmentLeft;
    [tv setFont:[UIFont systemFontOfSize:kFontSizeMessage + 1]];
    tv.textContainerInset = UIEdgeInsetsZero;
    tv.textContainer.lineFragmentPadding = 0;
    tv.text = message;
    
    CGFloat contentWidth = cellWidth - kPaddingLeft - kPhotoSize - kPaddingRight;
    CGSize newSize = [tv sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
    CGFloat cellHeight = newSize.height + kPaddingTop + kPaddingBottom + kPaddingContentTop + kPaddingContentBottom + kTimeLableHeight;
    
    return cellHeight;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void) layoutPhoto {
    [NSLayoutConstraint setWidht:kPhotoSize height:kPhotoSize forView:self.ivPhoto];
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:self.ivPhoto inContainer:self];
    [NSLayoutConstraint setRightPadding:kPaddingRight forView:self.ivPhoto inContainer:self];
}

- (void) layoutMessageView {
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:self.messageView inContainer:self];
    [NSLayoutConstraint setBottomPadding:kPaddingBottom forView:self.messageView inContainer:self];
    [NSLayoutConstraint setRightDistance:0 fromView:self.messageView toView:self.ivPhoto inContainer:self];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:kPaddingLeft]];
    
    [self layoutBackgoundImage];
    [self layoutUserNameLabel];
    [self layoutMessageLabel];
    [self layoutTimeLabel];
}

- (void) layoutBackgoundImage {
    [NSLayoutConstraint stretch:self.backgroundCallout inContainer:self.messageView withPadding:0];
}

- (void) layoutUserNameLabel {
    [NSLayoutConstraint setHeight:kUsernameLableHeight forView:self.userNameLabel];
    [NSLayoutConstraint setTopPadding:kPaddingContentTop forView:self.userNameLabel inContainer:self.messageView];
    [NSLayoutConstraint setLeftPadding:kPaddingContentLeft forView:self.userNameLabel inContainer:self.messageView];
}

- (void) layoutMessageLabel {
    [NSLayoutConstraint setLeftPadding:kPaddingContentLeft forView:self.userMessage inContainer:self.messageView];
    [NSLayoutConstraint setRightPadding:kPaddingContentRight forView:self.userMessage inContainer:self.messageView];
    [NSLayoutConstraint setTopDistance:1 fromView:self.userMessage toView:self.userNameLabel inContainer:self.messageView];
}

- (void) layoutTimeLabel {
    [NSLayoutConstraint setHeight:kTimeLableHeight forView:self.timeLabel];
    [NSLayoutConstraint setBottomPadding:kPaddingContentBottom forView:self.timeLabel inContainer:self.messageView];
    [NSLayoutConstraint setRightPadding:kPaddingContentRight forView:self.timeLabel inContainer:self.messageView];
    [NSLayoutConstraint setTopDistance:1 fromView:self.timeLabel toView:self.userMessage inContainer:self.messageView];
}

@end






















