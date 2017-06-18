//
//  LinKonDevice.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinKonTimerTask.h"

#define KDeviceSN            @"sn"
#define KDeviceNickname      @"nickname"
#define KDevicePassword      @"password"
#define KDeviceConnection    @"connection"
#define KDeviceRunning       @"running"
#define KDeviceWind          @"wind"
#define KDeviceMode          @"mode"
#define KDeviceScene         @"scene"
#define KDeviceSetting       @"setting"
#define KDeviceLock          @"lock"
#define KDeviceDelay         @"delay"
#define KDeviceHumidity      @"humidity"
#define KDeviceTemperature   @"temperature"

@interface LinKonDevice : NSObject


/**
 序列号
 */
@property (nonatomic, copy) NSString *sn;


/**
 昵称
 */
@property (nonatomic, copy) NSString *nickname;


/**
 密码
 */
@property (nonatomic, copy) NSString *password;


/**
 连接状态
 */
@property (nonatomic, assign) DeviceConnectionState connection;


/**
 运行状态
 */
@property (nonatomic, assign) DeviceRunningState running;


/**
 当前湿度
 */
@property (nonatomic, assign) float humidity;


/**
 当前温度
 */
@property (nonatomic, assign) float temperature;

/**
 风速
 */
@property (nonatomic, assign) LinKonWind wind;


/**
 模式
 */
@property (nonatomic, assign) LinKonMode mode;


/**
 情景
 */
@property (nonatomic, assign) LinKonScene scene;


/**
 设定温度
 */
@property (nonatomic, assign) float setting;


/**
 儿童锁
 */
@property (nonatomic, assign) BOOL lock;


/**
 延时开关截止时间
 */
@property (nonatomic, assign) NSTimeInterval delay;


/**
 定时器列表
 */
@property (nonatomic, readonly) NSArray *timerArray;


#pragma mark - 只读属性

/**
 状态字符
 */
@property (nonatomic, readonly) NSString *stateString;


/**
 切换运行状态
 */
@property (nonatomic, readonly) DeviceRunningState switchRunning;


/**
 切换模式
 */
@property (nonatomic, readonly) LinKonMode switchMode;


/**
 切换情景
 */
@property (nonatomic, readonly) LinKonScene switchScene;


/**
 切换风速
 */
@property (nonatomic, readonly) LinKonWind switchWind;


/**
 切换延时
 */
@property (nonatomic, readonly) NSTimeInterval switchDelay;

+ (instancetype)randomDevice;
+ (instancetype)deviceWithSN:(NSString *)sn password:(NSString *)password;
+ (LinKonPropertyGroup)groupProperty:(NSString *)key;


/**
 添加定时器

 @param timer 定时器
 @return 是否添加成功
 */
- (BOOL)addTimerTask:(LinKonTimerTask *)timer;


/**
 移除定时器

 @param timer 定时器
 @return 是否移除成功
 */
- (BOOL)removeTimerTask:(LinKonTimerTask *)timer;


/**
 修改定时器

 @param timer 定时器
 @return 是否修改成功
 */
- (BOOL)editTimerTask:(LinKonTimerTask *)timer;

@end
