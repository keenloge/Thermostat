//
//  MenuControlView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"


/**
 设备控制按钮Tag

 - MenuControlButtonTagTimer: 延时开关机
 - MenuControlButtonTagRunning: 开关机
 - MenuControlButtonTagScene: 情景
 - MenuControlButtonTagLock: 儿童锁
 - MenuControlButtonTagMode: 模式
 - MenuControlButtonTagWind: 风速
 */
typedef NS_ENUM(NSInteger, MenuControlButtonTag) {
    MenuControlButtonTagTimer   = 1,
    MenuControlButtonTagRunning,
    MenuControlButtonTagScene,
    MenuControlButtonTagLock,
    MenuControlButtonTagMode,
    MenuControlButtonTagWind,
};


/**
 设备控制界面点击回调

 @param tag 点击按钮Tag
 */
typedef void(^MenuControlBlock)(MenuControlButtonTag tag);

@interface MenuControlView : BaseView

@property (nonatomic, copy) MenuControlBlock block;


/**
 更新按钮图片

 @param image 图片
 @param tag Tag
 */
- (void)updateButtonImage:(UIImage *)image tag:(MenuControlButtonTag)tag;


/**
 更新按钮可用性

 @param enabled 可用性
 @param tag Tag
 */
- (void)updateButtonEnabled:(BOOL)enabled tag:(MenuControlButtonTag)tag;

@end
