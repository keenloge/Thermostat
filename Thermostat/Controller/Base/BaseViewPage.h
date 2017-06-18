//
//  BaseViewPage.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorConfig.h"
#import "Declare.h"
#import "Globals.h"

@interface BaseViewPage : UIViewController

@property (nonatomic, strong) NSString *messageNotify;

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
