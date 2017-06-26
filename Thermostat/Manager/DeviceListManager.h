//
//  DeviceListManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseDevice;

#define KDeviceListAdd     @"listAdd"
#define KDeviceListRemove  @"listRemove"


@interface DeviceListManager : NSObject


/**
 获取设备管理类

 @return 设备管理
 */
+ (instancetype)sharedManager;

#pragma mark 设备管理

/**
 添加设备
 
 @param device 设备
 */

- (void)addDevice:(BaseDevice *)device;

/**
 移除设备
 
 @param sn 序列号
 */

- (void)removeDevice:(long long)sn;

/**
 获取设备
 
 @param sn 序列号
 @return 设备
 */

- (BaseDevice *)getDevice:(long long)sn;



/**
 获取设备列表

 @return 设备列表
 */
- (NSArray *)getDeviceList;

@end
