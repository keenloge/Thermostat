//
//  DeviceManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceManager.h"
#import "LinKonDevice.h"

static DeviceManager *_currentDeviceManager;

@interface DeviceManager ()


/**
 设备列表
 */
@property (nonatomic, strong) NSMutableArray<LinKonDevice*> *deviceArray;


/**
 列表监听对象
 */
@property (nonatomic, strong) NSMutableArray<NotifyTarget*> *listBlockArray;


/**
 属性监听对象
 */
@property (nonatomic, strong) NSMutableArray<NotifyTarget*> *editBlockArray;


@end

@implementation DeviceManager

#pragma mark - 单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDeviceManager = [super allocWithZone:zone];
    });
    return _currentDeviceManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDeviceManager = [[self alloc] init];
    });
    return _currentDeviceManager;
}

- (instancetype)copy {
    return _currentDeviceManager;
}

- (instancetype)mutableCopy {
    return _currentDeviceManager;
}

#pragma mark - Getter

- (NSMutableArray *)deviceArray {
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}

- (NSMutableArray *)listBlockArray {
    if (!_listBlockArray) {
        _listBlockArray = [NSMutableArray array];
    }
    return _listBlockArray;
}

- (NSMutableArray *)editBlockArray {
    if (!_editBlockArray) {
        _editBlockArray = [NSMutableArray array];
    }
    return _editBlockArray;
}

#pragma mark 设备管理

/**
 添加设备
 
 @param item 设备
 */

- (void)addDevice:(LinKonDevice *)item {
    if (!item.sn) {
        return;
    }
    
    // 移除重复的设备
    [self removeDevice:item.sn notify:NO];
    
    // 添加设备
    [self.deviceArray addObject:item];
    
    // 通知监听了设备列表的对象
    [self notifyBlockList];
}

/**
 移除设备
 
 @param sn 设备SN
 */

- (void)removeDevice:(NSString *)sn {
    [self removeDevice:sn notify:YES];
}


/**
 移除设备

 @param sn 设备SN
 @param notify 是否通知
 */
- (void)removeDevice:(NSString *)sn notify:(BOOL)notify {
    if (!sn) {
        return;
    }
    
    for (int i = 0; i < self.deviceArray.count; i++) {
        LinKonDevice *device = [self.deviceArray objectAtIndex:i];
        if ([device.sn isEqualToString:sn]) {
            [self.deviceArray removeObjectAtIndex:i];
            
            if (notify) {
                [self notifyBlockList];
            }
            
            // 移除相关设备通知
            [self resignListenerTargetWithDevice:device];
        }
    }
}

/**
 获取设备
 
 @param sn 设备SN
 @return 设备
 */

- (LinKonDevice *)getDevice:(NSString *)sn {
    if (!sn) {
        return nil;
    }
    
    for (LinKonDevice *item in self.deviceArray) {
        if ([sn isEqualToString:item.sn]) {
            return item;
        }
    }
    return nil;
}

#pragma mark 列表监听

/**
 监听设备列表
 
 @param listener 监听者
 @param block 监听回调 Block
 */
- (void)listenDeviceList:(id)listener
                   block:(NotifyListBlock)block {
    
    if (!listener || !block) {
        return;
    }
    
    NotifyTarget *target = nil;
    for (int i = 0; i < self.listBlockArray.count; i++) {
        NotifyTarget *item = [self.listBlockArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [self.listBlockArray removeObjectAtIndex:i];
            i--;
            continue;
        }
        
        if (item.listener == listener) {
            // 之前已经注册过, 无需新建
            target = item;
            break;
        }
    }
    
    if (!target) {
        // 全新的一次注册
        target = [[NotifyTarget alloc] init];
        target.listener = listener;
        [self.listBlockArray addObject:target];
    }
    
    target.listBlock = block;
    
    // 立即通知
    if (block) {
        block([self.deviceArray copy]);
    }
}


/**
 通知监听列表回调
 */
