//
//  FeedBackManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "FeedBackManager.h"

#define FEEDBACK_SOUND_SET      @"FeedBack_Sound"
#define FEEDBACK_VIBRATE_SET    @"FeedBack_Vibrate"

static FeedBackManager *_currentFeedBackManager;

@implementation FeedBackManager

@synthesize sound = _sound;
@synthesize vibrate = _vibrate;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentFeedBackManager = [super allocWithZone:zone];
    });
    return _currentFeedBackManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentFeedBackManager = [[self alloc] init];
    });
    return _currentFeedBackManager;
}

- (instancetype)copy {
    return _currentFeedBackManager;
}

- (instancetype)mutableCopy {
    return _currentFeedBackManager;
}



- (BOOL)isSound {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FEEDBACK_SOUND_SET]) {
        _sound = [[NSUserDefaults standardUserDefaults] boolForKey:FEEDBACK_SOUND_SET];
    } else {
        _sound = YES;
        [[NSUserDefaults standardUserDefaults] setBool:_sound forKey:FEEDBACK_SOUND_SET];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return _sound;
}

- (void)setSound:(BOOL)sound {
    _sound = sound;
    
    [[NSUserDefaults standardUserDefaults] setBool:_sound forKey:FEEDBACK_SOUND_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isVibrate {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FEEDBACK_VIBRATE_SET]) {
        _vibrate = [[NSUserDefaults standardUserDefaults] boolForKey:FEEDBACK_VIBRATE_SET];
    } else {
        _vibrate = YES;
        [[NSUserDefaults standardUserDefaults] setBool:_vibrate forKey:FEEDBACK_VIBRATE_SET];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return _vibrate;
}

- (void)setVibrate:(BOOL)vibrate {
    _vibrate = vibrate;
    
    [[NSUserDefaults standardUserDefaults] setBool:_vibrate forKey:FEEDBACK_VIBRATE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
