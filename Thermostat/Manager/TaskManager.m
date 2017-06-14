//
//  TaskManager.m
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskManager.h"
#import "Task.h"

static TaskManager *_currentTaskManager;

@interface TaskManager ()


/**
 任务列表字典
 */
@property (nonatomic, strong) NSMutableDictionary <NSString*, NSMutableArray*> *taskListDictionary;


/**
 列表监听对象
 */
@property (nonatomic, strong) NSMutableDictionary <NSString*, NSMutableArray*> *listBlockDictionary;


/**
 属性监听对象
 */
@property (nonatomic, strong) NSMutableDictionary <NSString*, NSMutableArray*> *editBlockDictionary;

@end

@implementation TaskManager

#pragma mark - 单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentTaskManager = [super allocWithZone:zone];
    });
    return _currentTaskManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentTaskManager = [[self alloc] init];
    });
    return _currentTaskManager;
}

- (instancetype)copy {
    return _currentTaskManager;
}

- (instancetype)mutableCopy {
    return _currentTaskManager;
}

#pragma mark - Getter

- (NSMutableDictionary *)taskListDictionary {
    if (!_taskListDictionary) {
        _taskListDictionary = [NSMutableDictionary dictionary];
    }
    return _taskListDictionary;
}

- (NSMutableDictionary *)listBlockDictionary {
    if (!_listBlockDictionary) {
        _listBlockDictionary = [NSMutableDictionary dictionary];
    }
    return _listBlockDictionary;
}

- (NSMutableDictionary *)editBlockDictionary {
    if (!_editBlockDictionary) {
        _editBlockDictionary = [NSMutableDictionary dictionary];
    }
    return _editBlockDictionary;
}

#pragma mark - 任务管理


/**
 添加任务

 @param task 任务
 */
- (void)addTask:(Task *)task {
    
    if (!task.number || !task.sn) {
        return;
    }
    
    // 移除重复的任务
    [self removeTask:task.number device:task.sn notify:NO];
    
    // 添加任务
    NSMutableArray *taskArray = [self.taskListDictionary objectForKey:task.sn];
    if (!taskArray) {
        taskArray = [NSMutableArray array];
        [self.taskListDictionary setObject:taskArray forKey:task.sn];
    }
    
    [taskArray addObject:task];
    
    // 通知监听了任务列表的对象
    [self notifyBlockList:task.sn];
}


/**
 移除任务
 
 @param number 任务编号
 @param sn 设备SN
 */
- (void)removeTask:(NSString *)number
            device:(NSString *)sn {
    
    [self removeTask:number device:sn notify:YES];
}


/**
 移除任务

 @param number 任务编号
 @param sn 设备SN
 @param notify 是否通知
 */
- (void)removeTask:(NSString *)number
            device:(NSString *)sn
            notify:(BOOL)notify {
    
    if (!number || !sn) {
        return;
    }
    
    NSMutableArray *taskArray = [self.taskListDictionary objectForKey:sn];
    for (int i = 0; i < taskArray.count; i++) {
        Task *task = [taskArray objectAtIndex:i];
        if ([task.number isEqualToString:number]) {
            [taskArray removeObjectAtIndex:i];
            
            if (notify) {
                [self notifyBlockList:sn];
            }
            
            [self resignListenerTargetWithTask:task];
            break;
        }
    }
}


/**
 编辑任务

 @param task 任务
 */
- (void)editTask:(Task *)task {
    if (!task || !task.number || !task.sn) {
        return;
    }
    
    NSMutableArray *taskArray = [self.taskListDictionary objectForKey:task.sn];
    for (int i = 0; i < taskArray.count; i++) {
        Task *item = [taskArray objectAtIndex:i];
        if ([task.number isEqualToString:item.number]) {
            [taskArray removeObjectAtIndex:i];
            [taskArray insertObject:task atIndex:i];
            [self notifyBlockList:task.sn];
            
            break;
        }
    }
}

/**
 获取任务

 @param number 任务编号
 @param sn 设备SN
 @return 任务
 */
- (Task *)getTask:(NSString *)number
           device:(NSString *)sn {
    
    if (!number || !sn) {
        return nil;
    }
    
    NSArray *taskArray = [self.taskListDictionary objectForKey:sn];
    for (Task *item in taskArray) {
        if ([item.number isEqualToString:number]) {
            return item;
        }
    }
    return nil;
}

#pragma mark - 监听列表

/**
 监听任务列表

 @param listener 监听者
 @param sn 设备SN
 @param block 监听回调 Block
 */
