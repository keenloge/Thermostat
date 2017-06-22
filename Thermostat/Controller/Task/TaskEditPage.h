//
//  TaskEditPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseListViewPage.h"

@class LinKonTimerTask;

@interface TaskEditPage : BaseListViewPage

- (instancetype)initWithTask:(LinKonTimerTask *)task device:(long long)sn;
- (instancetype)initWithType:(LinKonTimerTaskType)type device:(long long)sn;

@end
