//
//  DeviceInfoView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"
#import "DeviceCircleView.h"


/**
 设备信息展示界面
 */
@interface DeviceInfoView : BaseView


/**
 更新儿童锁图片透明度

 @param alpha 透明度
 */
- (void)updateLockImageAlpha:(CGFloat)alpha;


/**
 更新情景图片以及透明度

 @param image 情景图片
 @param alpha 透明度
 */
- (void)updateSceneImage:(UIImage *)image alpha:(CGFloat)alpha;


/**
 更新风速图片以及透明度

 @param image 风速图片
 @param alpha 透明度
 */
- (void)updateWindImage:(UIImage *)image alpha:(CGFloat)alpha;


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
