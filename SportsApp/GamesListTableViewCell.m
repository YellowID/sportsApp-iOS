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

#define PADDING_TOP 7
#define PADDING_BOTTOM 13
#define PADDING_LEFT 7
#define PADDING_RIGHT 7

#define STATUS_ICON_SIZE 19.5

#define PADDING_SECOND_ROW_TOP 13

#define SMALL_LABLE_HEIGHT 10

@implementation GamesListTableViewCell {
    UIColor* bgColorNormal;
    UIColor* bgColorSelected;
    UIColor* bgColorHighlighted;
    UIColor* bgColorDisabled;
    
    UIView *container;
    NSLayoutConstraint *topPadding;
    NSLayoutConstraint *bottomPadding;
    
    CGFloat topPaddingValue;
    CGFloat bottomPaddingValue;
}

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awakeFromNib");
}

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
    //topPadding.constant = padding;
    topPaddingValue = padding;
}

- (void) setBottomPadding:(CGFloat)padding {
    //bottomPadding.constant = padding;
    bottomPaddingValue = padding;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        topPaddingValue = 2.75f;
        bottomPaddingValue = -2.75f;
        
        container = [UIView new];
        container.backgroundColor = [UIColor whiteColor];
        container.layer.borderWidth = 0.5;
        container.layer.cornerRadius = 6.0;
        container.layer.borderColor = [[UIColor colorWithRGBA:BORDER_COLOR] CGColor];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:container];
        
        _gameNameLabel = [UILabel new];
        _gameNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _gameNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_gameNameLabel];
        //_gameNameLabel.backgroundColor = [UIColor greenColor];
        
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:9.0f];
        [_addressLabel sizeToFit];
        _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_addressLabel];
        //_addressLabel.backgroundColor = [UIColor greenColor];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:9.0f];
        [_timeLabel sizeToFit];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [container addSubview:_timeLabel];
        //_timeLabel.backgroundColor = [UIColor greenColor];
        
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:9.0f];
        [_dateLabel sizeToFit];
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
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutContainerView];
    
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
    
    
    /*
    NSDictionary* views = NSDictionaryOfVariableBindings(_dateLabel, _ivTime);
    
    NSString* hc_str = @"H:[_dateLabel]-(>=11)-[_ivTime]";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [self addConstraints:hzConstraints];
    */
}

- (void) layoutContainerView {
    if(!topPadding){
        topPadding = [NSLayoutConstraint constraintWithItem:container
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:0
                                                     toItem:self
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1
                                                   constant:topPaddingValue];
        [self addConstraint:topPadding];
    }
    else{
        topPadding.constant = topPaddingValue;
    }
    
    if(!bottomPadding){
        bottomPadding = [NSLayoutConstraint constraintWithItem:container
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:0
                                                     toItem:self
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1
                                                   constant:bottomPaddingValue];
        [self addConstraint:bottomPadding];
    }
    else{
        bottomPadding.constant = bottomPaddingValue;
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:container
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:5.5]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:container
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-5.5]];
}

- (void) layoutGameNameLabel {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_gameNameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:container
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_gameNameLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:container
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [_gameNameLabel addConstraint: [NSLayoutConstraint constraintWithItem:_gameNameLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:18]];
}

- (void) layoutStatusIcon {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivStatus
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:container
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:PADDING_TOP]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivStatus
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:container
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_RIGHT]];
    
    [_ivStatus addConstraint: [NSLayoutConstraint constraintWithItem:_ivStatus
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:STATUS_ICON_SIZE]];
    
    [_ivStatus addConstraint: [NSLayoutConstraint constraintWithItem:_ivStatus
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:STATUS_ICON_SIZE]];
}

- (void) layoutAdminIcon {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivAdmin
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:container
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivAdmin
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:_ivStatus
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-PADDING_RIGHT]];
    
    [_ivAdmin addConstraint: [NSLayoutConstraint constraintWithItem:_ivAdmin
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:STATUS_ICON_SIZE]];
    
    [_ivAdmin addConstraint: [NSLayoutConstraint constraintWithItem:_ivAdmin
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:STATUS_ICON_SIZE]];
}

- (void) layoutLocationIcon {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivLocation
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:container
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-PADDING_BOTTOM]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivLocation
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:container
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [_ivLocation addConstraint: [NSLayoutConstraint constraintWithItem:_ivLocation
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:13.5]];//27
    
    [_ivLocation addConstraint: [NSLayoutConstraint constraintWithItem:_ivLocation
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:14]];
}

- (void) layoutAddressLabel {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:0
                                                        toItem:_ivLocation
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:_ivLocation
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:4]];
    
    [_addressLabel addConstraint: [NSLayoutConstraint constraintWithItem:_addressLabel
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:0
                                                            multiplier:1
                                                              constant:SMALL_LABLE_HEIGHT]];
}

- (void) layoutDateIcon {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivDate
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_gameNameLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:PADDING_SECOND_ROW_TOP]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivDate
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_LEFT]];
    
    [_ivDate addConstraint: [NSLayoutConstraint constraintWithItem:_ivDate
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:0
                                                            multiplier:1
                                                              constant:13.5]];//27
    
    [_ivDate addConstraint: [NSLayoutConstraint constraintWithItem:_ivDate
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:0
                                                            multiplier:1
                                                              constant:14]];
}

- (void) layoutDateLabel {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:0
                                                             toItem:_ivDate
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:_ivDate
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:8]];
    
    [_dateLabel addConstraint: [NSLayoutConstraint constraintWithItem:_dateLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:0
                                                               toItem:nil
                                                            attribute:0
                                                           multiplier:1
                                                             constant:SMALL_LABLE_HEIGHT]];
}

- (void) layoutSeparatorView {
    UIView *separator = [UIView new];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithRGBA:CELL_SEPARATOR_COLOR];
    [container addSubview:separator];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:0
                                                             toItem:_ivDate
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:7.5f]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:PADDING_LEFT]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:separator
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:0
                                                             toItem:container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-PADDING_RIGHT]];
    
    [separator addConstraint: [NSLayoutConstraint constraintWithItem:separator
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:0.5f]];
}

- (void) layoutTimeLabel {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:0
                                                        toItem:_ivDate
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:container
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-PADDING_LEFT]];
    
    [_timeLabel addConstraint: [NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:0
                                                               toItem:nil
                                                            attribute:0
                                                           multiplier:1
                                                             constant:SMALL_LABLE_HEIGHT]];
}

- (void) layoutTimeIcon {
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivTime
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:0
                                                        toItem:_ivDate
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:_ivTime
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:_timeLabel
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-8]];
    
    [_ivTime addConstraint: [NSLayoutConstraint constraintWithItem:_ivTime
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:0
                                                            toItem:nil
                                                         attribute:0
                                                        multiplier:1
                                                          constant:13.5]];
    
    [_ivTime addConstraint: [NSLayoutConstraint constraintWithItem:_ivTime
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:0
                                                            toItem:nil
                                                         attribute:0
                                                        multiplier:1
                                                          constant:14]];
}

@end
