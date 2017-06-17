//
//  Globals.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "Globals.h"
#import "TemperatureUnitManager.h"

@implementation Globals

+ (id)addedSubViewClass:(Class)class toView:(UIView *)superView {
    UIView *subView = [[class alloc] init];
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superView addSubview:subView];
    return subView;
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
        default:
            break;
    }
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

@end
