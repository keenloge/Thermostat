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


/**
 设备列表Cell
 */
@interface DeviceCell : BaseTableCell


/**
 点击信息按钮回调
 */
@property (nonatomic, copy) DeviceCellInfoBlock infoBlock;


/**
 更新设备图标

 @param image 图片
 */
- (void)updateImageIcon:(UIImage *)image;


/**
 更新设备标题

 @param title 标题
 */
- (void)updateTitleString:(NSString *)title;


/**
 更新设备状态

 @param state 状态字符串
 @param color 显示颜色
 */
- (void)updateStateString:(NSString *)state color:(UIColor *)color;

@end
