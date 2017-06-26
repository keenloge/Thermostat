//
//  DeviceNotifyManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/21.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 设备通知类别

 - DeviceNotifyTypeNone: 无
 - DeviceNotifyTypeList: 列表
 - DeviceNotifyTypeState: 状态
 - DeviceNotifyTypeIdentity: 身份 (主要为昵称 和 密码)
 - DeviceNotifyTypeSetting: 设置
 - DeviceNotifyTypeTimer: 定时器
 */
typedef NS_ENUM(Byte, DeviceNotifyType) {
    DeviceNotifyTypeNone        = 0,
    DeviceNotifyTypeList        = 1 << 0,
    DeviceNotifyTypeState       = 1 << 1,
    DeviceNotifyTypeIdentity    = 1 << 2,
    DeviceNotifyTypeSetting     = 1 << 3,
    DeviceNotifyTypeTimer       = 1 << 4,
};


/**
 设备通知回调

 @param sn 序列号
 @param object 附加消息对象
 */
typedef void(^DeviceNotifyBlock)(long long sn, id object);

@interface DeviceNotifyManager : NSObject

+ (instancetype)sharedManager;



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
                   block:(DeviceNotifyBlock)block;


/**
 注销通知

 @param listener 监听者
 */
- (void)resignListener:(id)listener;

/**
 发送通知

 @param type 通知类别
 @param sn 序列号
 @param object 消息附加对象
 */
- (void)postNotifyType:(DeviceNotifyType)type
                    sn:(long long)sn
                object:(id)object;

@end
