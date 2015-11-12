//
//  Constants.h
//  SportsApp
//
//  Created by sergeyZ on 12.06.15.
//
//

#ifndef SportsApp_Constants_h
#define SportsApp_Constants_h

enum SportType : NSUInteger {
    SportTypeUnknown,
    SportTypeFootball,
    SportTypeBasketball,
    SportTypeVolleyball,
    SportTypeHandball,
    SportTypeTennis,
    SportTypeHockey,
    SportTypeSquash
};
typedef enum SportType SportType;

enum PlayerAge : NSUInteger {
    PlayerAgeUnknown,
    PlayerAge_20,
    PlayerAge_20_28,
    PlayerAge_28_35,
    PlayerAge_35
};
typedef enum PlayerAge PlayerAge;

enum PlayerLevel : NSUInteger {
    PlayerLevelUnknown,
    PlayerLevelBeginner,
    PlayerLevelMiddling,
    PlayerLevelMaster
};
typedef enum PlayerLevel PlayerLevel;

enum UserGameParticipateStatus : NSUInteger {
    UserGameParticipateStatusNo = 1,
    UserGameParticipateStatusYes,
    UserGameParticipateStatusPossible
};
typedef enum UserGameParticipateStatus UserGameParticipateStatus;

#endif
