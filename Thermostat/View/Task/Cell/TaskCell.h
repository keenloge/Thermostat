//
//  TaskCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LinKonTimerTask;

@interface TaskCell : UITableViewCell

@property (nonatomic, strong) LinKonTimerTask *task;
@property (nonatomic, copy) void (^validBlock)(LinKonTimerTask *item);

@end
