//
//  NSDictionaryAdditions.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (NSInteger)getIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (float)getFloatValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)getDoubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (NSTimeInterval)getTimeIntervalForKey:(NSString *)key dateFormat:(NSString *)dateFormat;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSArray *)getArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

@end

@interface NSMutableDictionary (Additions)

- (void)setObjectIgnoreNil:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setNumberInt:(int)number forKey:(id<NSCopying>)aKey;
- (void)setNumberInteger:(NSInteger)number forKey:(id<NSCopying>)aKey;
- (void)setNumberFloat:(float)number forKey:(id<NSCopying>)aKey;
- (void)setNumberDouble:(double)number forKey:(id<NSCopying>)aKey;
//- (void)setTimeInterval:(NSTimeInterval)time format:(NSString*)format forKey:(id<NSCopying>)aKey;
- (void)setTimeInterval:(NSTimeInterval)time forKey:(id<NSCopying>)aKey;

@end

@interface NSDictionary (Unicode)

- (NSString*)my_description;

@end
