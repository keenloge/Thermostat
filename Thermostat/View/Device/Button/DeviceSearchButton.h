//
//  DeviceSearchButton.h
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseButton.h"

typedef void(^DeviceSearchBlock)();

@interface DeviceSearchButton : BaseButton


/**
 开启动画

 @param duration 动画持续时间
 @param block 动画结束回调
 */
- (void)startAnimationWithDuration:(NSInteger)duration finishBlock:(DeviceSearchBlock)block;


/**
 关闭动画
 */
- (void)stopAnimation;

@end
