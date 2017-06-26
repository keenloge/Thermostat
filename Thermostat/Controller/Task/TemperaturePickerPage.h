//
//  TemperaturePickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"

typedef void(^TemperaturePickerBlock)(float value);


/**
 温度选择控制器
 */
@interface TemperaturePickerPage : BasePickerPage


/**
 初始化温度选择控制器

 @param setting 设定温度
 @param block 温度选定回调
 @return 温度选择控制器
 */
- (instancetype)initWithSetting:(float)setting
                          block:(TemperaturePickerBlock)block;

@end
