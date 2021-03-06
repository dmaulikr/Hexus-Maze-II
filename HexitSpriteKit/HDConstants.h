//
//  Constants.h
//  Hexagon
//
//  Created by Evan Ische on 10/3/14.
//  Copyright (c) 2014 Evan William Ische. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define GAME_FONT_WITH_SIZE(x) [UIFont fontWithName:@"TrebuchetMS" size:x]

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define PREIOS8_SCALE SYSTEM_VERSION_LESS_THAN(@"8.0") ? 1/[[UIScreen mainScreen] scale] : 1

#define LEVEL_URL(x) [NSString stringWithFormat:@"Grid-%ld",x]

#define PRELOAD_THESE_SOUNDS @[HDSwipeSound, HDButtonSound, HDCompletionZing, HDGameOverKey]

#define TRANSFORM_SCALE_X [UIScreen mainScreen].bounds.size.width  / 375.0f
#define TRANSFORM_SCALE_Y [UIScreen mainScreen].bounds.size.height / 667.0f

typedef NS_ENUM(NSUInteger, HDLevelState) {
    HDLevelStateLocked    = 0,
    HDLevelStateUnlocked  = 1,
    HDLevelStateCompleted = 2,
    HDLevelStateNone      = 3
};

/** Dictionary Keys **/
extern NSString * const HDHexGridKey;

/** NSUserDefault Keys **/
extern NSString * const HDLastCompletedLevelKey;
extern NSString * const HDDefaultLevelKey;
extern NSString * const HDFirstRunKey;
extern NSString * const HDSoundkey;
extern NSString * const HDMusickey;

/** Sound Keys **/
extern NSString * const HDGameOverKey;
extern NSString * const HDCompletionZing;
extern NSString * const HDSoundLoopKey;
extern NSString * const HDButtonSound;
extern NSString * const HDSwipeSound;
