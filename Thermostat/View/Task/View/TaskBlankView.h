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


/**
 定时器列表空白界面
 */
@interface TaskBlankView : BaseView


/**
 空白界面按钮点击回调
 */
@property (nonatomic, copy) TaskBlankBlock block;

@end
