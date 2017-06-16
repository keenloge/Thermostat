//
//  NSStringAdditions.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (UUID)

+ (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end

@implementation NSString (MixLengh)

- (NSInteger)mixedLenght {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
    
//    int strlength = 0;
//    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        } else {
//            p++;
//        }
//    }
//    return strlength;
}

@end
