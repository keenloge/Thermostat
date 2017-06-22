//
//  TaskCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (nonatomic, copy) void (^switchBlock)(BOOL isOpen);

- (void)updateIconImage:(UIImage *)image;

- (void)updateTimeString:(NSString *)timeString
                    font:(UIFont *)font
                   color:(UIColor *)color;

- (void)updatePlanString:(NSString *)planString
          attributedText:(NSAttributedString *)attributedText;

- (void)updateSwitchOn:(BOOL)on;

@end
