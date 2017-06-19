//
//  LanguageManager.h
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KNotificationNameSwitchLanguage @"SwitchLanguage"


/**
 语言类别

 - LanguageTypeEnglish: 英文
 - LanguageTypeChinese: 简体中文
 */
typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeEnglish,
    LanguageTypeChinese,
};

@interface LanguageManager : NSObject

@property (nonatomic, assign) LanguageType typeLanguage;

+ (instancetype)sharedManager;

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

@end
