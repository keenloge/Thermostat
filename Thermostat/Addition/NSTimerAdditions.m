//
//  NSTimerAdditions.m
//  Thermostat
//
//  Created by Keen on 2017/6/7.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "NSTimerAdditions.h"


@implementation NSTimer (UnRetain)

+ (NSTimer *)hb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hb_blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)hb_blcokInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
