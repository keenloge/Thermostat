//
//  LinKonDevice.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonDevice.h"
#import "DeviceNotifyManager.h"


@interface LinKonDevice () {
    
}

@property (nonatomic, strong) NSMutableArray *savedTimerArray;

@end

@implementation LinKonDevice

/**
 随机生成设备
 
 @return 设备对象
 */
+ (instancetype)randomDevice {
    LinKonDevice *item = [[LinKonDevice alloc] init];

    [item randomProperty];
    
    return item;
}

/**
 生成指定设备
 
 @param sn 设备SN
 @param password 密码
 @return 设备对象
 */
+ (instancetype)deviceWithSN:(long long)sn password:(NSString *)password {
    LinKonDevice *item = [[LinKonDevice alloc] init];
    
    [item randomProperty];
    item->_sn = sn;
    item->_password = password;
    item->_connection = DeviceConnectionStateOffLine;
    
    return item;
}


/**
 赋值随机属性
 */
- (void)randomProperty {
    _sn = [self randomSN];
    
    // 连接状态确定为在线
    _connection = DeviceConnectionStateOnLine;
    
    // 其他属性随机设置
    _nickname = [NSString stringWithFormat:@"%@%02zd", KString(@"温控器"), rand() % 100];
    _password = @"123456";
    _running = (rand() % 100) > 20 ? DeviceRunningStateTurnON : DeviceRunningStateTurnOFF;
    _mode = (rand() % 3) + 1;
    _scene = (rand() % 3) + 1;
    _wind = (rand() % 3) + 1;
    _setting = [self randomTemperature];
    _lock = (rand() % 2) == 0;
    _humidity = (rand() % 100) / 100.0;
    _temperature = [self randomTemperature];
}


/**
 生成随机序列号

 @return 序列号
 */
- (long long)randomSN {
    long long tempSN = ((long long)(rand() % 9000 + 1000)) * 10000 * 10000 * 10000;
    tempSN += ((long long)(rand() % 10000)) * 10000 * 10000;
    tempSN += (rand() % 10000) * 10000;
    tempSN += (rand() % 10000);
    return tempSN;
}


/**
 生成随机温度

 @return 温度
 */
- (CGFloat)randomTemperature {
    return (rand() % (int)(LINKON_TEMPERATURE_MAX - LINKON_TEMPERATURE_MIN)) + LINKON_TEMPERATURE_MIN;
}


- (void)setSetting:(float)setting {
    if (setting < LINKON_TEMPERATURE_MIN) {
        setting = LINKON_TEMPERATURE_MIN;
    } else if (setting > LINKON_TEMPERATURE_MAX) {
        setting = LINKON_TEMPERATURE_MAX;
    }
    
    _setting = roundf(setting * 2.0) / 2.0;
}

- (void)setTemperature:(float)temperature {
    if (temperature < LINKON_TEMPERATURE_MIN) {
        temperature = LINKON_TEMPERATURE_MIN;
    } else if (temperature > LINKON_TEMPERATURE_MAX) {
        temperature = LINKON_TEMPERATURE_MAX;
    }
    
    _temperature = roundf(temperature * 2.0) / 2.0;
}

#pragma mark - Getter

- (NSMutableArray *)savedTimerArray {
    if (!_savedTimerArray) {
        _savedTimerArray = [NSMutableArray array];
    }
    return _savedTimerArray;
}

- (NSArray *)timerArray {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (LinKonTimerTask *timer in self.savedTimerArray) {
        [tempArray addObject:[timer copy]];
    }
    return [tempArray copy];
}

#pragma mark - 定时器 增 删 改

- (BOOL)addTimerTask:(LinKonTimerTask *)timer {
    [timer resetTimerRange];
    for (LinKonTimerTask *item in self.savedTimerArray) {
        if ([item.number isEqualToString:timer.number] || [item isConflictTo:timer]) {
            // 与现有定时器发生冲突
            return NO;
        }
    }
    
    [self.savedTimerArray addObject:timer];
    
    return YES;
}

- (BOOL)removeTimerTask:(LinKonTimerTask *)timer {
    for (LinKonTimerTask *item in self.savedTimerArray) {
        if ([item.number isEqualToString:timer.number]) {
            [self.savedTimerArray removeObject:item];
            return YES;
        }
    }
    return NO;
}

- (BOOL)editTimerTask:(LinKonTimerTask *)timer {
    [timer resetTimerRange];
    for (LinKonTimerTask *item in self.savedTimerArray) {
        if (![item.number isEqualToString:timer.number] && [item isConflictTo:timer]) {
            // 与现有定时器发生冲突
            return NO;
        }
    }
    
    for (int i = 0; i < self.savedTimerArray.count; i++) {
        LinKonTimerTask *item = [self.savedTimerArray objectAtIndex:i];
        if ([item.number isEqualToString:timer.number]) {
            [self.savedTimerArray removeObjectAtIndex:i];
            [self.savedTimerArray insertObject:timer atIndex:i];
            return YES;
        }
    }
    
    // 没找到, 当冲突处理
    return NO;
}

#pragma mark - 修改设备属性

/**
 修改设备属性
 
 @param value 属性值
 @param key 属性Key
 @return 是否修改成功
 */
- (BOOL)updateValue:(id)value forKey:(NSString *)key {
    if (!value || !key) {
        return NO;
    }
    
    BOOL success = NO;
    if ([key isEqualToString:KDeviceTimerAdd]) {
        // 添加定时器
        success = [self addTimerTask:value];
    } else if ([key isEqualToString:KDeviceTimerEdit]) {
        // 修改定时器
        success = [self editTimerTask:value];
    } else if ([key isEqualToString:KDeviceTimerRemove]) {
        // 删除定时器
        success = [self removeTimerTask:value];
    } else {
        // 其他普通属性
        [self setValue:value forKey:key];
        success = YES;
        
        if ([key isEqualToString:KDeviceRunning]) {
            // 更改运行状态, 需要重置延时开关
            _delay = 0.0;
        }
    }
    
    if (success) {
        // 发送通知
        [[DeviceNotifyManager sharedManager] postNotifyType:[self notifyTypeWithKey:key] sn:_sn key:key];
    }
    
    return success;
}


/**
 获取对应通知类别
 
 @param key 属性Key
 @return 通知类别
 */
- (DeviceNotifyType)notifyTypeWithKey:(NSString *)key {
    if ([key isEqualToString:KDeviceConnection]
        || [key isEqualToString:KDeviceRunning]) {
        return DeviceNotifyTypeState;
    } else if ([key isEqualToString:KDeviceNickname]
               || [key isEqualToString:KDevicePassword]) {
        return DeviceNotifyTypeIdentity;
    } else if ([key isEqualToString:KDeviceTimerAdd]
               || [key isEqualToString:KDeviceTimerEdit]
               || [key isEqualToString:KDeviceTimerRemove]) {
        return DeviceNotifyTypeTimer;
    } else {
        return DeviceNotifyTypeSetting;
    }
    
    return DeviceNotifyTypeNone;
}

@end
