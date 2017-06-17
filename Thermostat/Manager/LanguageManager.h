//
//  LanguageManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNotificationNameSwitchLanguage @"SwitchLanguage"

typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeEnglish,
    LanguageTypeChinese,
};

@interface LanguageManager : NSObject

@property (nonatomic, assign) LanguageType typeLanguage;

+ (instancetype)sharedManager;

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

@end
