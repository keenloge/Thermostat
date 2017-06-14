//
//  DeviceManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyTarget.h"

@class Device;

@interface DeviceManager : NSObject


/**
 获取设备管理类

 @return 设备管理
 */
+ (instancetype)sharedManager;

#pragma mark 设备管理

/**
 添加设备
 
 @param item 设备
 */

- (void)addDevice:(Device *)item;

/**
 移除设备
 
 @param sn 设备SN
 */

- (void)removeDevice:(NSString *)sn;

/**
 获取设备
 
 @param sn 设备SN
 @return 设备
 */

- (Device *)getDevice:(NSString *)sn;

#pragma mark 列表监听

/**
 监听设备列表
 
 @param listener 监听者
 @param block 监听回调 Block
 */
- (void)listenDeviceList:(id)listener
                   block:(NotifyListBlock)block;

#pragma mark - 监听属性

/**
 监听属性
 
 @param listener 监听者
 @param sn 设备SN
 @param key 属性
 @param block 回调 Block
 */
- (void)registerListener:(id)listener
                  device:(NSString *)sn
                     key:(NSString *)key
                   block:(NotifyTargetBlock)block;

/**
 编辑对象属性
 
 @param sn 设备SN
 @param key 属性
 @param value 属性值
 */
- (void)editDevice:(NSString *)sn
               key:(NSString *)key
             value:(id)value;

@end
