//
//  LinKonTimerRange.m
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonTimerRange.h"

@implementation LinKonTimerRange

+ (instancetype)rangeWithRepeat:(TimerRepeat)repeat timeFrom:(NSInteger)timeFrom timeTo:(NSInteger)timeTo {
    LinKonTimerRange *item = [[LinKonTimerRange alloc] init];
    
//    item.repeat = repeat;
//    item.timeFrom = timeFrom;
//    item.timeTo = timeTo;

    // 新版算法开始
    NSInteger offsetTime = log2(repeat) * 24 * 60;
    item.timeFrom = timeFrom + offsetTime;
    item.timeTo = timeTo + offsetTime;
    // 新版算法结束
    
    return item;
}

+ (NSArray *)rangeArrayWithRepeat:(TimerRepeat)repeat timeFrom:(NSInteger)timeFrom timeTo:(NSInteger)timeTo {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (timeTo < 0) {
        // 结束时间无效, 说明是开关定时器
        LinKonTimerRange *subRange = [LinKonTimerRange rangeWithRepeat:repeat timeFrom:timeFrom timeTo:timeFrom];
        [resultArray addObject:subRange];
    } else {
        if (timeTo <= timeFrom) {
            // 需持续到第二天
            if (repeat == (1 << 6)) {
                // 周期最后一天, 需跨到第二个周期
                LinKonTimerRange *currentRange = [LinKonTimerRange rangeWithRepeat:repeat timeFrom:timeFrom timeTo:24 * 60 - 1];
                LinKonTimerRange *nextRange = [LinKonTimerRange rangeWithRepeat:1 timeFrom:0 timeTo:timeTo];
                [resultArray addObject:currentRange];
                [resultArray addObject:nextRange];
            } else {
                // 本周期内
                LinKonTimerRange *subRange = [LinKonTimerRange rangeWithRepeat:repeat timeFrom:timeFrom timeTo:timeTo + 24 * 60];
                [resultArray addObject:subRange];
            }
        } else {
            // 当天完成
            LinKonTimerRange *subRange = [LinKonTimerRange rangeWithRepeat:repeat timeFrom:timeFrom timeTo:timeTo];
            [resultArray addObject:subRange];
        }
    }
    
    return resultArray;
}

@end
