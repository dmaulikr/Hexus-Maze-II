//
//  HDHexagon.h
//  HexitSpriteKit
//
//  Created by Evan Ische on 11/3/14.
//  Copyright (c) 2014 Evan William Ische. All rights reserved.
//

@import SpriteKit;
#import <Foundation/Foundation.h>

@class HDHexagonNode;

typedef enum {
    HDHexagonTypeRegular = 1,
    HDHexagonTypeDouble  = 2,
    HDHexagonTypeTriple  = 3,
    HDHexagonTypeOne     = 4,
    HDHexagonTypeTwo     = 5,
    HDHexagonTypeThree   = 6,
    HDHexagonTypeFour    = 7,
    HDHexagonTypeFive    = 8,
    HDHexagonTypeStarter = 9,
    HDHexagonTypeNone    = 10,
    HDHexagonTypeEnd     = 11
} HDHexagonType;

typedef enum {
    HDHexagonStateEnabled  = 1,
    HDHexagonStateDisabled = 2,
    HDHexagonStateNone     = 0
} HDHexagonState;

extern NSString * const DOUBLE_KEY;
extern NSString * const TRIPLE_KEY;

static const NSInteger NumberOfRows    = 18;
static const NSInteger NumberOfColumns = 9;

@class HDHexagonNode;
@protocol HDHexagonDelegate;
@interface HDHexagon : NSObject

@property (nonatomic, readonly) NSInteger touchesCount;

@property (nonatomic, getter=isCountTile, assign) BOOL countTile;
@property (nonatomic, getter=isSelected, assign) BOOL selected;
@property (nonatomic, getter=isLocked,   assign) BOOL locked;

@property (nonatomic, weak) id<HDHexagonDelegate> delegate;
@property (nonatomic, strong) HDHexagonNode *node;

@property (nonatomic, assign) HDHexagonState state;
@property (nonatomic, assign) HDHexagonType type;

@property (nonatomic, readonly) NSInteger column;
@property (nonatomic, readonly) NSInteger row;

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column NS_DESIGNATED_INITIALIZER;

- (void)recievedTouches;
- (void)restoreToInitialState;

@end

@protocol HDHexagonDelegate <NSObject>
@optional
- (void)unlockCountTileAfterHexagon:(HDHexagonType)type;
@end
