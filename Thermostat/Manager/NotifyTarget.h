//
//  NotifyTarget.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceNotifyManager.h"

/**
 监听实例类
 */
@interface NotifyTarget : NSObject


/**
 监听者
 */
@property (nonatomic, weak) id listener;

/**
 设备唯一标志
 */
@property (nonatomic, assign) long long sn;

/**
 通知类别组合
 */
@property (nonatomic, assign) Byte typeGroup;

/**
 监听回调
 */
@property (nonatomic, copy) DeviceNotifyBlock block;


@end
