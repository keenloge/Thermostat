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
 @param key 属性
 @param block 回调 Block
 */
- (void)registerListener:(id)listener
                  device:(NSString *)sn
                     key:(NSString *)key
                   block:(NotifyTargetBlock)block {
    
    if (!listener || !sn || !key || !block) {
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
                if (![target.sign isEqualToString:sn]) {
                    // 监听对象已改变, 须注销之前的监听
                    target.sign = sn;
                    [target.blockDictionary removeAllObjects];
                } else {
                    // 监听对象未改变
                    // Do Nothing
                }
                break;
            }
        }
    }
    
    if (!target) {
        // 一次全新的注册
        target = [[NotifyTarget alloc] init];
        target.listener = listener;
        target.sign = sn;
        [self.editBlockArray addObject:target];
    }
    
    [target.blockDictionary setObject:[block copy] forKey:key];
    
    // 立即通知
    LinKonDevice *device = [self getDevice:sn];
    if (device) {
        if (block) {
            block(device);
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
        
        for (int i = 0; i < self.editBlockArray.count; i++) {
            NotifyTarget *item = [self.editBlockArray objectAtIndex:i];
            if (!item.listener) {
                // 移除监听者已释放的对象
                [self.editBlockArray removeObjectAtIndex:i];
                i--;
                continue;
            } else {
                if ([item.sign isEqualToString:sn]) {
                    NotifyTargetBlock block = [item.blockDictionary objectForKey:key];
                    if (block) {
                        block(device);
                    }
                }
            }
        }
    }
}

@end
