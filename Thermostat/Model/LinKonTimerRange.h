//
//  LinKonTimerRange.h
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinKonTimerRange : NSObject

@property (nonatomic, assign) TimerRepeat repeat;
@property (nonatomic, assign) NSInteger timeFrom;
@property (nonatomic, assign) NSInteger timeTo;
@property (nonatomic, assign) NSInteger timeAt;

+ (instancetype)rangeWithRepeat:(TimerRepeat)repeat timeAt:(NSInteger)timeAt;
+ (instancetype)rangeWithRepeat:(TimerRepeat)repeat timeFrom:(NSInteger)timeFrom timeTo:(NSInteger)timeTo;

@end
