//
//  DeviceControlView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"
#import "MenuControlView.h"
#import "TemperatureControlView.h"

@interface DeviceControlView : UIScrollView


/**
 遥控按钮回调
 */
@property (nonatomic, copy) MenuControlBlock block;


/**
 设置按钮图片

 @param image 图片
 @param tag 按钮Tag
 */
- (void)updateButtonImage:(UIImage *)image tag:(MenuControlButtonTag)tag;


/**
 设置按钮可用

 @param enabled 可用
 @param tag 按钮Tag
 */
- (void)updateButtonEnabled:(BOOL)enabled tag:(MenuControlButtonTag)tag;


/**
 设置温度选择器是否可用

 @param enabled 是否可用
 */
- (void)updateTemperatureControlEnabled:(BOOL)enabled;

/**
 设置温度选择标题
 
 @param array 温度标题组
 @param block 选中回调
 */
- (void)updateTemperatureArray:(NSArray <NSString *>*)array
                    checkBlock:(TemperatureControlCheckBlock)block;


/**
 设置当前选中项
 
 @param index 当前选中项
 */
- (void)updateTemperatureCheckIndex:(NSInteger)index;

@end
