//
//  DeviceInfoView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"
#import "DeviceCircleView.h"

@interface DeviceInfoView : BaseView

- (void)updateLockImageAlpha:(CGFloat)alpha;
- (void)updateSceneImage:(UIImage *)image alpha:(CGFloat)alpha;
- (void)updateWindImage:(UIImage *)image alpha:(CGFloat)alpha;

- (void)updateRoundImage:(UIImage *)image
               colorFrom:(UIColor *)colorFrom
                 colorTo:(UIColor *)colorTo;

- (void)updateHumidityString:(NSString *)text;

- (void)updateTemperatureString:(NSString *)text;

- (void)updateStateString:(NSString *)state
                  setting:(NSString *)setting
                     mode:(NSString *)mode
                     unit:(NSString *)unit;

- (void)updateTimerOffset:(NSInteger)timeOffset
                    image:(UIImage *)image
                    block:(DeviceDelayTimerFinishBlock)block;

@end
