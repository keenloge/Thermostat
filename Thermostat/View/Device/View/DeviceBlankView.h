//
//  DeviceBlankView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

typedef void(^DeviceBlankBlock)();


/**
 设备列表空白界面
 */
@interface DeviceBlankView : BaseView


/**
 点击"搜索设备"回调
 */
@property (nonatomic, copy) DeviceBlankBlock block;

@end
