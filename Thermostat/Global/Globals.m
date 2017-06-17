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

+ (NSString *)connectionString:(ConnectionState)connection {
    switch (connection) {
        case ConnectionStateOFF:
            return KString(@"离线");
        case ConnectionStateON:
            return KString(@"在线");
        default:
            break;
    }
    return nil;
}

+ (NSString *)runningString:(RunningState)running {
    switch (running) {
        case RunningStateON:
            return KString(@"开机");
        case RunningStateOFF:
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

+ (NSString *)weekString:(Week)week {
    switch (week) {
        case WeekMonday:
            return KString(@"一");
        case WeekTuesday:
            return KString(@"二");
        case WeekWednesday:
            return KString(@"三");
        case WeekThursday:
            return KString(@"四");
        case WeekFriday:
            return KString(@"五");
        case WeekSaturday:
            return KString(@"六");
        case WeekSunday:
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
    if (repeat == WeekEveryDay) {
        return KString(@"每日");
    } else if (repeat == WeekNone) {
        return @"";
    } else {
        static NSArray *weekArray = nil;
        if (!weekArray) {
            weekArray = @[
                          @(WeekMonday),
                          @(WeekTuesday),
                          @(WeekWednesday),
                          @(WeekThursday),
                          @(WeekFriday),
                          @(WeekSaturday),
                          @(WeekSunday),
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
