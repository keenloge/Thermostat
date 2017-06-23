//
//  LinKonHelper.m
//  Thermostat
//
//  Created by Keen on 2017/6/21.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonHelper.h"
#import "TemperatureUnitManager.h"

// 延时开关时间间隔 30分
const NSTimeInterval MinTimeOffset  = 10;

// 最大延时时间 8小时
const NSTimeInterval MaxTimeOffset  = 70.0;

@implementation LinKonHelper

+ (NSString *)formatSN:(long long)snLong {
    NSString *sn = [NSString stringWithFormat:@"%lld",snLong];
    
    NSInteger formatLength = 4;
    if (sn.length % formatLength == 0) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSString *subString = nil;
        for (int i = 0; i < sn.length / formatLength; i++) {
            subString = [sn substringWithRange:NSMakeRange(i * formatLength, formatLength)];
            [tempArray addObject:subString];
        }
        return [tempArray componentsJoinedByString:@" "];
    } else {
        return sn;
    }
}

+ (NSString *)connectionString:(DeviceConnectionState)connection {
    switch (connection) {
        case DeviceConnectionStateOffLine:
            return KString(@"离线");
        case DeviceConnectionStateOnLine:
            return KString(@"在线");
        default:
            break;
    }
    return nil;
}

+ (NSString *)runningString:(DeviceRunningState)running {
    switch (running) {
        case DeviceRunningStateTurnON:
            return KString(@"开机");
        case DeviceRunningStateTurnOFF:
            return KString(@"待机");
        default:
            break;
    }
    return nil;
}

+ (NSString *)windString:(LinKonWind)wind {
    switch (wind) {
        case LinKonWindLow:
            return KString(@"低风");
        case LinKonWindMedium:
            return KString(@"中风");
        case LinKonWindHigh:
            return KString(@"高风");
        default:
            break;
    }
    return nil;
}

+ (NSString *)windShortString:(LinKonWind)wind {
    switch (wind) {
        case LinKonWindLow:
            return KString(@"低");
        case LinKonWindMedium:
            return KString(@"中");
        case LinKonWindHigh:
            return KString(@"高");
        default:
            break;
    }
    return nil;
}


+ (NSString *)modeString:(LinKonMode)mode {
    switch (mode) {
        case LinKonModeHot:
            return KString(@"制热");
        case LinKonModeCool:
            return KString(@"制冷");
        case LinKonModeAir:
            return KString(@"换气");
        default:
            break;
    }
}

+ (NSString *)sceneString:(LinKonScene)scene {
    switch (scene) {
        case LinKonSceneGreen:
            return KString(@"节能");
        case LinKonSceneConstant:
            return KString(@"恒温");
        case LinKonSceneLeave:
            return KString(@"离家");
        default:
            break;
    }
    return nil;
}

+ (NSString *)weekString:(TimerRepeat)week {
    switch (week) {
        case TimerRepeatMonday:
            return KString(@"一");
        case TimerRepeatTuesday:
            return KString(@"二");
        case TimerRepeatWednesday:
            return KString(@"三");
        case TimerRepeatThursday:
            return KString(@"四");
        case TimerRepeatFriday:
            return KString(@"五");
        case TimerRepeatSaturday:
            return KString(@"六");
        case TimerRepeatSunday:
            return KString(@"日");
        case TimerRepeatEveryDay:
            return KString(@"全");
        default:
            break;
    }
    return nil;
}

+ (NSString *)settingString:(float)setting {
    return [NSString stringWithFormat:@"%.1f%@", [[TemperatureUnitManager sharedManager] fixedTemperatureSetting:setting], [TemperatureUnitManager sharedManager].unitString];
}

+ (NSString *)timeString:(NSInteger)time {
    NSInteger hour = time / 60;
    NSInteger minute = time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd", hour, minute];
}

+ (NSString *)repeatString:(Byte)repeat {
    if (repeat == TimerRepeatEveryDay) {
        return KString(@"每日");
    } else if (repeat == TimerRepeatNone) {
        return @"";
    } else {
        static NSArray *weekArray = nil;
        if (!weekArray) {
            weekArray = @[
                          @(TimerRepeatMonday),
                          @(TimerRepeatTuesday),
                          @(TimerRepeatWednesday),
                          @(TimerRepeatThursday),
                          @(TimerRepeatFriday),
                          @(TimerRepeatSaturday),
                          @(TimerRepeatSunday),
                          ];
        }
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i = 0; i < weekArray.count; i++) {
            Byte week = [[weekArray objectAtIndex:i] intValue];
            if ((week & repeat) == week) {
                [titleArray addObject:[self weekString:week]];
            }
        }
        
        NSString *repeatTitle = [titleArray componentsJoinedByString:KString(@"、")];
        return [NSString stringWithFormat:@"%@%@", KString(@"周"), repeatTitle];
    }
}

+ (NSString *)stateString:(LinKonDevice *)device {
    if (device.connection == DeviceConnectionStateOffLine) {
        return [self connectionString:device.connection];
    } else if (device.running == DeviceRunningStateTurnOFF) {
        return [self runningString:device.running];
    } else if (device.mode == LinKonModeAir) {
        return [self modeString:device.mode];
    } else {
        return [NSString stringWithFormat:@"%@ %@", [self modeString:device.mode], [self settingString:device.setting]];
    }
}

+ (UIColor *)stateColor:(LinKonDevice *)device {
    if (device.connection == DeviceConnectionStateOffLine) {
        return HB_COLOR_BASE_RED;
    } else if (device.running == DeviceRunningStateTurnOFF) {
        return HB_COLOR_BASE_GREEN;
    } else {
        return HB_COLOR_BASE_GRAY;
    }
}

#pragma mark - 循环切换

+ (DeviceRunningState)switchRunning:(DeviceRunningState)running {
    if (running == DeviceRunningStateTurnOFF) {
        return DeviceRunningStateTurnON;
    } else {
        return DeviceRunningStateTurnOFF;
    }
}

+ (LinKonMode)switchMode:(LinKonMode)mode {
    switch (mode) {
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

+ (LinKonScene)switchScene:(LinKonScene)scene {
    switch (scene) {
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

+ (LinKonWind)switchWind:(LinKonWind)wind {
    switch (wind) {
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

+ (NSTimeInterval)switchDelay:(NSTimeInterval)delay {
    if (delay < [NSDate timeIntervalSinceReferenceDate]) {
        return [NSDate timeIntervalSinceReferenceDate] + MinTimeOffset;
    } else if (delay + MinTimeOffset > [NSDate timeIntervalSinceReferenceDate] + MaxTimeOffset) {
        return 0.0;
    } else {
        return delay + MinTimeOffset;
    }
}


@end