- (void)listenTaskList:(id)listener
                device:(NSString *)sn
                 block:(NotifyListBlock)block {
    
    if (!listener || !sn || !block) {
        return;
    }
    
    NSMutableArray *targetArray = [self.listBlockDictionary objectForKey:sn];
    if (!targetArray) {
        targetArray = [NSMutableArray array];
        [self.listBlockDictionary setObject:targetArray forKey:sn];
    }
    
    NotifyTarget *target = nil;
    for (int i = 0; i < targetArray.count; i++) {
        NotifyTarget *item = [targetArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [targetArray removeObjectAtIndex:i];
            i--;
            continue;
        }
        
        if (item.listener == listener) {
            // 之前已经注册过, 无需新建
            target = item;
            break;
        }
    }
    
    if (!target) {
        // 全新的一次注册
        target = [[NotifyTarget alloc] init];
        target.listener = listener;
        [targetArray addObject:target];
    }
    
    target.listBlock = block;

    // 立即通知
    if (block) {
        block([[self.taskListDictionary objectForKey:sn] copy]);
    }
}


/**
 通知监听列表回调

 @param sn 设备SN
 */
- (void)notifyBlockList:(NSString *)sn {
    NSMutableArray *targetArray = [self.listBlockDictionary objectForKey:sn];
    for (int i = 0; i < targetArray.count; i++) {
        NotifyTarget *target = [targetArray objectAtIndex:i];
        if (!target.listener) {
            // 移除监听者已释放的对象
            [targetArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if (target.listBlock) {
                target.listBlock([[self.taskListDictionary objectForKey:sn] copy]);
            }
        }
    }
}

#pragma mark - 监听属性

/**
 监听任务属性

 @param listener 监听者
 @param number 任务编号
 @param sn 设备SN
 @param key 属性
 @param block 回调 Block
 */
- (void)registerListener:(id)listener
                    task:(NSString *)number
                  device:(NSString *)sn
                     key:(NSString *)key
                   block:(NotifyTargetBlock)block {
    
    if (!listener || !number || !sn || !key || !block) {
        return;
    }
    
    NSMutableArray<NotifyTarget*> *targetArray = [self.editBlockDictionary objectForKey:sn];
    if (!targetArray) {
        targetArray = [NSMutableArray array];
        [self.editBlockDictionary setObject:targetArray forKey:sn];
    }
    
    NotifyTarget *target = nil;
    for (int i = 0; i < targetArray.count; i++) {
        NotifyTarget *item = [targetArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [targetArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if (item.listener == listener) {
                // 之前注册过
                target = item;
                if (![target.sign isEqualToString:number]) {
                    // 监听任务已改变, 须注销之前的监听
                    target.sign = number;
                    [target.blockDictionary removeAllObjects];
                } else {
                    // 监听任务未改变
                    // Do Nothing
                }
                break;
            }
        }
    }
    
    if (!target) {
        // 一次全新的注册
        target = [[NotifyTarget alloc] init];
        target.listener = listener;
        target.sign = number;
        [targetArray addObject:target];
    }
    
    [target.blockDictionary setObject:[block copy] forKey:key];
    
    // 立即通知
    Task *task = [self getTask:number device:sn];
    if (task) {
        if (block) {
            block(task);
        }
    }
}


/**
 移除任务通知

 @param task 任务
 */
- (void)resignListenerTargetWithTask:(Task *)task {
    
    if (!task || !task.sn || !task.number) {
        return;
    }
    
    NSMutableArray<NotifyTarget*> *targetArray = [self.editBlockDictionary objectForKey:task.sn];
    for (int i = 0; i < targetArray.count; i++) {
        NotifyTarget *item = [targetArray objectAtIndex:i];
        if (!item.listener) {
            // 移除监听者已释放的对象
            [targetArray removeObjectAtIndex:i];
            i--;
            continue;
        } else {
            if ([item.sign isEqualToString:task.number]) {
                [targetArray removeObjectAtIndex:i];
                i--;
            }
        }
    }
}

/**
 编辑任务

 @param number 任务编号
 @param sn 设备SN
 @param key 任务属性
 @param value 属性值
 */
- (void)editTask:(NSString *)number
          device:(NSString *)sn
             key:(NSString *)key
           value:(id)value {
    
    if (!number || !sn || !key || !value) {
        return;
    }

    Task *task = [self getTask:number device:sn];
    if (task) {
        // 找到全局对应的任务, 并更新值
        [task setValue:value forKey:key];
        
        NSMutableArray<NotifyTarget*> *targetArray = [self.editBlockDictionary objectForKey:sn];
        for (int i = 0; i < targetArray.count; i++) {
            NotifyTarget *item = [targetArray objectAtIndex:i];
            if (!item.listener) {
                // 移除监听者已释放的对象
                [targetArray removeObjectAtIndex:i];
                i--;
                continue;
            } else {
                if ([item.sign isEqualToString:number]) {
                    NotifyTargetBlock block = [item.blockDictionary objectForKey:key];
                    if (block) {
                        block(task);
                    }
                }
            }
        }
    }
}

@end
