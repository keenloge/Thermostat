//
//  BasePickerPage.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseAlertPage.h"

typedef void(^BasePickerConfirmBlock)();

@interface BasePickerPage : BaseAlertPage {

}

@property (nonatomic, strong) UIPickerView *checkPickerView;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) BasePickerConfirmBlock confirmBlock;

@end
