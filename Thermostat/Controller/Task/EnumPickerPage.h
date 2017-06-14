//
//  EnumPickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"

typedef NS_ENUM(NSInteger, EnumPickerType) {
    EnumPickerTypeWind,
    EnumPickerTypeMode,
    EnumPickerTypeScene,
};

typedef void(^EnumPickerBlock)(NSInteger value);

@interface EnumPickerPage : BasePickerPage

- (instancetype)initWithType:(EnumPickerType)aType
                       value:(NSInteger)value
                       block:(EnumPickerBlock)block;

@end
