//
//  NSTimerAdditions.h
//  Thermostat
//
//  Created by Keen on 2017/6/7.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (UnRetain)

+ (NSTimer *)hb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
