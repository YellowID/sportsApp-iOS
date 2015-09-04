//
//  GamesListTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "GamesListTableViewCell.h"
#import "AppColors.h"
#import "UIColor+Helper.h"
#import "NSLayoutConstraint+Helper.h"

#include <QuartzCore/QuartzCore.h>

static const CGFloat kPaddingTop = 7.0f;
static const CGFloat kPaddingBottom = 10.0f;
static const CGFloat kPaddingLeft = 7.0f;
static const CGFloat kPaddingRight = 7.0f;

static const CGFloat kPaddingSecondRowTop = 13.0f;
static const CGFloat kSmallLableHeight = 13.0f;

static const CGFloat kIconStatusSize = 19.5f;


@implementation GamesListTableViewCell {
    UIColor* bgColorNormal;
    UIColor* bgColorSelected;
    UIColor* bgColorHighlighted;
    UIColor* bgColorDisabled;
    
    UIImageView *backgroundImage;
    
    UIView *container;
    NSLayoutConstraint *topPadding;
    NSLayoutConstraint *bottomPadding;
    
    CGFloat topPaddingValue;
    CGFloat bottomPaddingValue;
}

#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(highlighted){
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = bgColorHighlighted;
        }];
    }
    else{
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor = bgColorNormal;
        }];
    }
}

- (void) setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            bgColorNormal = color;
            break;
        case UIControlStateSelected:
            bgColorSelected = color;
            break;
        case UIControlStateHighlighted:
            bgColorHighlighted = color;
            break;
        case UIControlStateDisabled:
            bgColorDisabled = color;
            break;
        default:
            break;
    }
}

- (void) setTopPadding:(CGFloat)padding {
    topPaddingValue = padding;
}

- (void) setBottomPadding:(CGFloat)padding {
    bottomPaddingValue = padding;
}

#pragma mark -
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        topPaddingValue = 2.5f;
        bottomPaddingValue = -2.5f;
        
        container = [UIView new];
        container.backgroundColor = [UIColor clearColor];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:container];
        
        container.backgroundColor = [UIColor whiteColor];
        container.layer.borderWidth = 0.4;
        container.layer.cornerRadius = 6.0;
        container.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
        
        
        /*
        backgroundImage = [UIImageView new];
        backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:backgroundImage];
        
        UIImage *tempImg = [UIImage imageNamed:@"bg_game_cell.png"];
        UIImage *stretchableImage = [tempImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
        backgroundImage.image = stretchableImage;
        */
        
        
        _gameNameLabel = [UILabel new];
        _gameNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _gameNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_gameNameLabel];
        //_gameNameLabel.backgroundColor = [UIColor greenColor];
        
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:11.0f];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_addressLabel];
        //_addressLabel.backgroundColor = [UIColor greenColor];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_timeLabel];
        //_timeLabel.backgroundColor = [UIColor greenColor];
        
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:11.0f];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_dateLabel];
        //_dateLabel.backgroundColor = [UIColor greenColor];
        
        _ivAdmin = [UIImageView new];
        _ivAdmin.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_ivAdmin];
        
        _ivStatus = [UIImageView new];
        _ivStatus.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_ivStatus];
        
        _ivLocation = [UIImageView new];
        _ivLocation.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_ivLocation];
        //_ivLocation.backgroundColor = [UIColor greenColor];
        
        _ivTime = [UIImageView new];
        _ivTime.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_ivTime];
        //_ivTime.backgroundColor = [UIColor greenColor];
        
        _ivDate = [UIImageView new];
        _ivDate.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_ivDate];
        //_ivDate.backgroundColor = [UIColor greenColor];
        
        [self layoutContainerView];
        //[self layoutBackgoundImage];
        
        [self layoutGameNameLabel];
        [self layoutStatusIcon];
        [self layoutAdminIcon];
        
        [self layoutDateIcon];
        [self layoutDateLabel];
        
        [self layoutTimeLabel];
        [self layoutTimeIcon];
        
        [self layoutSeparatorView];
        
        [self layoutLocationIcon];
        [self layoutAddressLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateContainerPadding];
}

- (void) updateContainerPadding {
    topPadding.constant = topPaddingValue;
    bottomPadding.constant = bottomPaddingValue;
}

