//
//  BaseDevice.h
//  Thermostat
//
//  Created by Keen on 2017/6/26.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceNotifyManager.h"

#define KDeviceNickname     @"nickname"
#define KDevicePassword     @"password"

@interface BaseDevice : NSObject

/**
 序列号
 */
@property (nonatomic, readonly) long long sn;


/**
 昵称
 */
@property (nonatomic, readonly) NSString *nickname;


/**
 密码
 */
@property (nonatomic, readonly) NSString *password;



/**
 修改设备属性
 
 @param value 属性值
 @param key 属性Key
 @return 是否修改成功
 */
- (BOOL)updateValue:(id)value forKey:(NSString *)key;


/**
 属性对应通知类别

 @param key 属性key
 @return 通知类别
 */
- (DeviceNotifyType)notifyTypeWithKey:(NSString *)key;

@end
