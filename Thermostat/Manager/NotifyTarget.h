//
//  NotifyTarget.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 属性监听回调

 @param object 被改变的对象
 */
typedef void(^NotifyTargetBlock)(NSObject *object);


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
 属性监听 Block 字典
 */
@property (nonatomic, strong) NSMutableDictionary<NSString*, NotifyTargetBlock> *blockDictionary;

@end
