//
//  BaseListViewPage.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseViewPage.h"

@interface BaseListViewPage : BaseViewPage <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) NSMutableArray *baseContentArr;

@end

