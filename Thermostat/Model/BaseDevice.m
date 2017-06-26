//
//  BaseDevice.m
//  Thermostat
//
//  Created by Keen on 2017/6/26.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseDevice.h"

@implementation BaseDevice

/**
 修改设备属性
 
 @param value 属性值
 @param key 属性Key
 @return 是否修改成功
 */
- (BOOL)updateValue:(id)value forKey:(NSString *)key {
    if (!value || !key) {
        return NO;
    }
    
    [self setValue:value forKey:key];
    // 发送通知
    [[DeviceNotifyManager sharedManager] postNotifyType:[self notifyTypeWithKey:key] sn:_sn object:key];

    return YES;
}


/**
 属性对应通知类别
 
 @param key 属性key
 @return 通知类别
 */
- (DeviceNotifyType)notifyTypeWithKey:(NSString *)key {
    if ([key isEqualToString:KDeviceNickname]
               || [key isEqualToString:KDevicePassword]) {
        return DeviceNotifyTypeIdentity;
    }
    
    return DeviceNotifyTypeNone;
}

@end
