//
//  TemperatureUnitManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TemperatureUnitManager.h"

#define TEMPERATUREUNIT_SET        @"TemperatureUnit"

static TemperatureUnitManager *_currentTemperatureUnitManager;

@implementation TemperatureUnitManager

@synthesize unitType = _unitType;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentTemperatureUnitManager = [super allocWithZone:zone];
    });
    return _currentTemperatureUnitManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentTemperatureUnitManager = [[self alloc] init];
    });
    return _currentTemperatureUnitManager;
}

- (instancetype)copy {
    return _currentTemperatureUnitManager;
}

- (instancetype)mutableCopy {
    return _currentTemperatureUnitManager;
}

- (NSString *)unitString {
    if (self.unitType == TemperatureUnitTypeFahrenheit) {
        return @"℉";
    } else {
        return @"℃";
    }
}

- (TemperatureUnitType)unitType {
    _unitType = [[NSUserDefaults standardUserDefaults] integerForKey:TEMPERATUREUNIT_SET];
    return _unitType;
}

- (void)setUnitType:(TemperatureUnitType)unitType {
    if (unitType != _unitType) {
        [[NSUserDefaults standardUserDefaults] setInteger:unitType forKey:TEMPERATUREUNIT_SET];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationNameSwitchUnit object:nil];
    }
}

- (CGFloat)fixedTemperatureSetting:(CGFloat)setting {
    if (self.unitType == TemperatureUnitTypeFahrenheit) {
        setting = setting * 1.8 + 32;
    }
    return setting;
}

@end
