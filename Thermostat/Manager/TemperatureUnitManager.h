//
//  TemperatureUnitManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>


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

@property (nonatomic, assign) TemperatureUnitType unitType;
@property (nonatomic, readonly) NSString *unitString;

+ (instancetype)sharedManager;

@end
