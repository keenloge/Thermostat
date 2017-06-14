//
//  LanguageManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNotificationNameSwitchLanguage @"SwitchLanguage"

@interface LanguageManager : NSObject

+ (instancetype)sharedManager;

- (void)switchLanguage;

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

- (NSString *)currentLanguage;

@end
