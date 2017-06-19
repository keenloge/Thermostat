//
//  TemperatureUnitManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNotificationNameSwitchUnit @"SwitchUnit"

/**
 温度单位

 - TemperatureUnitTypeCentigrade: 摄氏度
 - TemperatureUnitTypeFahrenheit: 华氏度
 */
typedef NS_ENUM(NSInteger, TemperatureUnitType) {
    TemperatureUnitTypeCentigrade = 0,
    TemperatureUnitTypeFahrenheit = 1,
};

@interface TemperatureUnitManager : NSObject


/**
 当前单位类别
 */
@property (nonatomic, assign) TemperatureUnitType unitType;


/**
 当前单位字符串
 */
@property (nonatomic, readonly) NSString *unitString;

+ (instancetype)sharedManager;


/**
 修正温度数值

 @param setting 摄氏度温度数值
 @return 修正后的温度数值
 */
- (CGFloat)fixedTemperatureSetting:(CGFloat)setting;

@end
