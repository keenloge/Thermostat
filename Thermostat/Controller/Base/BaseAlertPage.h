//
//  BaseAlertPage.h
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAlertPage : UIAlertController

+ (instancetype)alertPageWithTitle:(NSString *)title message:(NSString *)message;

- (void)addActionTitle:(NSString *)title handler:(void (^)(UIAlertAction *action))handler;
//- (void)addActionTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler;

@end
