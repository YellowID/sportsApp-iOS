//
//  ChatViewController.h
//  SportsApp
//
//  Created by sergeyZ on 26.05.15.
//
//

#import <UIKit/UIKit.h>

@protocol ChatViewControllerDelegate;

@interface ChatViewController : UIViewController

@property (nonatomic) NSUInteger gameId;
@property (weak, nonatomic) id <ChatViewControllerDelegate> delegate;

@end

@protocol ChatViewControllerDelegate <NSObject>
- (void)needUpdateGamesWithController:(ChatViewController *)controller;
@end