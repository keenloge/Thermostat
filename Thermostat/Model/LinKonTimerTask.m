//
//  LinKonTimerTask.m
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonTimerTask.h"
#import "NSStringAdditions.h"
#import "DeviceManager.h"
#import "LinKonDevice.h"
#import "LinKonTimerRange.h"

const Byte TimerRepeatNone     = 0;
const Byte TimerRepeatEveryDay = 127;

// 定时器最大时间
const NSInteger LinKonTimerTimeMax = 24 * 60 - 1;

// 定时器最小时间
const NSInteger LinKonTimerTimeMin = 0;

@interface LinKonTimerTask ()

@property (nonatomic, strong) NSArray *rangeArray;

@end

@implementation LinKonTimerTask

- (instancetype)initWithType:(LinKonTimerTaskType)type device:(NSString *)sn {
    if (self = [super init]) {
        self.type = type;
        self.number = [NSString uuidString];
        self.repeat = TimerRepeatNone;
        self.validate = YES;
        self.timeFrom = [self minuteToNow];
        if (self.type == LinKonTimerTaskTypeSwitch) {
            // 开关
            self.running = DeviceRunningStateTurnOFF;
        } else if (self.type == LinKonTimerTaskTypeStage) {
            // 阶段
            self.timeTo = self.timeFrom + 30;
        }
        
        LinKonDevice *device = [[DeviceManager sharedManager] getDevice:sn];
        self.wind = device.wind;
        self.mode = device.mode;
        self.scene = device.scene;
        self.setting = device.setting;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    LinKonTimerTask *item = [[[self class] allocWithZone:zone] init];
    item.number = self.number;
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

- (Byte)switchRepeatWeak:(TimerRepeat)week {
    BOOL isCheck = (self.repeat & week) > 0;
    
    if (isCheck) {
        return (~week) & self.repeat;
    } else {
        return week | self.repeat;
    }
}

- (BOOL)isConflictTo:(LinKonTimerTask *)task {
    // 有一个定时器无效, 则不冲突
    if (!self.validate || !task.validate) {
        return NO;
    }
    
    // 定时器类型不一样, 则不冲突
    if (self.type != task.type) {
        return NO;
    }
    
    if (self.type == LinKonTimerTaskTypeSwitch) {
        // 开关
        for (LinKonTimerRange *outRange in self.rangeArray) {
            for (LinKonTimerRange *inRange in task.rangeArray) {
                if (outRange.repeat == inRange.repeat && outRange.timeAt == inRange.timeAt) {
                    return YES;
                }
            }
        }
    } else {
        // 阶段
        for (LinKonTimerRange *outRange in self.rangeArray) {
            for (LinKonTimerRange *inRange in task.rangeArray) {
                if (outRange.repeat == inRange.repeat) {
                    if (!(outRange.timeFrom > inRange.timeTo || outRange.timeTo < inRange.timeFrom)) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

- (void)resetTimerRange {
    self.rangeArray = nil;
}

- (NSArray *)rangeArray {
    if (!_rangeArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        
        if (self.repeat == TimerRepeatNone) {
            // 非周期定时器
            
            // 今天是周几
            TimerRepeat repeatNow = [self currentTimerRepeat];
            // 明天是周几
            TimerRepeat repeatNext = [self nextRepeat:repeatNow];
            // 后天是周几
            TimerRepeat repeatAfter = [self nextRepeat:repeatNext];

            // 现在时间
            NSInteger timeNow = [self minuteToNow];
            
            if (self.type == LinKonTimerTaskTypeSwitch) {
                // 开关定时器
                if (self.timeFrom > timeNow) {
                    // 今天生效的定时器
                    LinKonTimerRange *rangeNow = [LinKonTimerRange rangeWithRepeat:repeatNow timeAt:self.timeFrom];
                    [tempArray addObject:rangeNow];
                } else {
                    // 明天生效的定时器
                    LinKonTimerRange *rangeNext = [LinKonTimerRange rangeWithRepeat:repeatNext timeAt:self.timeFrom];
                    [tempArray addObject:rangeNext];
                }
            } else {
                // 阶段定时任务
                if (self.timeFrom < self.timeTo) {
                    // 当天开始到当天结束的阶段定时任务
                    if (self.timeFrom > timeNow) {
                        // 今天的阶段任务
                        LinKonTimerRange *rangeNow = [LinKonTimerRange rangeWithRepeat:repeatNow timeFrom:self.timeFrom timeTo:self.timeTo];
                        [tempArray addObject:rangeNow];
                    } else {
                        // 明天的阶段任务
                        LinKonTimerRange *rangeNext = [LinKonTimerRange rangeWithRepeat:repeatNext timeFrom:self.timeFrom timeTo:self.timeTo];
                        [tempArray addObject:rangeNext];
                    }
                } else {
                    // 需要延续到第二天的阶段定时任务
                    if (self.timeFrom > timeNow) {
                        // 从今天延续到明天阶段定时任务
                        LinKonTimerRange *rangeNow = [LinKonTimerRange rangeWithRepeat:repeatNow timeFrom:self.timeFrom timeTo:LinKonTimerTimeMax];
                        [tempArray addObject:rangeNow];

                        LinKonTimerRange *rangeNext = [LinKonTimerRange rangeWithRepeat:repeatNext timeFrom:LinKonTimerTimeMin timeTo:self.timeTo];
                        [tempArray addObject:rangeNext];
                    } else {
                        // 从明天延续到后天的阶段定时任务
                        LinKonTimerRange *rangeNext = [LinKonTimerRange rangeWithRepeat:repeatNext timeFrom:self.timeFrom timeTo:LinKonTimerTimeMax];
                        [tempArray addObject:rangeNext];

                        LinKonTimerRange *rangeAfter = [LinKonTimerRange rangeWithRepeat:repeatAfter timeFrom:LinKonTimerTimeMin timeTo:self.timeTo];
                        [tempArray addObject:rangeAfter];
                    }
                }
            }
        } else {
            // 起始周期
            TimerRepeat repeatBegin = TimerRepeatMonday;
            // 周期总数
            NSInteger repeatCount = 7;
            
            // 周期定时器
            if (self.type == LinKonTimerTaskTypeSwitch) {
                // 开关定时器
                for (int i = 0; i < repeatCount; i++) {
                    if (((repeatBegin << i) & self.repeat) > 0) {
                        LinKonTimerRange *range = [LinKonTimerRange rangeWithRepeat:repeatBegin << i timeAt:self.timeFrom];
                        [tempArray addObject:range];
                    }
                }
            } else {
                // 阶段定时器
                if (self.timeFrom < self.timeTo) {
                    // 当天开始到当天结束的阶段定时任务
                    for (int i = 0; i < repeatCount; i++) {
                        if (((repeatBegin << i) & self.repeat) > 0) {
                            LinKonTimerRange *range = [LinKonTimerRange rangeWithRepeat:repeatBegin << i timeFrom:self.timeFrom timeTo:self.timeTo];
                            [tempArray addObject:range];
                        }
                    }
                } else {
                    // 需要延续到第二天的阶段定时任务
                    for (int i = 0; i < repeatCount; i++) {
                        TimerRepeat tempRepeat = repeatBegin << i;
                        if (((tempRepeat) & self.repeat) > 0) {
                            LinKonTimerRange *range = [LinKonTimerRange rangeWithRepeat:tempRepeat timeFrom:self.timeFrom timeTo:LinKonTimerTimeMax];
                            [tempArray addObject:range];
                            
                            TimerRepeat repeatNext = [self nextRepeat:tempRepeat];
                            LinKonTimerRange *rangeNext = [LinKonTimerRange rangeWithRepeat:repeatNext timeFrom:LinKonTimerTimeMin timeTo:self.timeTo];
                            [tempArray addObject:rangeNext];
                        }
                    }
                }
            }
        }
        
        _rangeArray = [tempArray copy];
    }
    return _rangeArray;
}

- (TimerRepeat)currentTimerRepeat {
    static NSCalendar *calendar = nil;
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [calendar setTimeZone: timeZone];
    }
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    
    // weekday 从周日开始, 1 = 周日 , 2 = 周一 以此类推 7 = 周六
    NSInteger weekday = theComponents.weekday;
    if (weekday == 1) {
        weekday = 8;
    }
    weekday -= 2;
    return TimerRepeatMonday << weekday;
}

- (TimerRepeat)nextRepeat:(TimerRepeat)repeatNow {
    return repeatNow == TimerRepeatSunday ? TimerRepeatMonday : repeatNow << 1;
}

@end
