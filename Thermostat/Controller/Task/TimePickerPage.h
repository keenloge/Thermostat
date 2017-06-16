//
//  TimePickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"

typedef void(^TimePickerBlock)(NSInteger time);

@interface TimePickerPage : BasePickerPage

- (instancetype)initWithTitle:(NSString *)title
                         time:(NSInteger)time
                        block:(TimePickerBlock)block;

@end
