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

@end
