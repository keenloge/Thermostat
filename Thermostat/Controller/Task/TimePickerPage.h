//
//  TimePickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"

typedef void(^TimePickerBlock)(NSInteger time);


/**
 时间选择控制器
 */
@interface TimePickerPage : BasePickerPage


/**
 初始化时间选择控制器

 @param title 标题
 @param time 设定时间(距离00:00经过了的分钟数)
 @param block 时间选择回调
 @return 时间选择控制器
 */
- (instancetype)initWithTitle:(NSString *)title
                         time:(NSInteger)time
                        block:(TimePickerBlock)block;

@end
