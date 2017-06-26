//
//  LinKonDevice.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseDevice.h"
#import "LinKonTimerTask.h"

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

@interface LinKonDevice : BaseDevice

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


@end
