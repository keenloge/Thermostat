//
//  Globals.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Declare.h"

@interface Globals : NSObject


/**
 添加子界面, 主要用于 autolayout 布局

 @param class 添加界面类
 @param superView 父界面
 @return 子界面
 */
+ (id)addedSubViewClass:(Class)class toView:(UIView *)superView;

@end
