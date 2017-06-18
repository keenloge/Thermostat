//
//  DeviceManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyTarget.h"

@class LinKonDevice;
@class LinKonTimerTask;

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

- (void)addDevice:(LinKonDevice *)item;

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

- (LinKonDevice *)getDevice:(NSString *)sn;

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
 @param group 属性组
 @param block 回调 Block
 */
- (void)registerListener:(id)listener
                  device:(NSString *)sn
                   group:(Byte)group
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

#pragma mark - 定时器

/**
 获取任务
 
 @param number 任务编号
 @param sn 设备SN
 @return 任务
 */
- (LinKonTimerTask *)getTask:(NSString *)number
                      device:(NSString *)sn;

/**
 添加定时器

 @param timer 定时器
 @param sn 设备SN
 @return 是否添加成功
 */
- (BOOL)addTimerTask:(LinKonTimerTask *)timer toDevice:(NSString *)sn;


/**
 移除定时器
 
 @param timer 定时器
 @param sn 设备SN
 @return 是否移除成功
 */
- (BOOL)removeTimerTask:(LinKonTimerTask *)timer toDevice:(NSString *)sn;


/**
 修改定时器
 
 @param timer 定时器
 @param sn 设备SN
 @return 是否修改成功
 */
- (BOOL)editTimerTask:(LinKonTimerTask *)timer toDevice:(NSString *)sn;

@end
