//
//  Globals.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Declare.h"

@interface Globals : NSObject


/**
 添加子界面, 主要用于 autolayout 布局

 @param class 添加界面类
 @param superView 父界面
 @return 子界面
 */
+ (id)addedSubViewClass:(Class)class toView:(UIView *)superView;


+ (NSString *)formatSN:(NSString *)sn;

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

@end
