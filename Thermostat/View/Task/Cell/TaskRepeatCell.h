//
//  TaskRepeatCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTableCell.h"

typedef void(^TaskRepeatBlock)(Byte repeat);


/**
 定时器周期编辑Cell
 */
@interface TaskRepeatCell : BaseTableCell


/**
 周期组合
 */
@property (nonatomic, assign) Byte repeat;


/**
 周期修改回调
 */
@property (nonatomic, copy) TaskRepeatBlock block;

@end
