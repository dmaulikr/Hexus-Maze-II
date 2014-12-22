//
//  Constants.m
//  Hexagon
//
//  Created by Evan Ische on 10/3/14.
//  Copyright (c) 2014 Evan William Ische. All rights reserved.
//


// Notification Keys
NSString * const HDIntroAnimationNotification     = @"performIntroAnimations";
NSString * const HDAnimateLabelNotification       = @"animateCompletedCountLabelY";
NSString * const HDCompletedTileCountNotification = @"UpdateCompletedTileCountNotification";
NSString * const HDClearTileCountNotification     = @"clearCompletedTileCountNotification";

NSString * const HDNextLevelNotification      = @"NextLevelNotification";
NSString * const HDToggleControlsNotification = @"ToggleControlsNotification";
NSString * const HDSoundNotification          = @"TileWasSoundNotification";
NSString * const HDVibrationNotification      = @"TileWasVibrationNotification";
NSString * const HDRestartNotificaiton        = @"restartNotification";

//Dictionary Keys
NSString * const HDHexGridKey = @"grid";
NSString * const HDHexZoomKey = @"zoom";

// UserDefault Keys
NSString * const HDDefaultLevelKey   = @"defaultLevels";
NSString * const HDFirstRunKey       = @"firstRunKey";
NSString * const HDRemainingLivesKey = @"livesKey";
NSString * const HDGuideKey          = @"guide";
NSString * const HDRemainingTime     = @"remainingTimeUntilNextLife";
NSString * const HDBackgroundDate    = @"BackgroundDate";
NSString * const HDEffectsKey        = @"effectsKey";
NSString * const HDSoundkey          = @"soundKey";
NSString * const HDVibrationKey      = @"vibrationKey";

// Sound Keys
NSString * const HDButtonSound = @"D4.m4a";
NSString * const HDSwipeSound  = @"Swooshed.mp3";
NSString * const HDC3         = @"C3.m4a";
NSString * const HDD3         = @"D3.m4a";
NSString * const HDE3         = @"E3.m4a";
NSString * const HDF3         = @"F3.m4a";
