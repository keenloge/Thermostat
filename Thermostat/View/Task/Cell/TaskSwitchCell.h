//
//  TaskSwitchCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TaskSwitchBlock)(BOOL value);

@interface TaskSwitchCell : UITableViewCell

@property (nonatomic, assign) BOOL open;
@property (nonatomic, copy) TaskSwitchBlock block;

@end
