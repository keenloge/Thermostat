//
//  LinKonDevice.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinKonTimerTask.h"

#define KDeviceSN           @"sn"
#define KDeviceNickname     @"nickname"
#define KDevicePassword     @"password"
#define KDeviceConnection   @"connection"
#define KDeviceRunning      @"running"
#define KDeviceWind         @"wind"
#define KDeviceMode         @"mode"
#define KDeviceScene        @"scene"
#define KDeviceSetting      @"setting"
#define KDeviceLock         @"lock"
#define KDeviceDelay        @"delay"
#define KDeviceHumidity     @"humidity"
#define KDeviceTemperature  @"temperature"
#define KDeviceTimerAdd     @"timerAdd"
#define KDeviceTimerEdit    @"timerEdit"
#define KDeviceTimerRemove  @"timerRemove"

@interface LinKonDevice : NSObject


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
 连接状态
 */
@property (nonatomic, readonly) DeviceConnectionState connection;


/**
 运行状态
 */
@property (nonatomic, readonly) DeviceRunningState running;


/**
 当前湿度
 */
@property (nonatomic, readonly) float humidity;


/**
 当前温度
 */
@property (nonatomic, readonly) float temperature;

/**
 风速
 */
@property (nonatomic, readonly) LinKonWind wind;


/**
 模式
 */
@property (nonatomic, readonly) LinKonMode mode;


/**
 情景
 */
@property (nonatomic, readonly) LinKonScene scene;


/**
 设定温度
 */
@property (nonatomic, readonly) float setting;


/**
 儿童锁
 */
@property (nonatomic, readonly) BOOL lock;


/**
 延时开关截止时间
 */
@property (nonatomic, readonly) NSTimeInterval delay;


/**
 定时器列表
 */
@property (nonatomic, readonly) NSArray *timerArray;




/**
 随机生成设备

 @return 设备对象
 */
+ (instancetype)randomDevice;


/**
 生成指定设备

 @param sn 设备SN
 @param password 密码
 @return 设备对象
 */
+ (instancetype)deviceWithSN:(long long)sn password:(NSString *)password;



/**
 修改设备属性

 @param value 属性值
 @param key 属性Key
 @return 是否修改成功
 */
- (BOOL)updateValue:(id)value forKey:(NSString *)key;


@end
