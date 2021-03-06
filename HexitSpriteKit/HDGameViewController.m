//
//  ViewController.m
//  HexitSpriteKit
//
//  Created by Evan Ische on 11/2/14.
//  Copyright (c) 2014 Evan William Ische. All rights reserved.
//

@import iAd;
@import SpriteKit;

#import "HDHelper.h"
#import "HDHexusIAdHelper.h"
#import "HDLevelGenerator.h"
#import "HDNavigationBar.h"
#import "HDAlertView.h"
#import "UIColor+ColorAdditions.h"
#import "HDGameViewController.h"
#import "HDContainerViewController.h"
#import "HDGameCenterManager.h"
#import "HDCompletionView.h"
#import "HDSoundManager.h"
#import "HDSettingsManager.h"
#import "HDGridManager.h"
#import "HDGameScene.h"

@interface HDGameViewController () <ADBannerViewDelegate, HDSceneDelegate, HDCompletionViewDelegate>
@property (nonatomic, strong) HDNavigationBar *menuBar;
@property (nonatomic, strong) HDGridManager *gridManager;
@property (nonatomic, strong) HDGameScene *scene;
@property (nonatomic, strong) ADBannerView *bannerView;
@property (nonatomic, assign) BOOL navigationBarHidden;
@end

@implementation HDGameViewController {
    BOOL _isBannerVisible;
    NSUInteger _levelIdx;
}

- (void)dealloc
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self
                                  name:IAPHelperProductPurchasedNotification
                                object:nil];
    [notificationCenter removeObserver:self
                                  name:UIApplicationWillResignActiveNotification
                                object:nil];
    [notificationCenter removeObserver:self
                                  name:UIApplicationDidBecomeActiveNotification
                                object:nil];
}

- (instancetype)initWithLevel:(NSInteger)level
{
    if (self = [super init]) {
        _levelIdx = level;
        self.gridManager = [[HDGridManager alloc] initWithLevelIndex:_levelIdx];
    }
    return self;
}

- (void)loadView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    SKView *skView = [[SKView alloc] initWithFrame:bounds];
    self.view = skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect menuBarFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/8);
    _menuBar = [HDNavigationBar menuBarWithActivityImage:[UIImage imageNamed:@"Restart"]];
    _menuBar.frame = menuBarFrame;
    _menuBar.center = CGPointMake(CGRectGetMidX(self.view.bounds), -CGRectGetMidY(_menuBar.bounds));
    [_menuBar.navigationButton addTarget:self.containerViewController
                                      action:@selector(toggleMenuViewController)
                            forControlEvents:UIControlEventTouchUpInside];
    [_menuBar.activityButton addTarget:self
                                    action:@selector(restart:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_menuBar];
    
    BOOL bannersRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:IAPremoveAdsProductIdentifier];
    if (!bannersRemoved) {
        
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
        [UIViewController prepareInterstitialAds];
        
        self.bannerView = [[ADBannerView alloc] init];
        self.bannerView.delegate = self;
        [self.view addSubview:self.bannerView];
        
        CGRect bannerFrame = self.bannerView.frame;
        bannerFrame.origin.y = CGRectGetHeight(self.view.bounds);
        self.bannerView.frame = bannerFrame;
    }

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(_removeAdsWasPurchased:)
                               name:IAPHelperProductPurchasedNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(_applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(_applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
}

#pragma mark - Public

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    _navigationBarHidden = navigationBarHidden;
    if (_navigationBarHidden) {
        [self _hideAnimated:YES];
    } else {
        [self _showAnimated:YES];
    }
}

- (void)viewWillLayoutSubviews
{
    SKView * skView = (SKView *)self.view;
    
    [super viewWillLayoutSubviews];
    if (!skView.scene && self.gridManager) {
        
        self.scene = [HDGameScene sceneWithSize:self.view.bounds.size];
        self.scene.myDelegate = self;
        self.scene.levelIndex = _levelIdx;
        self.scene.gridManager = self.gridManager;
        [skView presentScene:self.scene];
        [self _beginGame];
    }
}

#pragma mark - Private

- (void)_displayInterstitialAd
{
    BOOL bannersRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:IAPremoveAdsProductIdentifier];
    if (!bannersRemoved) {
        [self requestInterstitialAdPresentation];
    }
}

- (void)_beginGame
{
    [self.scene layoutNodesWithGrid:[self.gridManager hexagons] completion:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_levelIdx % 28 == 1 || _levelIdx == 1) {
        
        NSString *key = [NSString stringWithFormat:@"%zd",_levelIdx];
        if (![defaults boolForKey:key]) {
            NSString *titleString = [NSString stringWithFormat:@"%@ %tu",NSLocalizedString(@"level", nil),_levelIdx];
            HDAlertView *alertView = [[HDAlertView alloc] initWithTitle:titleString
                                                            description:descriptionForLevelIdx(_levelIdx)
                                                            buttonTitle:NSLocalizedString(@"play", nil)
                                                                  image:[HDHelper imageFromLevelIdx:_levelIdx]];
            [alertView show];
            [defaults setBool:YES forKey:key];
        }
    }
}

