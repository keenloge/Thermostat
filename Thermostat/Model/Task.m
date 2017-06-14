//
//  Task.m
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "Task.h"
#import "NSStringAdditions.h"
#import "DeviceManager.h"
#import "Device.h"

const Byte WeekNone     = 0;
const Byte WeekEveryDay = 127;

@implementation Task

- (instancetype)initWithType:(TaskType)type device:(NSString *)sn {
    if (self = [super init]) {
        self.type = type;
        self.sn = sn;
        self.number = [NSString uuidString];
        self.repeat = WeekNone;
        self.validate = YES;
        self.timeFrom = [self minuteToNow];
        if (self.type == TaskTypeSwitch) {
            // 开关
            self.running = NO;
        } else if (self.type == TaskTypeStage) {
            // 阶段
            self.timeTo = self.timeFrom + 30;
        }
        
        Device *device = [[DeviceManager sharedManager] getDevice:sn];
        self.wind = device.wind;
        self.mode = device.mode;
        self.scene = device.scene;
        self.setting = device.setting;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    Task *item = [[[self class] allocWithZone:zone] init];
    item.number = self.number;
    item.sn = self.sn;
    item.type = self.type;
    item.repeat = self.repeat;
    item.validate = self.validate;
    item.timeFrom = self.timeFrom;
    item.timeTo = self.timeTo;
    item.running = self.running;
    item.wind = self.wind;
    item.mode = self.mode;
    item.scene = self.scene;
    item.setting = self.setting;
    return item;
}

- (NSInteger)minuteToNow {
    NSInteger secondInt = [NSDate timeIntervalSinceReferenceDate] + [NSTimeZone systemTimeZone].secondsFromGMT;
    return (secondInt / 60) % (24 * 60);
}

- (Byte)switchRepeatWeak:(Week)week {
    BOOL isCheck = (self.repeat & week) > 0;
    
    if (isCheck) {
        return (~week) & self.repeat;
    } else {
        return week | self.repeat;
    }
}

@end
