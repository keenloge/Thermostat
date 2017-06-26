//
//  DeviceCircleView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

typedef void(^DeviceDelayTimerFinishBlock)();


/**
 设备信息展示界面(顶部圆圈)
 */
@interface DeviceCircleView : BaseView

/**
 更新转圈图片 渐变起止颜色
 
 @param image 转圈图片
 @param colorFrom 渐变起始颜色
 @param colorTo 渐变结束颜色
 */
- (void)updateRoundImage:(UIImage *)image
               colorFrom:(UIColor *)colorFrom
                 colorTo:(UIColor *)colorTo;

/**
 更新当前湿度字符串
 
 @param text 当前湿度字符串
 */
- (void)updateHumidityString:(NSString *)text;

/**
 更新当前温度字符串
 
 @param text 当前温度字符串
 */
- (void)updateTemperatureString:(NSString *)text;

/**
 更新设置与状态显示
 
 @param state 状态字符串
 @param setting 设定温度字符串
 @param mode 模式字符串
 @param unit 单位字符串
 */
- (void)updateStateString:(NSString *)state
                  setting:(NSString *)setting
                     mode:(NSString *)mode
                     unit:(NSString *)unit;

/**
 更新倒计时
 
 @param timeOffset 计时数
 @param image 计时图标
 @param block 计时结束回调
 */
- (void)updateTimerOffset:(NSInteger)timeOffset
                    image:(UIImage *)image
                    block:(DeviceDelayTimerFinishBlock)block;

@end
