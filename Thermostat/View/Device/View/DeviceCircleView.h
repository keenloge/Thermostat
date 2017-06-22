//
//  DeviceCircleView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

typedef void(^DeviceDelayTimerFinishBlock)();

@interface DeviceCircleView : BaseView

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
