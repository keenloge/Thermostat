//
//  UIImageAdditions.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

+ (UIImage *)imageNamed:(NSString *)name tintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor*)color;

@end

@interface UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