#pragma mark -
- (void) layoutBackgoundImage {
    [NSLayoutConstraint stretch:backgroundImage inContainer:container withPadding:0];
}

- (void) layoutContainerView {
    topPadding = [NSLayoutConstraint setTopPadding:topPaddingValue forView:container inContainer:self];
    bottomPadding = [NSLayoutConstraint setBottomPadding:bottomPaddingValue forView:container inContainer:self];
    [NSLayoutConstraint setLeftPadding:5.5 forView:container inContainer:self];
    [NSLayoutConstraint setRightPadding:5.5 forView:container inContainer:self];
}

- (void) layoutGameNameLabel {
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:_gameNameLabel inContainer:container];
    [NSLayoutConstraint setLeftPadding:kPaddingLeft forView:_gameNameLabel inContainer:container];
    [NSLayoutConstraint setHeight:18 forView:_gameNameLabel];
}

- (void) layoutStatusIcon {
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:_ivStatus inContainer:container];
    [NSLayoutConstraint setRightPadding:kPaddingRight forView:_ivStatus inContainer:container];
    [NSLayoutConstraint setWidht:kIconStatusSize height:kIconStatusSize forView:_ivStatus];
}

- (void) layoutAdminIcon {
    [NSLayoutConstraint setWidht:kIconStatusSize height:kIconStatusSize forView:_ivAdmin];
    [NSLayoutConstraint setTopPadding:kPaddingTop forView:_ivAdmin inContainer:container];
    [NSLayoutConstraint setRightDistance:kPaddingRight fromView:_ivAdmin toView:_ivStatus inContainer:container];
}

- (void) layoutLocationIcon {
    [NSLayoutConstraint setWidht:13.5 height:14 forView:_ivLocation];
    [NSLayoutConstraint setLeftPadding:kPaddingLeft forView:_ivLocation inContainer:container];
    [NSLayoutConstraint setBottomPadding:kPaddingBottom forView:_ivLocation inContainer:container];
}

- (void) layoutAddressLabel {
    [NSLayoutConstraint setHeight:kSmallLableHeight forView:_addressLabel];
    [NSLayoutConstraint setRightPadding:kPaddingLeft forView:_addressLabel inContainer:container];
    [NSLayoutConstraint setLeftDistance:8 fromView:_addressLabel toView:_ivLocation inContainer:container];
    [NSLayoutConstraint centerVertical:_addressLabel withView:_ivLocation inContainer:container];
}

- (void) layoutDateIcon {
    [NSLayoutConstraint setWidht:13.5 height:14 forView:_ivDate];
    [NSLayoutConstraint setLeftPadding:kPaddingLeft forView:_ivDate inContainer:container];
    [NSLayoutConstraint setTopDistance:kPaddingSecondRowTop fromView:_ivDate toView:_gameNameLabel inContainer:container];
}

- (void) layoutDateLabel {
    [NSLayoutConstraint setHeight:kSmallLableHeight forView:_dateLabel];
    [NSLayoutConstraint setLeftDistance:8 fromView:_dateLabel toView:_ivDate inContainer:container];
    [NSLayoutConstraint centerVertical:_dateLabel withView:_ivDate inContainer:container];
}

- (void) layoutSeparatorView {
    UIView *separator = [UIView new];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithRGBA:CELL_SEPARATOR_COLOR];
    [container addSubview:separator];
    
    [NSLayoutConstraint setHeight:0.5f forView:separator];
    [NSLayoutConstraint stretchHorizontal:separator inContainer:container withPadding:kPaddingLeft];
    [NSLayoutConstraint setTopDistance:9.0f fromView:separator toView:_ivDate inContainer:container];
}

- (void) layoutTimeLabel {
    [NSLayoutConstraint setHeight:kSmallLableHeight forView:_timeLabel];
    [NSLayoutConstraint setRightPadding:kPaddingRight forView:_timeLabel inContainer:container];
    [NSLayoutConstraint centerVertical:_timeLabel withView:_ivDate inContainer:container];
}

- (void) layoutTimeIcon {
    [NSLayoutConstraint setWidht:13.5f height:14.0f forView:_ivTime];
    [NSLayoutConstraint setRightDistance:8 fromView:_ivTime toView:_timeLabel inContainer:container];
    [NSLayoutConstraint centerVertical:_ivTime withView:_ivDate inContainer:container];
}

@end
