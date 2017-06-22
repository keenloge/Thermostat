//
//  TemperatureControlView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

typedef void(^TemperatureControlCheckBlock)(NSInteger index);

@interface TemperatureControlView : BaseView


/**
 设置温度选择是否可用

 @param enabled 可用
 */
- (void)updateControlEnabled:(BOOL)enabled;


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
