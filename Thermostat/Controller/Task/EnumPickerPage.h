//
//  EnumPickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"


/**
 枚举选择控制器类型

 - EnumPickerTypeWind: 风速
 - EnumPickerTypeMode: 模式
 - EnumPickerTypeScene: 情景
 */
typedef NS_ENUM(NSInteger, EnumPickerType) {
    EnumPickerTypeWind,
    EnumPickerTypeMode,
    EnumPickerTypeScene,
};

typedef void(^EnumPickerBlock)(NSInteger value);


/**
 枚举选择控制器
 */
@interface EnumPickerPage : BasePickerPage


/**
 初始化枚举选择控制器

 @param aType 控制器类型
 @param value 选中值
 @param block 选中回调
 @return 枚举选择控制器
 */
- (instancetype)initWithType:(EnumPickerType)aType
                       value:(NSInteger)value
                       block:(EnumPickerBlock)block;

@end
