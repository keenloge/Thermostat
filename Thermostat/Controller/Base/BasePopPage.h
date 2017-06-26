//
//  BasePopPage.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 基础弹窗界面控制类
 */
@interface BasePopPage : UIViewController


/**
 初始化加载子View
 */
- (void)baseInitialiseSubViews;


/**
 弹窗返回
 */
- (void)baseBack;

@end
