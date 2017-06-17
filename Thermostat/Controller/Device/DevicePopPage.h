//
//  DevicePopPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseAlertPage.h"

@class LinKonDevice;


/**
 设备弹窗事件

 - DevicePopActionNickname: 修改昵称
 - DevicePopActionPassword: 修改密码
 - DevicePopActionRemove: 移除设备
 */
typedef NS_ENUM(NSInteger, DevicePopAction) {
    DevicePopActionNickname,
    DevicePopActionPassword,
    DevicePopActionRemove,
};



/**
 设备弹窗事件回调Block

 @param action 事件
 */
typedef void(^DevicePopBlock)(DevicePopAction action);

@interface DevicePopPage : BaseAlertPage

- (instancetype)initWithDevice:(LinKonDevice *)item
                         block:(DevicePopBlock)aBlock;

@end
