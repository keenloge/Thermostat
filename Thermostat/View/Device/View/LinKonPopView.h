//
//  LinKonPopView.h
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"


/**
 设备控制界面弹窗列表界面
 */
@interface LinKonPopView : BaseView

/**
 弹窗列表选中回调
 */
@property (nonatomic, copy) void (^popBlock)(NSInteger index);


/**
 更新图标与标题

 @param imageArray 图标数组
 @param titleArray 标题数组
 */
- (void)updatePopImageArray:(NSArray <UIImage *>*)imageArray
                 titleArray:(NSArray <NSString *>*)titleArray;

@end
