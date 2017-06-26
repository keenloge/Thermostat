//
//  TaskCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTableCell.h"


/**
 定时任务列表Cell
 */
@interface TaskCell : BaseTableCell


/**
 更新时间字符串

 @param timeString 时间字符串
 @param font 字体
 @param color 颜色
 */
- (void)updateTimeString:(NSString *)timeString
                    font:(UIFont *)font
                   color:(UIColor *)color;


/**
 更新计划安排字符串

 @param planString 计划安排字符串
 @param attributedText 有格式的计划安排字符串
 */
- (void)updatePlanString:(NSString *)planString
          attributedText:(NSAttributedString *)attributedText;

@end
