//
//  TemperaturePickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"

typedef void(^TemperaturePickerBlock)(float value);

@interface TemperaturePickerPage : BasePickerPage

- (instancetype)initWithSetting:(float)setting
                          block:(TemperaturePickerBlock)block;

@end
