//
//  NSStringAdditions.h
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UUID)

+ (NSString *)uuidString;

@end


@interface NSString (MixLengh)

- (NSInteger)mixedLenght;

@end