- (void)_hideAnimated:(BOOL)animated
{
    dispatch_block_t animate = ^{
        CGRect rect = self.menuBar.frame;
        rect.origin.y = -CGRectGetHeight(self.menuBar.bounds);
        self.menuBar.frame = rect;
    };
    
    if (!animated) {
        animate();
    } else {
        [UIView animateWithDuration:.200f animations:animate];
    }
}

- (void)_showAnimated:(BOOL)animated
{
    dispatch_block_t animate = ^{
        CGRect rect = self.menuBar.frame;
        rect.origin.y = 0.0f;
        self.menuBar.frame = rect;
    };
    
    if (!animated) {
        animate();
    } else {
        [UIView animateWithDuration:.200f animations:animate];
    }
}

#pragma mark - Selectors

- (IBAction)restart:(id)sender
{
    [self.scene restartWithAlert:@(YES)];
    self.scene.userInteractionEnabled = YES;
}

- (void)_restartWithAlert:(BOOL)alert
{
    [self _displayInterstitialAd];
    [self.scene restartWithAlert:@(alert)];
}

- (void)performExitAnimationWithCompletion:(dispatch_block_t)completion
{
    self.navigationBarHidden = YES;

    NSError *error = nil;
    [self bannerView:self.bannerView didFailToReceiveAdWithError:error];
    [self.scene performExitAnimationsWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Notifications

- (void)_applicationDidBecomeActive:(NSNotification *)notification
{
    self.pauseGame = NO;
    self.scene.view.paused = self.pauseGame;
}

- (void)_applicationWillResignActive:(NSNotification *)notification
{
    self.pauseGame = YES;
    self.scene.view.paused = self.pauseGame;
}

#pragma mark - <HDSceneDelegate>

- (void)gameRestartedInScene:(HDScene *)scene alert:(BOOL)alert
{
    [[HDSoundManager sharedManager] playSound:HDGameOverKey];
    if (alert) {
        NSString *titleString = [NSString stringWithFormat:@"%@ %tu",NSLocalizedString(@"level", nil),_levelIdx];
        HDAlertView *alertView = [[HDAlertView alloc] initWithTitle:titleString
                                                        description:NSLocalizedString(@"nextTime", nil)
                                                        buttonTitle:NSLocalizedString(@"dismiss", nil)
                                                              image:[UIImage imageNamed:@"Alert-Mine"]];
        alertView.completionBlock = ^{
            [self _displayInterstitialAd];
        };
        [alertView show];
    }
}

- (void)scene:(HDScene *)scene proceededToLevel:(NSUInteger)level
{
    _levelIdx += 1;
    self.gridManager = [[HDGridManager alloc] initWithLevelIndex:level];
    self.scene.gridManager = self.gridManager;
    [self _beginGame];
}

- (void)scene:(HDScene *)scene gameEndedWithCompletion:(BOOL)completion
{
    if (completion) {
        self.navigationBarHidden = YES;
        
        [[HDSoundManager sharedManager] playSound:HDCompletionZing];
        
        NSString *title = [NSString stringWithFormat:@"%@ %tu",NSLocalizedString(@"level", nil),_levelIdx];
        HDCompletionView *completionView = [[HDCompletionView alloc] initWithTitle:title];
        completionView.delegate = self;
        [completionView show];
        return;
    }
    [self performSelector:@selector(restart:) withObject:nil afterDelay:.300f];
}

- (void)gameWillResetInScene:(HDScene *)scene
{
    self.navigationBarHidden = NO;
}

#pragma mark - <ADBannerViewDelegate>

- (void)_removeAdsWasPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = notification.object;
    if (![productIdentifier isEqualToString:IAPremoveAdsProductIdentifier]) {
        return;
    }
    
    [UIView animateWithDuration:.300f animations:^{
        CGRect bannerFrame = self.bannerView.frame;
        bannerFrame.origin.y = CGRectGetHeight(self.view.bounds);
        self.bannerView.frame = bannerFrame;
    } completion:^(BOOL finished) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_isBannerVisible) {
        [UIView animateWithDuration:.200f animations:^{
            CGRect bannerFrame = self.bannerView.frame;
            bannerFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bannerView.bounds);
            self.bannerView.frame = bannerFrame;
        }];
        _isBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_isBannerVisible) {
        [UIView animateWithDuration:.200f animations:^{
            CGRect bannerFrame = self.bannerView.frame;
            bannerFrame.origin.y = CGRectGetHeight(self.view.bounds);
            self.bannerView.frame = bannerFrame;
        }];
        _isBannerVisible = NO;
    }
}

#pragma mark - <HDCompletionViewDelegate>

- (void)completionView:(HDCompletionView *)completionView selectedButtonWithTag:(NSInteger)tag
{    
    if (tag == 0) {
        self.navigationBarHidden = NO;
        [self _restartWithAlert:NO];
    } else if (tag == 1) {
        [[HDAppDelegate sharedDelegate] rate];
    } else if (tag == 2) {
        [self.scene updateDataForNextLevel];
    } else if (tag == 3) {
        [[HDAppDelegate sharedDelegate] presentActivityViewController];
    }
}

@end
