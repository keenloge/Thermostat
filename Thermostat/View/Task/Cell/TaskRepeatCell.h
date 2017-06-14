//
//  TaskRepeatCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TaskRepeatBlock)(Byte repeat);

@interface TaskRepeatCell : UITableViewCell

@property (nonatomic, assign) Byte repeat;
@property (nonatomic, copy) TaskRepeatBlock block;

@end
