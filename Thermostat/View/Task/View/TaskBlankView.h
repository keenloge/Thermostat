//
//  TaskBlankView.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"
#import "Declare.h"

typedef void(^TaskBlankBlock)(LinKonTimerTaskType type);

@interface TaskBlankView : BaseView

@property (nonatomic, copy) TaskBlankBlock block;

@end
