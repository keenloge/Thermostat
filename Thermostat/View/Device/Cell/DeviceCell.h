//
//  DeviceCell.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseCell.h"

@class Device;

typedef void(^DeviceCellInfoBlock)();

@interface DeviceCell : BaseCell

@property (nonatomic, copy) DeviceCellInfoBlock infoBlock;
@property (nonatomic, copy) NSString *sn;

@end
