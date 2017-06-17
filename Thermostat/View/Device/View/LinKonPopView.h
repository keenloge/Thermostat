//
//  LinKonPopView.h
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

@interface LinKonPopView : BaseView

@property (nonatomic, copy) void (^popBlock)(NSInteger index);

@end
