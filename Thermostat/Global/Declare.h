//
//  Declare.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LanguageManager.h"

#ifndef Declare_h
#define Declare_h

// 本地化字符串
#define KString(key) \
[[LanguageManager sharedManager] getStringForKey:key withTable:nil]


// 字体字号 由像素初始化
// pt = px / (96 / 72) , 此处由于是 3 倍分辨率 故 pt =  (px / 3) / (96 / 72) 等价于 pt = px / 4.0
#define UIFontOf3XPix(px) [UIFont systemFontOfSize:(px / 4.0)]

#define UIFontOf1XPix(px) UIFontOf3XPix(px * 3.0)

// Log控制
#ifdef DEBUG
//#define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DDLog(fmt, ...) NSLog(fmt, ## __VA_ARGS__);
#else
#define DDLog(...)
#endif

// Weak / Strong
#define WeakObj(o) @autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) @autoreleasepool{} __strong typeof(o) o = o##Weak;

// 屏幕宽度
#define MAIN_SCREEN_WIDTH       MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define MAIN_SCREEN_HEIGHT      MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define NAVIGATION_VIEW_HEIGHT  (MAIN_SCREEN_HEIGHT - 64.0)


// 判定 iOS_10
#define IOS_VERSION_10      (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) ? (YES) : (NO)

// 3.5 寸 对应 iPhone 4/4s
#define IPHONE_INCH_3_5     (MAIN_SCREEN_HEIGHT < 500)

// 4.0 寸 对应 iPhone 5/5c/5s/se
#define IPHONE_INCH_4_0     ((MAIN_SCREEN_HEIGHT > 500) && (MAIN_SCREEN_HEIGHT < 600))

// 4.7 寸 对应 iPhone 6/7
#define IPHONE_INCH_4_7     ((MAIN_SCREEN_HEIGHT > 600) && (MAIN_SCREEN_HEIGHT < 700))

// 5.5 寸 对应 iPhone 6+/7+
#define IPHONE_INCH_5_5     (MAIN_SCREEN_HEIGHT > 700)

// 水平缩放因子, 参考系 5.5 寸设备
#define HORIZONTAL_SCALE    (MAIN_SCREEN_WIDTH / 414.0)

// 垂直缩放因子, 参考系 5.5 寸设备
#define VERTICAL_SCALE      (MAIN_SCREEN_HEIGHT / 736.0)

// 水平缩放, 绝大多数情况,请使用水平缩放, 除非确定是高度敏感的界面
#define KHorizontalFixed(a) ((a) * HORIZONTAL_SCALE)
#define KHorizontalCeil(a)  (ceil(KHorizontalFixed(a)))
#define KHorizontalFloor(a) (floor(KHorizontalFixed(a)))
#define KHorizontalRound(a) (round(KHorizontalFixed(a)))

// 垂直缩放
#define KVerticalFixed(a)   ((a) * VERTICAL_SCALE)
#define KVerticalCeil(a)    (ceil(KVerticalFixed(a)))
#define KVerticalFloor(a)   (floor(KVerticalFixed(a)))
#define KVerticalRound(a)   (round(KVerticalFixed(a)))

// 温控器最低温度
#define LINKON_TEMPERATURE_MIN      (5.0)
// 温控器最高温度
#define LINKON_TEMPERATURE_MAX      (35.0)
// 温控器温度间隔
#define LINKON_TEMPERATURE_OFFSET   (0.5)

// 周期 - 无
FOUNDATION_EXPORT const Byte WeekNone;

// 周期 - 每天
FOUNDATION_EXPORT const Byte WeekEveryDay;

/**
 连接状态
 
 - ConnectionStateOFF: 离线
 - ConnectionStateON: 在线
 */
typedef NS_ENUM(NSInteger, ConnectionState) {
    ConnectionStateOFF  = 1,
    ConnectionStateON   = 2,
};


/**
 运行状态
 
 - RunningStateOFF: 待机
 - RunningStateON: 开机
 */
typedef NS_ENUM(NSInteger, RunningState) {
    RunningStateOFF     = 1,
    RunningStateON      = 2,
};


/**
 风速
 
 - LinKonWindLow: 低风
 - LinKonWindMedium: 中风
 - LinKonWindHigh: 高风
 */
typedef NS_ENUM(NSInteger, LinKonWind) {
    LinKonWindLow     = 1,
    LinKonWindMedium  = 2,
    LinKonWindHigh    = 3,
};


/**
 模式
 
 - LinKonModeCool: 制冷
 - LinKonModeHot: 制热
 - LinKonModeAir: 换气
 */
typedef NS_ENUM(NSInteger, LinKonMode) {
    LinKonModeCool  = 1,
    LinKonModeHot   = 2,
    LinKonModeAir   = 3,
};


/**
 情景
 
 - LinKonSceneConstant: 恒温
 - LinKonSceneGreen: 节能
 - LinKonSceneLeave: 离家
 */
typedef NS_ENUM(NSInteger, LinKonScene) {
    LinKonSceneConstant = 1,
    LinKonSceneGreen    = 2,
    LinKonSceneLeave    = 3,
};


/**
 重复(每周)
 
 - WeekMonday: 周一
 - WeekTuesday: 周二
 - WeekWednesday: 周三
 - WeekThursday: 周四
 - WeekFriday: 周五
 - WeekSaturday: 周六
 - WeekSunday: 周日
 */
typedef NS_ENUM(Byte, Week) {
    WeekMonday      = 1 << 0,
    WeekTuesday     = 1 << 1,
    WeekWednesday   = 1 << 2,
    WeekThursday    = 1 << 3,
    WeekFriday      = 1 << 4,
    WeekSaturday    = 1 << 5,
    WeekSunday      = 1 << 6,
};


/**
 任务类别
 
 - TaskTypeSwitch: 开关任务
 - TaskTypeStage: 阶段任务
 */
typedef NS_ENUM(NSInteger, TaskType) {
    TaskTypeSwitch  = 1,
    TaskTypeStage   = 2,
};

#endif /* Declare_h */
