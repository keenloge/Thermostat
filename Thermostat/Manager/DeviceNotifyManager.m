//
//  DeviceNotifyManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/21.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceNotifyManager.h"
#import "NotifyTarget.h"

static DeviceNotifyManager *_currentDeviceNotifyManager;


@interface DeviceNotifyManager ()

@property (nonatomic, strong) NSMutableArray *targetArray;

@end

@implementation DeviceNotifyManager

#pragma mark - 单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDeviceNotifyManager = [super allocWithZone:zone];
    });
    return _currentDeviceNotifyManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentDeviceNotifyManager = [[self alloc] init];
    });
    return _currentDeviceNotifyManager;
}

- (instancetype)copy {
    return _currentDeviceNotifyManager;
}

- (instancetype)mutableCopy {
    return _currentDeviceNotifyManager;
}

#pragma mark - 通知

/**
 注册通知
 
 @param listener 监听者
 @param sn 序列号
 @param typeGroup 通知类别组合
 @param block 通知回调
 */
- (void)registerListener:(id)listener
                      sn:(long long)sn
               typeGroup:(Byte)typeGroup
                   block:(DeviceNotifyBlock)block {
    
    if (!listener || typeGroup == 0 || !block) {
        return;
    }
    
    NotifyTarget *target = nil;
    NotifyTarget *tempTarget = nil;
    for (int i = 0; i < self.targetArray.count; i++) {
        tempTarget = [self.targetArray objectAtIndex:i];
        if (!tempTarget.listener) {
            [self.targetArray removeObjectAtIndex:i];
            i--;
            continue;
        }
        
        if (tempTarget.listener == listener) {
            target = tempTarget;
            break;
        }
    }
    
    if (!target) {
        target = [[NotifyTarget alloc] init];
        target.listener = listener;
        
        [self.targetArray addObject:target];
    }
    
    target.sn = sn;
    target.typeGroup = typeGroup;
    target.block = block;
}

/**
 注销通知
 
 @param listener 监听者
 */
- (void)resignListener:(id)listener {
    if (!listener) {
        return;
    }
    
    for (int i = 0; i < self.targetArray.count; i++) {
        NotifyTarget *target = [self.targetArray objectAtIndex:i];
        if (!target.listener) {
            [self.targetArray removeObjectAtIndex:i];
            i--;
            continue;
        }
        
        if (target.listener == listener) {
            [self.targetArray removeObjectAtIndex:i];
            break;
        }
    }
}

/**
 发送通知
 
 @param type 通知类别
 @param sn 序列号
 @param key 变更Key
 */
- (void)postNotifyType:(DeviceNotifyType)type
                    sn:(long long)sn
                   key:(NSString *)key {
    if (type == 0) {
        return;
    }
    
    for (int i = 0; i < self.targetArray.count; i++) {
        NotifyTarget *target = [self.targetArray objectAtIndex:i];
        if (!target.listener) {
            [self.targetArray removeObjectAtIndex:i];
            i--;
            continue;
        }
        
        if ((target.typeGroup & type) == type && (target.sn == sn || target.sn == 0)) {
            if (target.block) {
                target.block(sn, key);
            }
        }
    }
}

#pragma mark - Getter

- (NSMutableArray *)targetArray {
    if (!_targetArray) {
        _targetArray = [NSMutableArray array];
    }
    return _targetArray;
}

@end
