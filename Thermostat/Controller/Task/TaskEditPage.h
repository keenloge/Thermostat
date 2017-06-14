//
//  TaskEditPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseListViewPage.h"
#import "Declare.h"


@interface TaskEditPage : BaseListViewPage

- (instancetype)initWithTask:(NSString *)number device:(NSString *)sn;
- (instancetype)initWithType:(TaskType)type device:(NSString *)sn;

@end
