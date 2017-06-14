//
//  NSDictionaryAdditions.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "NSDictionaryAdditions.h"

@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue boolValue];
    } else {
        @try {
            return [tmpValue boolValue];
        }@catch (NSException *exception) {
            NSLog(@"getBoolValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue intValue];
    } else {
        @try {
            return [tmpValue intValue];
        }@catch (NSException *exception) {
            NSLog(@"getIntValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (NSInteger)getIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue integerValue];
    } else {
        @try {
            return [tmpValue integerValue];
        }@catch (NSException *exception) {
            NSLog(@"getIntValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (float)getFloatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue floatValue];
    } else {
        @try {
            return [tmpValue floatValue];
        }@catch (NSException *exception) {
            NSLog(@"getFloatValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (double)getDoubleValueForKey:(NSString *)key defaultValue:(double)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue doubleValue];
    } else {
        @try {
            return [tmpValue doubleValue];
        }@catch (NSException *exception) {
            NSLog(@"getDoubleValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
    NSString *stringTime = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        return mktime(&created);
    }
    return defaultValue;
}

- (NSTimeInterval)getTimeIntervalForKey:(NSString *)key dateFormat:(NSString *)dateFormat {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return 0;
    }
    
    if ([tmpValue isKindOfClass:[NSString class]]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:dateFormat];
        NSDate *date = [df dateFromString:tmpValue];
        if (date) {
            return [date timeIntervalSince1970];
        }
    }
    return 0;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue longLongValue];
    } else {
        @try {
            return [tmpValue longLongValue];
        }@catch (NSException *exception) {
            NSLog(@"getLongLongValueValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSString class]]) {
        return [NSString stringWithString:tmpValue];
    } else {
        @try {
            return [NSString stringWithFormat:@"%@", tmpValue];
        }@catch (NSException *exception) {
            NSLog(@"getStringValueForKey : %@", key);
            NSLog(@"tmpValue : %@", tmpValue);
            return defaultValue;
        }
    }
}

- (NSArray *)getArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    if (![self isKindOfClass:[NSDictionary class]]) {
        return defaultValue;
    }
    
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSArray class]]) {
        return tmpValue;
    }
    return defaultValue;
}

- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    if (![self isKindOfClass:[NSDictionary class]]) {
        return defaultValue;
    }
    
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSDictionary class]]) {
        return tmpValue;
    }
    return defaultValue;
}

@end

@implementation NSMutableDictionary (Additions)

- (void)setObjectIgnoreNil:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)setNumberInt:(int)number forKey:(id<NSCopying>)aKey {
    [self setObject:[NSString stringWithFormat:@"%d", number] forKey:aKey];
}

- (void)setNumberInteger:(NSInteger)number forKey:(id<NSCopying>)aKey {
    [self setObject:[NSString stringWithFormat:@"%ld", (long)number] forKey:aKey];
}

- (void)setNumberFloat:(float)number forKey:(id<NSCopying>)aKey {
    [self setObject:[NSString stringWithFormat:@"%f", number] forKey:aKey];
}

- (void)setNumberDouble:(double)number forKey:(id<NSCopying>)aKey {
    [self setObject:[NSString stringWithFormat:@"%f", number] forKey:aKey];
}

- (void)setTimeInterval:(NSTimeInterval)time format:(NSString *)format forKey:(id<NSCopying>)aKey {
    if (time > 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:format];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        [self setObject:[df stringFromDate:date] forKey:aKey];
    }
}

- (void)setTimeInterval:(NSTimeInterval)time forKey:(id<NSCopying>)aKey {
    if (time > 0) {
        [self setObject:[NSString stringWithFormat:@"%.0f", time] forKey:aKey];
    }
}

@end

@implementation NSDictionary (Unicode)

- (NSString*)my_description {
    NSString *desc = [self description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

@end
