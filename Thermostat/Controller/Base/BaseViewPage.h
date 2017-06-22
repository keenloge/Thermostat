//
//  BaseViewPage.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "DeviceNotifyManager.h"
#import "DeviceListManager.h"
#import "LinKonHelper.h"

@interface BaseViewPage : UIViewController


/**
 设备序列号
 */
@property (nonatomic, assign) long long baseSN;


/**
 监听通知类别组
 */
@property (nonatomic, assign) Byte  baseTypeGroup;


/**
 消息提醒
 */
@property (nonatomic, strong) NSString *baseMessageNotify;



/**
 界面控制类初始化

 @param sn 序列号
 @param typeGroup 通知类型组合
 @return 界面控制类对象
 */
- (instancetype)initWithSN:(long long)sn typeGroup:(Byte)typeGroup;

/**
 初始化加载子View
 */
- (void)baseInitialiseSubViews;

/**
 初次调用将发生在 baseInitialiseSubViews 之后, 切换语言后将自动调用
 */
- (void)baseResetLanguage;

/**
 切换温度单位后调用
 */
- (void)baseResetUnit;

/**
 收到通知回调

 @param sn 序列号
 @param key 属性Key
 */
- (void)baseReceiveNotifyWithSN:(long long)sn key:(NSString *)key;

// Button
- (void)baseAddTargetForButton:(UIButton *)sender;
- (void)baseButtonPressed:(id)sender;

@end

@interface BaseViewPage (NavigationControl)

// Navigation Push/Pop
- (void)popViewController;
- (void)popViewControllerSkipCount:(int)countSkip;
- (void)pushViewController:(id)con;
- (void)pushViewController:(id)con skipCount:(int)countSkip;

// Navigation BarButtonItem Add
- (void)addBarButtonItemBack;
- (void)addBarButtonItemBackWithAction:(SEL)action;
- (void)addBarButtonItemRightNormalImageName:(NSString *)imgNameN hightLited:(NSString *)imgNameD;
- (void)addBarButtonItemLeftNormalImageName:(NSString *)imgNameN hightLited:(NSString *)imgNameD;
- (void)addBarButtonItemRightTitle:(NSString *)strTitle;
- (void)addBarButtonItemLeftTitle:(NSString *)strTitle;

// Navigation BarButtonItem CallBack
- (void)barButtonItemRightPressed:(id)sender;
- (void)barButtonItemLeftPressed:(id)sender;

@end

@interface BaseViewPage (KeyBoardControl)

- (void)hideKeyBoard;

@end
