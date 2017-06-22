//
//  LinKonHelper.h
//  Thermostat
//
//  Created by Keen on 2017/6/21.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonDevice.h"

@interface LinKonHelper : NSObject

+ (NSString *)formatSN:(long long)sn;

/**
 连接状态转字符串
 
 @param connection 连接状态
 @return 连接状态字符串
 */
+ (NSString *)connectionString:(DeviceConnectionState)connection;


/**
 运行状态转字符串
 
 @param running 运行状态
 @return 运行状态字符串
 */
+ (NSString *)runningString:(DeviceRunningState)running;


/**
 风速转字符串
 
 @param wind 风速
 @return 风速字符串
 */
+ (NSString *)windString:(LinKonWind)wind;


/**
 模式转字符串
 
 @param mode 模式
 @return 模式字符串
 */
+ (NSString *)modeString:(LinKonMode)mode;


/**
 情景转字符串
 
 @param scene 情景
 @return 情景字符串
 */
+ (NSString *)sceneString:(LinKonScene)scene;


/**
 星期转字符串
 
 @param week 星期
 @return 星期字符串
 */
+ (NSString *)weekString:(TimerRepeat)week;


/**
 设定温度转字符串
 
 @param setting 设定温度
 @return 设定温度字符串
 */
+ (NSString *)settingString:(float)setting;


/**
 时间转字符串
 
 @param time 时间(距离 00:00 经过的分钟数)
 @return 时间字符串
 */
+ (NSString *)timeString:(NSInteger)time;


/**
 重复周期转字符串
 
 @param repeat 重复周期
 @return 重复周期字符串
 */
+ (NSString *)repeatString:(Byte)repeat;


/**
 状态字符串,综合考虑,连接状态,运行状态,设备属性值

 @param device 设备
 @return 状态字符串
 */
+ (NSString *)stateString:(LinKonDevice *)device;


/**
 状态字符串颜色

 @param device 设备
 @return 颜色
 */
+ (UIColor *)stateColor:(LinKonDevice *)device;

#pragma mark - 循环切换

/**
 切换运行状态

 @param running 当前运行状态
 @return 下一个运行状态
 */
+ (DeviceRunningState)switchRunning:(DeviceRunningState)running;


/**
 切换模式

 @param mode 当前模式
 @return 下一个模式
 */
+ (LinKonMode)switchMode:(LinKonMode)mode;


/**
 切换情景

 @param scene 当前情景
 @return 下一个情景
 */
+ (LinKonScene)switchScene:(LinKonScene)scene;


/**
 切换风速

 @param wind 当前风速
 @return 下一个风速
 */
+ (LinKonWind)switchWind:(LinKonWind)wind;


/**
 切换延时

 @param delay 当前延时
 @return 下一个延时
 */
+ (NSTimeInterval)switchDelay:(NSTimeInterval)delay;

@end
