//
//  TaskManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyTarget.h"

@class LinKonTimerTask;

@interface TaskManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - 任务管理

/**
 添加任务
 
 @param task 任务
 */
- (void)addTask:(LinKonTimerTask *)task;

/**
 移除任务
 
 @param number 任务编号
 @param sn 设备SN
 */
- (void)removeTask:(NSString *)number
            device:(NSString *)sn;

/**
 编辑任务
 
 @param task 任务
 */
- (void)editTask:(LinKonTimerTask *)task;

/**
 获取任务
 
 @param number 任务编号
 @param sn 设备SN
 @return 任务
 */
- (LinKonTimerTask *)getTask:(NSString *)number
           device:(NSString *)sn;

#pragma mark - 监听列表

/**
 监听任务列表
 
 @param listener 监听者
 @param sn 设备SN
 @param block 监听回调 Block
 */
- (void)listenTaskList:(id)listener
                device:(NSString *)sn
                 block:(NotifyListBlock)block;

#pragma mark - 监听属性

/**
 监听任务属性
 
 @param listener 监听者
 @param number 任务编号
 @param sn 设备SN
 @param key 属性
 @param block 回调 Block
 */
- (void)registerListener:(id)listener
                    task:(NSString *)number
                  device:(NSString *)sn
                     key:(NSString *)key
                   block:(NotifyTargetBlock)block;

/**
 编辑任务
 
 @param number 任务编号
 @param sn 设备SN
 @param key 任务属性
 @param value 属性值
 */
- (void)editTask:(NSString *)number
          device:(NSString *)sn
             key:(NSString *)key
           value:(id)value;

@end
