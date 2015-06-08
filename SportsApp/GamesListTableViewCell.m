//
//  GamesListTableViewCell.m
//  SportsApp
//
//  Created by sergeyZ on 20.05.15.
//
//

#import "GamesListTableViewCell.h"

#define PADDING_TOP 17
#define PADDING_BOTTOM 17
#define PADDING_LEFT 13.5
#define PADDING_RIGHT 13.5

#define SMALL_LABLE_HEIGHT 10

@implementation GamesListTableViewCell {
    UIColor* bgColorNormal;
    UIColor* bgColorSelected;
    UIColor* bgColorHighlighted;
    UIColor* bgColorDisabled;
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

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //Changes here after init'ing self
        _gameNameLabel = [UILabel new];
        _gameNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _gameNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_gameNameLabel];
        //_gameNameLabel.backgroundColor = [UIColor greenColor];
        
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:9.0f];
        [_addressLabel sizeToFit];
        _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_addressLabel];
        //_addressLabel.backgroundColor = [UIColor greenColor];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:9.0f];
        [_timeLabel sizeToFit];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_timeLabel];
        //_timeLabel.backgroundColor = [UIColor greenColor];
        
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:9.0f];
        [_dateLabel sizeToFit];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_dateLabel];
        //_dateLabel.backgroundColor = [UIColor greenColor];
        
        _ivAdmin = [UIImageView new];
        _ivAdmin.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_ivAdmin];
        
        _ivStatus = [UIImageView new];
        _ivStatus.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_ivStatus];
        
        _ivLocation = [UIImageView new];
        _ivLocation.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_ivLocation];
        //_ivLocation.backgroundColor = [UIColor greenColor];
        
        _ivTime = [UIImageView new];
        _ivTime.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_ivTime];
        //_ivTime.backgroundColor = [UIColor greenColor];
        
        _ivDate = [UIImageView new];
        _ivDate.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_ivDate];
        //_ivDate.backgroundColor = [UIColor greenColor];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutGameNameLabel];
    [self layoutStatusIcon];
    [self layoutAdminIcon];
    [self layoutLocationIcon];
    [self layoutAddressLabel];
    [self layoutDateLabel];
    [self layoutDateIcon];
    [self layoutTimeLabel];
    [self layoutTimeIcon];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_addressLabel, _ivTime);
    
    NSString* hc_str = @"H:[_addressLabel]-(>=11)-[_ivTime]";
    NSArray* hzConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hc_str options:0 metrics:nil views:views];
    [self addConstraints:hzConstraints];
}

- (void) layoutGameNameLabel {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_gameNameLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_gameNameLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:self
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivStatus
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivStatus
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-PADDING_RIGHT]];
    
    [_ivStatus addConstraint: [NSLayoutConstraint constraintWithItem:_ivStatus
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:22]];
    
    [_ivStatus addConstraint: [NSLayoutConstraint constraintWithItem:_ivStatus
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:22]];
}

- (void) layoutAdminIcon {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivAdmin
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:PADDING_TOP]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivAdmin
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:_ivStatus
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-13]];
    
    [_ivAdmin addConstraint: [NSLayoutConstraint constraintWithItem:_ivAdmin
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:22]];
    
    [_ivAdmin addConstraint: [NSLayoutConstraint constraintWithItem:_ivAdmin
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:0
                                                          multiplier:1
                                                            constant:22]];
}

- (void) layoutLocationIcon {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivLocation
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-PADDING_BOTTOM]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivLocation
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:PADDING_LEFT]];
    
    [_ivLocation addConstraint: [NSLayoutConstraint constraintWithItem:_ivLocation
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:8]];
    
    [_ivLocation addConstraint: [NSLayoutConstraint constraintWithItem:_ivLocation
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:0
                                                             toItem:nil
                                                          attribute:0
                                                         multiplier:1
                                                           constant:10.5]];
}

- (void) layoutAddressLabel {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-PADDING_BOTTOM]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
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

- (void) layoutDateLabel {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-PADDING_BOTTOM]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-PADDING_RIGHT]];
    
    [_dateLabel addConstraint: [NSLayoutConstraint constraintWithItem:_dateLabel
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:0
                                                                  toItem:nil
                                                               attribute:0
                                                              multiplier:1
                                                                constant:SMALL_LABLE_HEIGHT]];
}

- (void) layoutDateIcon {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivDate
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-(PADDING_BOTTOM + 0.5)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivDate
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:_dateLabel
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-4]];
    
    [_ivDate addConstraint: [NSLayoutConstraint constraintWithItem:_ivDate
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:0
                                                            multiplier:1
                                                              constant:10.5]];
    
    [_ivDate addConstraint: [NSLayoutConstraint constraintWithItem:_ivDate
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:0
                                                            multiplier:1
                                                              constant:10.5]];
}

- (void) layoutTimeLabel {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-PADDING_BOTTOM]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:_ivDate
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-11]];
    
    [_timeLabel addConstraint: [NSLayoutConstraint constraintWithItem:_timeLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:0
                                                               toItem:nil
                                                            attribute:0
                                                           multiplier:1
                                                             constant:SMALL_LABLE_HEIGHT]];
}

- (void) layoutTimeIcon {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivTime
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-PADDING_BOTTOM]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivTime
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:_timeLabel
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-4]];
    
    [_ivTime addConstraint: [NSLayoutConstraint constraintWithItem:_ivTime
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:0
                                                            toItem:nil
                                                         attribute:0
                                                        multiplier:1
                                                          constant:10.5]];
    
    [_ivTime addConstraint: [NSLayoutConstraint constraintWithItem:_ivTime
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:0
                                                            toItem:nil
                                                         attribute:0
                                                        multiplier:1
                                                          constant:11]];
}

@end
