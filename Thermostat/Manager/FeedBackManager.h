//
//  FeedBackManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackManager : NSObject

@property (nonatomic, assign, getter=isSound) BOOL sound;
@property (nonatomic, assign, getter=isVibrate) BOOL vibrate;

+ (instancetype)sharedManager;


/**
 点击
 */
- (void)vibrateSoundClick;


/**
 开机
 */
- (void)vibrateSoundTurnOn;


/**
 关机
 */
- (void)vibrateSoundTurnOff;

@end
