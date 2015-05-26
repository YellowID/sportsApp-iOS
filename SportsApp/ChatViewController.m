//
//  ChatViewController.m
//  SportsApp
//
//  Created by sergeyZ on 26.05.15.
//
//

#import "ChatViewController.h"
#import "NSLayoutConstraint+Helper.h"

#define CURTAIN_HEIGT 276

// curtain
@interface ChatViewController ()

#pragma mark -
#pragma mark Containers
@property (strong, nonatomic) UIScrollView* chatScrollView;
@property (strong, nonatomic) UIView* chatContentView;

#pragma mark -
#pragma mark Groups view
@property (strong, nonatomic) UIView* curtainView;
@property (strong, nonatomic) UIView* curtainRowOneView;
@property (strong, nonatomic) UIView* curtainRowTwoView;
@property (strong, nonatomic) UIView* curtainRowThreeView;
@property (strong, nonatomic) UIView* curtainArrowView;

@end

@implementation ChatViewController{
    NSLayoutConstraint* curtainHeigtContraint;
    BOOL isCurtainOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Chat";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupCurtainView];
    
}

#pragma mark -
#pragma mark Curtain view
- (void) setupCurtainView {
    _curtainView = [UIView new];
    _curtainView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_curtainView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:0]];
    
    curtainHeigtContraint = [NSLayoutConstraint constraintWithItem:_curtainView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:0
                                                                    toItem:nil
                                                                 attribute:0
                                                                multiplier:1
                                                                  constant:CURTAIN_HEIGT];
    [_curtainView addConstraint: curtainHeigtContraint];
    
    [self setupCurtainArrowView];
    [self layoutFirstRowCurtain];
}

#pragma mark -
#pragma mark First row
- (void) layoutFirstRowCurtain {
    _curtainRowOneView = [UIView new];
    _curtainRowOneView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainRowOneView.backgroundColor = [UIColor whiteColor];
    [_curtainView addSubview:_curtainRowOneView];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0]];
    
    [_curtainView addConstraint:[NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:0]];
    
    [_curtainRowOneView addConstraint: [NSLayoutConstraint constraintWithItem:_curtainRowOneView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:0
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:38]];
    
    UIImageView* locIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_location.png"]];
    [_curtainRowOneView addSubview:locIcon];
    locIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:8 height:10 forView:locIcon];
    [NSLayoutConstraint centerVertical:locIcon withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UILabel* locTitle = [self makeLocationLable];
    [_curtainRowOneView addSubview:locTitle];
    locTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:locTitle];
    [NSLayoutConstraint centerVertical:locTitle withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UIImageView* timeIcon = [self makeFirstRowIconWithImage:[UIImage imageNamed:@"icon_time.png"]];
    [_curtainRowOneView addSubview:timeIcon];
    timeIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setWidht:10 height:11 forView:timeIcon];
    [NSLayoutConstraint centerVertical:timeIcon withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    UILabel* timeTitle = [self makeTimeLable];
    [_curtainRowOneView addSubview:timeTitle];
    timeTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint setHeight:15 forView:timeTitle];
    [NSLayoutConstraint centerVertical:timeTitle withView:_curtainRowOneView inContainer:_curtainRowOneView];
    
    
    NSDictionary* views = NSDictionaryOfVariableBindings(locTitle, locIcon, timeTitle, timeIcon);
    NSString* hc1_str = @"H:|-5-[locIcon]-4-[locTitle]";
    NSArray* hz1Constraints = [NSLayoutConstraint constraintsWithVisualFormat:hc1_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:hz1Constraints];
    
    NSString* hc2_str = @"H:[timeIcon]-4-[timeTitle]-5-|";
    NSArray* hz2Constraints = [NSLayoutConstraint constraintsWithVisualFormat:hc2_str options:0 metrics:nil views:views];
    [_curtainRowOneView addConstraints:hz2Constraints];
}

- (UIImageView*) makeFirstRowIconWithImage:(UIImage*)image {
    UIImageView* icon = [UIImageView new];
    icon.image = image;
    return icon;
}

- (UILabel*) makeTimeLable {
    UILabel* lable = [UILabel new];
    lable.text = @"10:00 через 3 дня";
    lable.textAlignment = NSTextAlignmentRight;
    lable.font = [UIFont systemFontOfSize:9.0f];
    [lable sizeToFit];
    return lable;
}

- (UILabel*) makeLocationLable {
    UILabel* lable = [UILabel new];
    lable.text = @"Суперзал, ул. Пушкина, 120Д/1";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:9.0f];
    [lable sizeToFit];
    return lable;
}

#pragma mark -
#pragma mark Arrow View
- (void) setupCurtainArrowView {
    _curtainArrowView = [UIView new];
    _curtainArrowView.translatesAutoresizingMaskIntoConstraints = NO;
    _curtainArrowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_curtainArrowView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainArrowView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_curtainArrowView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:0
                                                                  toItem:_curtainView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0]];
    [NSLayoutConstraint setWidht:60 height:30 forView:_curtainArrowView];
    
    _curtainArrowView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCurtainArrow)];
    [_curtainArrowView addGestureRecognizer:tapGesture];
}

#pragma mark -
#pragma mark close/open Curtain view
- (void) tapCurtainArrow {
    if(isCurtainOpen){
        isCurtainOpen = NO;
        [self closeCurtainView];
    }
    else{
        isCurtainOpen = YES;
        [self openCurtainView];
    }
}

- (void) closeCurtainView {
    [UIView animateWithDuration:0.4 animations:^{
        curtainHeigtContraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void) openCurtainView {
    [UIView animateWithDuration:0.4 animations:^{
        curtainHeigtContraint.constant = CURTAIN_HEIGT;
        [self.view layoutIfNeeded];
    }];
}

@end












