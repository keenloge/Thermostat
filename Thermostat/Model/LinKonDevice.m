//
//  LinKonDevice.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonDevice.h"
#import "Declare.h"
#import "DeviceManager.h"
#import "Globals.h"

// 延时开关时间间隔 30分
const NSTimeInterval MinTimeOffset  = 10;

// 最大延时时间 8小时
const NSTimeInterval MaxTimeOffset  = 70.0;

@interface LinKonDevice () {
    
}

@property (nonatomic, strong) NSMutableArray *savedTimerArray;

@end

@implementation LinKonDevice

+ (instancetype)randomDevice {
    LinKonDevice *item = [[LinKonDevice alloc] init];

    [item randomProperty];
    
    return item;
}

+ (instancetype)deviceWithSN:(NSString *)sn password:(NSString *)password {
    LinKonDevice *item = [[LinKonDevice alloc] init];
    
    [item randomProperty];
    item.sn = sn;
    item.password = password;
    item.connection = DeviceConnectionStateOffLine;
    
    return item;
}

+ (LinKonPropertyGroup)groupProperty:(NSString *)key {
    if ([key isEqualToString:KDeviceConnection]
        || [key isEqualToString:KDeviceRunning]) {
        return LinKonPropertyGroupState;
    } else if ([key isEqualToString:KDeviceNickname]
               || [key isEqualToString:KDevicePassword]) {
        return LinKonPropertyGroupBinding;
    } else {
        return LinKonPropertyGroupSetting;
    }
    return LinKonPropertyGroupNone;
}

- (void)randomProperty {
    _sn = [self randomSN];
    
    // 连接状态确定为在线
    _connection = DeviceConnectionStateOnLine;
    
    // 其他属性随机设置
    _nickname = [NSString stringWithFormat:@"%@%02zd", KString(@"温控器"), rand() % 100];
    _password = @"123456";
    _running = (rand() % 100) > 20 ? DeviceRunningStateTurnON : DeviceRunningStateTurnOFF;
    _mode = (rand() % 3) + 1;
    _scene = (rand() % 3) + 1;
    _wind = (rand() % 3) + 1;
    _setting = [self randomTemperature];
    _lock = (rand() % 2) == 0;
    _humidity = (rand() % 100) / 100.0;
    _temperature = [self randomTemperature];
}

- (NSString *)randomSN {
    NSInteger preCode = rand() % 9000 + 1000;
    NSMutableString *tempSN = [NSMutableString stringWithFormat:@"%zd",preCode];
    for (int i = 0; i < 3; i++) {
        preCode = rand() % 10000;
        [tempSN appendFormat:@"%04zd", preCode];
    }
    return [tempSN copy];
}

- (CGFloat)randomTemperature {
    return (rand() % (int)(LINKON_TEMPERATURE_MAX - LINKON_TEMPERATURE_MIN)) + LINKON_TEMPERATURE_MIN;
}

- (NSString *)stateString {
    if (self.connection == DeviceConnectionStateOffLine) {
        return [Globals connectionString:self.connection];
    } else if (self.running == DeviceRunningStateTurnOFF) {
        return [Globals runningString:self.running];
    } else if (self.mode == LinKonModeAir) {
        return [Globals modeString:self.mode];
    } else {
        return [NSString stringWithFormat:@"%@ %@", [Globals modeString:self.mode], [Globals settingString:self.setting]];
    }
}

- (DeviceRunningState)switchRunning {
    if (self.running == DeviceRunningStateTurnOFF) {
        return DeviceRunningStateTurnON;
    } else {
        return DeviceRunningStateTurnOFF;
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

- (void)setTemperature:(float)temperature {
    if (temperature < LINKON_TEMPERATURE_MIN) {
        temperature = LINKON_TEMPERATURE_MIN;
    } else if (temperature > LINKON_TEMPERATURE_MAX) {
        temperature = LINKON_TEMPERATURE_MAX;
    }
    
    _temperature = roundf(temperature * 2.0) / 2.0;
}

- (void)setRunning:(DeviceRunningState)running {
    _running = running;
//    self.delay = 0.0;
    [[DeviceManager sharedManager] editDevice:self.sn key:KDeviceDelay value:@(0.0)];
}

#pragma mark - 定时器

- (NSMutableArray *)savedTimerArray {
    if (!_savedTimerArray) {
        _savedTimerArray = [NSMutableArray array];
    }
    return _savedTimerArray;
}

- (NSArray *)timerArray {
    return [self.savedTimerArray copy];
}

- (BOOL)addTimerTask:(LinKonTimerTask *)timer {
    for (LinKonTimerTask *item in self.savedTimerArray) {
        if ([item.number isEqualToString:timer.number] || [item isConflictTo:timer]) {
            // 与现有定时器发生冲突
            return NO;
        }
    }
    
    [self.savedTimerArray addObject:timer];
    
    return YES;
}

- (BOOL)removeTimerTask:(LinKonTimerTask *)timer {
    for (LinKonTimerTask *item in self.savedTimerArray) {
        if ([item.number isEqualToString:timer.number]) {
            [self.savedTimerArray removeObject:item];
            return YES;
        }
    }
    return NO;
}

- (BOOL)editTimerTask:(LinKonTimerTask *)timer {
    for (LinKonTimerTask *item in self.savedTimerArray) {
        if (![item.number isEqualToString:timer.number] && [item isConflictTo:timer]) {
            // 与现有定时器发生冲突
            return NO;
        }
    }
    
    for (int i = 0; i < self.savedTimerArray.count; i++) {
        LinKonTimerTask *item = [self.savedTimerArray objectAtIndex:i];
        if ([item.number isEqualToString:timer.number]) {
            [self.savedTimerArray removeObjectAtIndex:i];
            [self.savedTimerArray insertObject:timer atIndex:i];
            return YES;
        }
    }
    
    // 没找到, 当冲突处理
    return NO;
}

@end
