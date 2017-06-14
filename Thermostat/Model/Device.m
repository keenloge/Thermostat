//
//  Device.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "Device.h"
#import "Declare.h"
#import "DeviceManager.h"
#import "Globals.h"

// 延时开关时间间隔 30分
const NSTimeInterval MinTimeOffset  = 10;

// 最大延时时间 8小时
const NSTimeInterval MaxTimeOffset  = 70.0;

@implementation Device

+ (instancetype)deviceWithSN:(NSString *)sn {
    Device *item = [[Device alloc] init];
    item.sn = sn;
    return item;
}

- (instancetype)init {
    if (self = [super init]) {
        _connection = ConnectionStateOFF;
        _running = RunningStateOFF;
        _mode = LinKonModeCool;
        _scene = LinKonSceneConstant;
        _wind = LinKonWindLow;
        _setting = 28.0;
        _lock = NO;
        _humidity = 0.60;
        _temperature = 23.5;
    }
    return self;
}

- (NSString *)stateString {
    if (self.connection == ConnectionStateOFF) {
        return [Globals connectionString:self.connection];
    } else if (self.running == RunningStateOFF) {
        return [Globals runningString:self.running];
    } else if (self.mode == LinKonModeAir) {
        return [Globals modeString:self.mode];
    } else {
        return [NSString stringWithFormat:@"%@ %@", [Globals modeString:self.mode], [Globals settingString:self.setting]];
    }
}

- (RunningState)switchRunning {
    if (self.running == RunningStateOFF) {
        return RunningStateON;
    } else {
        return RunningStateOFF;
    }
}

- (LinKonMode)switchMode {
    switch (self.mode) {
        case LinKonModeCool:
            return LinKonModeHot;
        case LinKonModeHot:
            return LinKonModeAir;
        case LinKonModeAir:
            return LinKonModeCool;
        default:
            break;
    }
}

- (LinKonScene)switchScene {
    switch (self.scene) {
        case LinKonSceneConstant:
            return LinKonSceneGreen;
        case LinKonSceneGreen:
            return LinKonSceneLeave;
        case LinKonSceneLeave:
            return LinKonSceneConstant;
        default:
            break;
    }
}

- (LinKonWind)switchWind {
    switch (self.wind) {
        case LinKonWindLow:
            return LinKonWindMedium;
        case LinKonWindMedium:
            return LinKonWindHigh;
        case LinKonWindHigh:
            return LinKonWindLow;
        default:
            break;
    }
}

- (NSTimeInterval)switchDelay {
    if (self.delay < [NSDate timeIntervalSinceReferenceDate]) {
        return [NSDate timeIntervalSinceReferenceDate] + MinTimeOffset;
    } else if (self.delay + MinTimeOffset > [NSDate timeIntervalSinceReferenceDate] + MaxTimeOffset) {
        return 0.0;
    } else {
        return self.delay + MinTimeOffset;
    }
}

- (void)setSetting:(float)setting {
    if (setting < LINKON_TEMPERATURE_MIN) {
        setting = LINKON_TEMPERATURE_MIN;
    } else if (setting > LINKON_TEMPERATURE_MAX) {
        setting = LINKON_TEMPERATURE_MAX;
    }
    
    _setting = roundf(setting * 2.0) / 2.0;
}

- (void)setRunning:(RunningState)running {
    _running = running;
    self.delay = 0.0;
    [[DeviceManager sharedManager] editDevice:self.sn key:KDeviceDelay value:@(self.delay)];
}

@end