- (void)notifyBlockList {
    for (int i = 0; i < self.listBlockArray.count; i++) {
        NotifyTarget *target = [self.listBlockArray objectAtIndex:i];
        if (!target.listener) {
            // 移除监听者已释放的对象
            [self.listBlockArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if (target.listBlock) {
                target.listBlock([self.deviceArray copy]);
            }
        }
    }
}

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
                   block:(NotifyTargetBlock)block {
    // 取消对 sn 的非空检查, 因为可以不针对特定设备进行监听
    
    if (!listener || (group == 0) || !block) {
        return;
    }
    
    NotifyTarget *target = nil;
    for (int i = 0; i < self.editBlockArray.count; i++) {
        NotifyTarget *item = [self.editBlockArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [self.editBlockArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if (item.listener == listener) {
                // 之前注册过
                target = item;
                break;
            }
        }
    }
    
    if (!target) {
        // 一次全新的注册
        target = [[NotifyTarget alloc] init];
        target.listener = listener;
        [self.editBlockArray addObject:target];
    }
    
    target.sign = sn;
    target.propertyGroup = group;
    target.groupBlock = block;
    
    // 立即通知
    LinKonDevice *device = [self getDevice:sn];
    if (device) {
        if (block) {
            block(device, nil);
        }
    }
}


/**
 移除监听通知
 
 @param device 设备
 */
- (void)resignListenerTargetWithDevice:(LinKonDevice *)device {
    
    if (!device.sn) {
        return;
    }
    
    for (int i = 0; i < self.editBlockArray.count; i++) {
        NotifyTarget *item = [self.editBlockArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [self.editBlockArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if ([item.sign isEqualToString:device.sn]) {
                [self.editBlockArray removeObjectAtIndex:i];
                i--;
            }
        }
    }
}

/**
 编辑对象属性
 
 @param sn 设备SN
 @param key 属性
 @param value 属性值
 */
- (void)editDevice:(NSString *)sn
               key:(NSString *)key
             value:(id)value {
    
    if (!sn || !key || !value) {
        return;
    }
    
    LinKonDevice *device = [self getDevice:sn];
    if (device) {
        // 找到全局对应的设备, 并更新值
        [device setValue:value forKey:key];
        
        LinKonPropertyGroup group = [LinKonDevice groupProperty:key];
        [self notifyWithDevice:sn group:group key:key];
    }
}


#pragma mark - 定时器

/**
 获取任务
 
 @param number 任务编号
 @param sn 设备SN
 @return 任务
 */
- (LinKonTimerTask *)getTask:(NSString *)number
                      device:(NSString *)sn {
    if (!number || !sn) {
        return nil;
    }
    
    LinKonDevice *device = [self getDevice:sn];
    if (!device) {
        return nil;
    }

    for (LinKonTimerTask *item in device.timerArray) {
        if ([item.number isEqualToString:number]) {
            return [item copy];
        }
    }
    return nil;
}

/**
 添加定时器
 
 @param timer 定时器
 @param sn 设备SN
 @return 是否添加成功
 */
- (BOOL)addTimerTask:(LinKonTimerTask *)timer toDevice:(NSString *)sn {
    if (!timer || !sn) {
        return NO;
    }
    
    LinKonDevice *device = [self getDevice:sn];
    if (!device) {
        return NO;
    }
    
    [timer resetTimerRange];
    
    if ([device addTimerTask:timer]) {
        // 添加成功
        [self notifyWithDevice:sn group:LinKonPropertyGroupTimer key:KDeviceTimerAdd];
        return YES;
    }
    // 添加失败
    return NO;
}


/**
 移除定时器
 
 @param timer 定时器
 @param sn 设备SN
 @return 是否移除成功
 */
- (BOOL)removeTimerTask:(LinKonTimerTask *)timer toDevice:(NSString *)sn {
    if (!timer || !sn) {
        return NO;
    }
    
    LinKonDevice *device = [self getDevice:sn];
    if (!device) {
        return NO;
    }
    
    if ([device removeTimerTask:timer]) {
        // 移除成功
        [self notifyWithDevice:sn group:LinKonPropertyGroupTimer key:KDeviceTimerRemove];
        return YES;
    }
    // 移除失败
    return NO;
}


/**
 修改定时器
 
 @param timer 定时器
 @param sn 设备SN
 @return 是否修改成功
 */
- (BOOL)editTimerTask:(LinKonTimerTask *)timer toDevice:(NSString *)sn {
    if (!timer || !sn) {
        return NO;
    }
    
    LinKonDevice *device = [self getDevice:sn];
    if (!device) {
        return NO;
    }
    
    [timer resetTimerRange];

    if ([device editTimerTask:timer]) {
        // 修改成功
        [self notifyWithDevice:sn group:LinKonPropertyGroupTimer key:KDeviceTimerEdit];
        return YES;
    }
    // 修改失败
    return NO;
}

#pragma mark - 属性组修改通知

/**
 设备属性修改通知

 @param sn 设备SN
 @param group 设备属性组
 */
- (void)notifyWithDevice:(NSString *)sn group:(LinKonPropertyGroup)group key:(NSString *)key {
    LinKonDevice *device = [self getDevice:sn];
    
    for (int i = 0; i < self.editBlockArray.count; i++) {
        NotifyTarget *item = [self.editBlockArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [self.editBlockArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if ((!item.sign || [item.sign isEqualToString:sn]) && (item.propertyGroup & group) == group) {
                if (item.groupBlock) {
                    item.groupBlock(device, key);
                }
            }
        }
    }
}

@end
