//
//  BasePickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePopPage.h"

typedef void(^BasePickerConfirmBlock)();


/**
 基础选择控制器
 */
@interface BasePickerPage : BasePopPage {

}


/**
 选择器
 */
@property (nonatomic, strong) UIPickerView *checkPickerView;


/**
 标题
 */
@property (nonatomic, copy) NSString *titleString;


/**
 选择确认回调
 */
@property (nonatomic, copy) BasePickerConfirmBlock confirmBlock;

@end
