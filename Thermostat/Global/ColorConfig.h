//
//  ColorConfig.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#ifndef ColorConfig_h
#define ColorConfig_h

#define UIColorFromRGB(r, g, b) \
[UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha : 1]

#define UIColorFromRGBA(r, g, b, a) \
[UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha: (a)]

#define UIColorFromHex(hex) \
[UIColor colorWithRed: ((float)((hex & 0xFF0000) >> 16)) / 255.0 \
green: ((float)((hex & 0xFF00) >> 8)) / 255.0 \
blue: ((float)(hex & 0xFF)) / 255.0 \
alpha: 1.0]

/**
 基础色
 */

// 主题色
#define HB_COLOR_BASE_MAIN  UIColorFromHex(0x28aae5)
// 白
#define HB_COLOR_BASE_WHITE UIColorFromHex(0xffffff)
// 黑
#define HB_COLOR_BASE_BLACK UIColorFromHex(0x000000)
// 深
#define HB_COLOR_BASE_DEEP  UIColorFromHex(0x333333)
// 暗
#define HB_COLOR_BASE_DARK  UIColorFromHex(0x484848)
// 灰
#define HB_COLOR_BASE_GRAY  UIColorFromHex(0x666666)
// 浅
#define HB_COLOR_BASE_LIGHT UIColorFromRGBA(0, 0, 0, 0.4)
// 绿
#define HB_COLOR_BASE_GREEN UIColorFromHex(0x00c853)
// 红
#define HB_COLOR_BASE_RED   UIColorFromHex(0xff0000)


/**
 输入框
 */

// 输入框边框
#define HB_COLOR_INPUT_BOARD    UIColorFromHex(0xcccccc)
// 输入框PlaceHolder
#define HB_COLOR_INPUT_HOLDER   UIColorFromHex(0x808080)

/**
 设备弹窗
 */

// 弹窗标题
#define HB_COLOR_POP_TITLE    UIColorFromHex(0x808080)
// 弹窗分割线
#define HB_COLOR_POP_LINE     UIColorFromHex(0xd1d1d1)
// 弹窗按钮
#define HB_COLOR_POP_ACTION   UIColorFromHex(0x4d4d4d)

/**
 设备控制底部TabBar
 */

// 普通状态
#define HB_COLOR_TABBAR_NORMAL        HB_COLOR_BASE_LIGHT
// 选中状态
#define HB_COLOR_TABBAR_SELECT        HB_COLOR_BASE_MAIN
// 背景色
#define HB_COLOR_TABBAR_BACKGROUND    UIColorFromHex(0xfaf9f9)
// 分割线
#define HB_COLOR_TABBAR_CUTLINE       UIColorFromHex(0xe5e5e5)

/**
 设备控制遥控面板菜单
 */

// 分割线
#define HB_COLOR_MENU_CUTLINE         UIColorFromRGBA(0, 0, 0, 0.1)

#endif /* ColorConfig_h */
