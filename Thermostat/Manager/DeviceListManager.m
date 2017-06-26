//
//  DeviceListManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceListManager.h"
#import "DeviceNotifyManager.h"
#import "BaseDevice.h"

static DeviceListManager *_currentDeviceListManager;

@interface DeviceListManager ()


/**
 设备列表
 */
@property (nonatomic, strong) NSMutableArray<BaseDevice*> *savedDeviceArray;

@end

@implementation DeviceListManager

#pragma mark - 单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDeviceListManager = [super allocWithZone:zone];
    });
    return _currentDeviceListManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDeviceListManager = [[self alloc] init];
    });
    return _currentDeviceListManager;
}

- (instancetype)copy {
    return _currentDeviceListManager;
}

- (instancetype)mutableCopy {
    return _currentDeviceListManager;
}

#pragma mark - Getter

- (NSMutableArray *)savedDeviceArray {
    if (!_savedDeviceArray) {
        _savedDeviceArray = [NSMutableArray array];
    }
    return _savedDeviceArray;
}

#pragma mark 设备管理

/**
 添加设备
 
 @param device 设备
 */

- (void)addDevice:(BaseDevice *)device {
    if (device.sn <= 0) {
        return;
    }
    
    // 移除重复的设备
    [self removeDevice:device.sn notify:NO];
    
    // 添加设备
    [self.savedDeviceArray addObject:device];
    
    // 通知监听了设备列表的对象
    [[DeviceNotifyManager sharedManager] postNotifyType:DeviceNotifyTypeList sn:device.sn object:KDeviceListAdd];
}

/**
 移除设备
 
 @param sn 序列号
 */

- (void)removeDevice:(long long)sn {
    [self removeDevice:sn notify:YES];
}


/**
 移除设备

 @param sn 序列号
 @param notify 是否通知
 */
- (void)removeDevice:(long long)sn notify:(BOOL)notify {
    if (sn <= 0) {
        return;
    }
    
    for (int i = 0; i < self.savedDeviceArray.count; i++) {
        BaseDevice *device = [self.savedDeviceArray objectAtIndex:i];
        if (device.sn == sn) {
            [self.savedDeviceArray removeObjectAtIndex:i];
            
            if (notify) {
                [[DeviceNotifyManager sharedManager] postNotifyType:DeviceNotifyTypeList sn:sn object:KDeviceListRemove];
            }
        }
    }
}

/**
 获取设备
 
 @param sn 序列号
 @return 设备
 */

- (BaseDevice *)getDevice:(long long)sn {
    if (sn <= 0) {
        return nil;
    }
    
    for (BaseDevice *item in self.savedDeviceArray) {
        if (item.sn == sn) {
            return item;
        }
    }
    return nil;
}

- (NSArray *)getDeviceList {
    return [self.savedDeviceArray copy];
}

@end
