//
//  DeviceCell.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTableCell.h"

@class LinKonDevice;

typedef void(^DeviceCellInfoBlock)();

@interface DeviceCell : BaseTableCell

@property (nonatomic, copy) DeviceCellInfoBlock infoBlock;

- (void)updateImageIcon:(UIImage *)image;

- (void)updateTitleString:(NSString *)title;

- (void)updateStateString:(NSString *)state color:(UIColor *)color;

@end
