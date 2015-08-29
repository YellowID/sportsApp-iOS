//
//  NewEvenTTTViewController.h
//  SportsApp
//
//  Created by sergeyZ on 24.05.15.
//
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"

@protocol NewEvenViewControllerDelegate;

@interface NewEvenViewController : UIViewController

@property (nonatomic) BOOL isEditGameMode;
@property (nonatomic) NSUInteger gameId;

@property (weak, nonatomic) id <NewEvenViewControllerDelegate> delegate;

@end

@protocol NewEvenViewControllerDelegate <NSObject>
- (void)gameWasSavedWithController:(NewEvenViewController *)controller gameId:(NSUInteger)gameID;
@end