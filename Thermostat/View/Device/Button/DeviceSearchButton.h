//
//  DeviceSearchButton.h
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseButton.h"

typedef void(^DeviceSearchBlock)();

@interface DeviceSearchButton : BaseButton

@property (nonatomic, copy) DeviceSearchBlock block;

@end
