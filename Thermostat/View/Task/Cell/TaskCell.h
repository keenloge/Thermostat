//
//  TaskCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTableCell.h"

@interface TaskCell : BaseTableCell

- (void)updateTimeString:(NSString *)timeString
                    font:(UIFont *)font
                   color:(UIColor *)color;

- (void)updatePlanString:(NSString *)planString
          attributedText:(NSAttributedString *)attributedText;

@end
