//
//  TaskRepeatCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTableCell.h"

typedef void(^TaskRepeatBlock)(Byte repeat);

@interface TaskRepeatCell : BaseTableCell

@property (nonatomic, assign) Byte repeat;
@property (nonatomic, copy) TaskRepeatBlock block;

@end
