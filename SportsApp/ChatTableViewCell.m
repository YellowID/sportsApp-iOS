//
//  ChatTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 04.06.15.
//
//

#import "ChatTableViewCell.h"
#import "NSLayoutConstraint+Helper.h"

static const CGFloat kPaddingTop = 8.0f;
static const CGFloat kPaddingBottom = 8.0f;
static const CGFloat kPaddingLeft = 6.0f;
static const CGFloat kPaddingRight = 60.0f;

static const CGFloat kPaddingContentTop = 3.0f;
static const CGFloat kPaddingContentBottom = 6.0f;
static const CGFloat kPaddingContentLeft = 14.0f;
static const CGFloat kPaddingContentRight = 9.0f;

static const CGFloat kPaddingMessageTop = 6.0f;

static const CGFloat kUsernameLableHeight = 13.0f;
static const CGFloat kTimeLableHeight = 10.0f;
static const CGFloat kPhotoSize = 40.0f;

static const CGFloat kFontSizeName = 12.0f;
static const CGFloat kFontSizeMessage = 14.0f;
static const CGFloat kFontSizeTime = 10.0f;


@implementation ChatTableViewCell {
    NSLayoutConstraint *userNameHeightConstraint;
    NSLayoutConstraint *userNamePaddingConstraint;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
        
        _userNameLabel = [UILabel new];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:kFontSizeName];
        _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_messageView addSubview:_userNameLabel];
        //_userNameLabel.backgroundColor = [UIColor greenColor];
        
        _userMessage = [UITextView new];
        _userMessage.translatesAutoresizingMaskIntoConstraints = NO;
        _userMessage.editable = NO;
        _userMessage.scrollEnabled = NO;
        _userMessage.textAlignment = NSTextAlignmentLeft;
        _userMessage.textContainerInset = UIEdgeInsetsZero;
        _userMessage.textContainer.lineFragmentPadding = 0;
        _userMessage.dataDetectorTypes = UIDataDetectorTypeAll;
        [_userMessage setBackgroundColor:[UIColor clearColor]];
        [_userMessage setFont:[UIFont systemFontOfSize:kFontSizeMessage]];
        [_messageView addSubview:_userMessage];
        //[_messageView sizeToFit];
        //_userMessage.backgroundColor = [UIColor greenColor];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:kFontSizeTime];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_messageView addSubview:_timeLabel];
        //_timeLabel.backgroundColor = [UIColor greenColor];
        
        [self layoutPhoto];
        [self layoutMessageView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateNameLabelConstraintsIfNeeded];
}

#pragma mark -
+ (CGFloat) heightRowForMessage:(NSString*)message andWidth:(CGFloat)cellWidth showUserName:(BOOL)showUserName {
    UITextView *tv = [UITextView new];
    tv.textAlignment = NSTextAlignmentLeft;
    [tv setFont:[UIFont systemFontOfSize:kFontSizeMessage + 1]];
    tv.textContainerInset = UIEdgeInsetsZero;
    tv.textContainer.lineFragmentPadding = 0;
    tv.text = message;
    
    CGFloat contentWidth = cellWidth - kPaddingLeft - kPhotoSize - kPaddingRight;
    CGSize newSize = [tv sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
    
    CGFloat cellHeight = 0;
    if(showUserName){
        cellHeight = newSize.height + kPaddingTop + kPaddingBottom + kPaddingContentTop + kPaddingContentBottom + kUsernameLableHeight + kTimeLableHeight + kPaddingMessageTop + 2;
    }
    else{
        cellHeight = newSize.height + kPaddingTop + kPaddingBottom + kPaddingContentTop + kPaddingContentBottom + kTimeLableHeight + 2;
    }
    
    return cellHeight;
}

- (void) setBackgroundImageForMessageView:(UIImage *)backgroundImage {
    UIImage *stretchableImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    _backgroundCallout.image = stretchableImage;
}

#pragma mark -
- (void) layoutPhoto {
    [NSLayoutConstraint setWidht:kPhotoSize height:kPhotoSize forView:_ivPhoto];
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:_ivPhoto inContainer:self];
    [NSLayoutConstraint setLeftPadding:kPaddingLeft forView:_ivPhoto inContainer:self];
}

- (void) layoutMessageView {
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:_messageView inContainer:self];
    [NSLayoutConstraint setBottomPadding:kPaddingBottom forView:_messageView inContainer:self];
    [NSLayoutConstraint setLeftDistance:0 fromView:_messageView toView:_ivPhoto inContainer:self];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_messageView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-kPaddingRight]];
    
    [self layoutBackgoundImage];
    [self layoutUserNameLabel];
    [self layoutMessageLabel];
    [self layoutTimeLabel];
}

- (void) layoutBackgoundImage {
    [NSLayoutConstraint stretch:_backgroundCallout inContainer:_messageView withPadding:0];
}

- (void) layoutUserNameLabel {
    [NSLayoutConstraint setTopPadding:kPaddingContentTop forView:_userNameLabel inContainer:_messageView];
    [NSLayoutConstraint setLeftPadding:kPaddingContentLeft forView:_userNameLabel inContainer:_messageView];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userNameLabel
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:_messageView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-kPaddingContentRight]];
    
    CGFloat userNameHeight = 0;
    if(self.showUserName){
        userNameHeight = kUsernameLableHeight;
    }
    else{
        _userNameLabel.text = @"";
    }
    
    userNameHeightConstraint = [NSLayoutConstraint setHeight:userNameHeight forView:_userNameLabel];
}

- (void) layoutMessageLabel {
    CGFloat userNamePadding = 0;
    if(self.showUserName)
        userNamePadding = kPaddingMessageTop;
    
    userNamePaddingConstraint = [NSLayoutConstraint setTopDistance:userNamePadding fromView:_userMessage toView:_userNameLabel inContainer:_messageView];
    
    [NSLayoutConstraint setLeftPadding:kPaddingContentLeft forView:_userMessage inContainer:_messageView];
    
    [_messageView addConstraint:[NSLayoutConstraint constraintWithItem:_userMessage
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                               toItem:_messageView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-kPaddingContentRight]];
    
}

- (void) layoutTimeLabel {
    [NSLayoutConstraint setHeight:kTimeLableHeight forView:_timeLabel];
    [NSLayoutConstraint setBottomPadding:kPaddingContentBottom forView:_timeLabel inContainer:_messageView];
    [NSLayoutConstraint setRightPadding:kPaddingContentRight forView:_timeLabel inContainer:_messageView];
    [NSLayoutConstraint setTopDistance:1 fromView:_timeLabel toView:_userMessage inContainer:_messageView];
}

#pragma mark -
- (void) updateNameLabelConstraintsIfNeeded {
    if(self.showUserName){
        userNameHeightConstraint.constant = kUsernameLableHeight;
        userNamePaddingConstraint.constant = kPaddingMessageTop;
    }
    else{
        userNameHeightConstraint.constant = 0;
        userNamePaddingConstraint.constant = 0;
        _userNameLabel.text = @"";
    }
}

@end





















