//
//  NotifyTarget.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LinKonDevice;

/**
 属性监听回调

 @param device 改变的设备
 @param key 改变的属性
 */
typedef void(^NotifyTargetBlock)(LinKonDevice *device, NSString *key);

/**
 列表监听回调

 @param array 对象列表
 */
typedef void(^NotifyListBlock)(NSArray *array);


/**
 监听通知
 一个 "监听者" 监听一个 "对象" 的多个 "属性", 或者监听 "对象" 列表.
 */
@interface NotifyTarget : NSObject


/**
 监听者
 */
@property (nonatomic, weak) id listener;

/**
 对象唯一标志
 */
@property (nonatomic, copy) NSString *sign;

/**
 列表监听 Block
 */
@property (nonatomic, copy) NotifyListBlock listBlock;

/**
 监听属性组
 */
@property (nonatomic, assign) Byte propertyGroup;

/**
 属性监听回调
 */
@property (nonatomic, copy) NotifyTargetBlock groupBlock;

@end
