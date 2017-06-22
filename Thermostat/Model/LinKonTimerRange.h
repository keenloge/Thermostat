//
//  LinKonTimerRange.h
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinKonTimerRange : NSObject


/**
 星期几
 */
@property (nonatomic, assign) TimerRepeat repeat;


/**
 起始时间
 */
@property (nonatomic, assign) NSInteger timeFrom;


/**
 结束时间
 */
@property (nonatomic, assign) NSInteger timeTo;


+ (instancetype)rangeWithRepeat:(TimerRepeat)repeat timeFrom:(NSInteger)timeFrom timeTo:(NSInteger)timeTo;

@end
