//
//  LinKonTimerTask.h
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KTaskNumber     @"number"
#define KTaskSN         @"sn"
#define KTaskType       @"type"
#define KTaskTimeFrom   @"timeFrom"
#define KTaskTimeTo     @"timeTo"
#define KTaskValidate   @"validate"
#define KTaskRepeat     @"repeat"
#define KTaskRunning    @"running"
#define KTaskWind       @"wind"
#define KTaskMode       @"mode"
#define KTaskScene      @"scene"
#define KTaskSetting    @"setting"

@interface LinKonTimerTask : NSObject

- (instancetype)initWithType:(LinKonTimerTaskType)type device:(long long)sn;

/**
 任务编号, 唯一
 */
@property (nonatomic, copy) NSString *number;


/**
 任务类别
 */
@property (nonatomic, assign) LinKonTimerTaskType type;

/**
 起始时间, 距离 00:00 经过的分钟数
 */
@property (nonatomic, assign) NSInteger timeFrom;

/**
 结束时间, 距离 00:00 经过的分钟数
 */
@property (nonatomic, assign) NSInteger timeTo;


/**
 是否有效
 */
@property (nonatomic, assign) BOOL  validate;

/**
 重复
 */
@property (nonatomic, assign) Byte  repeat;

/**
 运行状态
 */
@property (nonatomic, assign) DeviceRunningState running;


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


@property (nonatomic, readonly) NSArray *timeRangeArray;


/**
 切换周期

 @param week 星期
 @return 切换后的周期
 */
- (Byte)switchRepeatWeak:(TimerRepeat)week;


/**
 比较定时器是否冲突

 @param task 定时器
 @return 是否冲突
 */
- (BOOL)isConflictTo:(LinKonTimerTask *)task;


/**
 重置周期时间数组
 */
- (void)resetTimerRange;

@end
