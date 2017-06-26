//
//  BaseAlertPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 基础警告框控制器
 */
@interface BaseAlertPage : UIAlertController


/**
 实例化警告框控制器

 @param title 标题
 @param message 消息
 @param alignment 消息对齐方式
 @return 警告框控制器
 */
+ (instancetype)alertPageWithTitle:(NSString *)title message:(NSString *)message alignment:(NSTextAlignment)alignment;


/**
 添加事件按钮

 @param title 按钮标题
 @param handler 点击回调
 */
- (void)addActionTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;

@end
