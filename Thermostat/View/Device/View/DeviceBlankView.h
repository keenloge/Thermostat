//
//  DeviceBlankView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

typedef void(^DeviceBlankBlock)();

@interface DeviceBlankView : BaseView

@property (nonatomic, copy) DeviceBlankBlock block;

@end
