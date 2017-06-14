//
//  LanguageManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LanguageManager.h"

#define LANGUAGE_SET        @"AppleLanguages"
#define LANGUAGE_English    @"en"
#define LANGUAGE_Chinese    @"zh-Hans"

static LanguageManager *_currentLanguageManager;

@interface LanguageManager ()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, copy) NSString *language;

@end

@implementation LanguageManager

#pragma mark - 单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentLanguageManager = [super allocWithZone:zone];
    });
    return _currentLanguageManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentLanguageManager = [[self alloc] init];
    });
    return _currentLanguageManager;
}

- (instancetype)copy {
    return _currentLanguageManager;
}

- (instancetype)mutableCopy {
    return _currentLanguageManager;
}

- (NSBundle *)bundle {
    if (!_bundle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.language ofType:@"lproj"];
        _bundle = [NSBundle bundleWithPath:path];
    }
    return _bundle;
}

- (NSString *)language {
    if (!_language) {
        _language = [[[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET] firstObject];
    }
    return _language;
}

- (void)switchLanguage {
    if ([self.language isEqualToString:LANGUAGE_English]) {
        // 切换到中文
        [[NSUserDefaults standardUserDefaults] setObject:@[LANGUAGE_Chinese] forKey:LANGUAGE_SET];
    } else {
        // 切换到英文
        [[NSUserDefaults standardUserDefaults] setObject:@[LANGUAGE_English] forKey:LANGUAGE_SET];
    }

    self.language = nil;
    self.bundle = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationNameSwitchLanguage object:nil];
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table {
    if (!table) {
        table = @"HomeBin";
    }
    if (self.bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    return NSLocalizedStringFromTable(key, table, @"");
}

- (NSString *)currentLanguage {
    return [self.language copy];
}

@end
