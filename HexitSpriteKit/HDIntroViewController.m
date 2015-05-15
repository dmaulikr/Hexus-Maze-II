//
//  HDIntroViewController.m
//  HexitSpriteKit
//
//  Created by Evan Ische on 3/13/15.
//  Copyright (c) 2015 Evan William Ische. All rights reserved.
//

#import "HDGameButton.h"
#import "HDIntroViewController.h"
#import "UIColor+ColorAdditions.h"

@implementation HDIntroViewController {
    UILabel *_titleLbl;
    UIImageView *_imageView;
    HDGameButton *_beginBtn;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor flatSTDarkBlueColor];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.text = @"HEXUS MAZE II";
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.textColor = [UIColor flatSTEmeraldColor];
    _titleLbl.font = GAME_FONT_WITH_SIZE(20.0f);
    [_titleLbl sizeToFit];
    _titleLbl.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds)*.75f);
    _titleLbl.frame = CGRectIntegral(_titleLbl.frame);
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconForIntro"]];
    _imageView.transform = IS_IPAD ? CGAffineTransformIdentity : CGAffineTransformMakeScale(TRANSFORM_SCALE_X, TRANSFORM_SCALE_X);
    
    CGRect buttonBounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds)/1.65f, CGRectGetHeight(self.view.bounds)/10.5f);
    if (IS_IPAD) {
        buttonBounds.size.width = CGRectGetWidth(self.view.bounds)/1.9f;
    }
    
    _beginBtn = [[HDGameButton alloc] initWithFrame:buttonBounds];
    _beginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _beginBtn.titleLabel.font = GAME_FONT_WITH_SIZE(CGRectGetHeight(_beginBtn.bounds)*.4f);
    [_beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_beginBtn addTarget:[HDAppDelegate sharedDelegate]
                 action:@selector(presentLevelViewController:)
       forControlEvents:UIControlEventTouchUpInside];
    [_beginBtn setTitle:@"PLAY" forState:UIControlStateNormal];
    _beginBtn.selected = YES;
    _beginBtn.buttonColor = [UIColor flatSTEmeraldColor];
    _beginBtn.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                   CGRectGetHeight(self.view.bounds) + CGRectGetHeight(_beginBtn.bounds));
    
    for (UIView *child in @[_titleLbl, _imageView, _beginBtn]) {
        [self.view addSubview:child];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _imageView.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    BOOL firstRun = [self _checkForFirstRun];
    if (firstRun) {
        return;
    }
    
    [UIView animateWithDuration:.300f animations:^{
        _beginBtn.center  = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds)/1.20f);
        _imageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds)/3.15f);
    } completion:^(BOOL finished) {
        _beginBtn.selected = NO;
    }];
}

- (BOOL)_checkForFirstRun {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:HDFirstRunKey]) {
        [[HDAppDelegate sharedDelegate] presentTutorialViewControllerForFirstRun];
        [userDefaults setBool:YES forKey:HDFirstRunKey];
        return YES;
    }
    return NO;
}

@end
