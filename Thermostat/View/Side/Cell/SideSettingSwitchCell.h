//
//  SideSettingSwitchCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideSettingCell.h"

@interface SideSettingSwitchCell : SideSettingCell

@property (nonatomic, assign) BOOL open;
@property (nonatomic, copy) void(^switchBlock)(BOOL value);

@end
