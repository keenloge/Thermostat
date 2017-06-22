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
    
    item.repeat = repeat;
    item.timeFrom = timeFrom;
    item.timeTo = timeTo;
    
    return item;
}

@end
