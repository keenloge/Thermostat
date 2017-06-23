//
//  TaskEditPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskEditPage.h"
#import "TaskRepeatCell.h"
#import "TimePickerPage.h"
#import "TemperaturePickerPage.h"
#import "EnumPickerPage.h"
#import "DeviceListManager.h"
#import "LinKonTimerTask.h"
#import "BaseTableViewCell.h"

const CGFloat TaskEditRepeatRowsHeight  = 88.0;
const CGFloat TaskEditSettingRowsHeight = 44.0;

/**
 任务编辑类别
 
 - TaskEditTypeNew: 新建任务
 - TaskEditTypeEdit: 编辑任务
 */
typedef NS_ENUM(NSInteger, TaskEditType) {
    TaskEditTypeNew = 1,
    TaskEditTypeEdit = 2,
};

@interface TaskEditPage ()

@property (nonatomic, assign) TaskEditType type;
@property (nonatomic, strong) LinKonTimerTask *task;

@end

@implementation TaskEditPage

- (instancetype)initWithTask:(LinKonTimerTask *)task device:(long long)sn {
    if (self = [super init]) {
        self.type = TaskEditTypeEdit;
        self.baseSN = sn;
        self.task = [task copy];
    }
    return self;
}

- (instancetype)initWithType:(LinKonTimerTaskType)type device:(long long)sn {
    if (self = [super init]) {
        self.type = TaskEditTypeNew;
        self.baseSN = sn;
        self.task = [[LinKonTimerTask alloc] initWithType:type device:sn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type == TaskEditTypeNew) {
        self.navigationItem.title = KString(@"添加定时器");
    } else if (self.type == TaskEditTypeEdit) {
        if (self.task.type == LinKonTimerTaskTypeStage) {
            self.navigationItem.title = KString(@"阶段定时器设置");
        } else {
            self.navigationItem.title = KString(@"开关定时器设置");
        }
    }
    [self addBarButtonItemRightTitle:KString(@"保存")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.baseTableView.opaque = YES;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /*
     1. 时间, 若是开关任务, 则只有时间, 若是阶段任务, 则有起止时间两行
     2. 周期
     3. 开关 只有开关任务才显示
     4. 温度 只有模式非换气时才显示
     5. 其他设定, 包含 模式, 情景, 风速
     */
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.task.type == LinKonTimerTaskTypeSwitch) {
            // 开关任务 只有一个时间
            return 1;
        } else if (self.task.type == LinKonTimerTaskTypeStage) {
            // 阶段任务 有起止时间
            return 2;
        }
    } else if (section == 1) {
        // 重复
        return 1;
    } else if (section == 2) {
        // 只有开关任务才有开关选项
        if (self.task.type == LinKonTimerTaskTypeSwitch) {
            return 1;
        } else if (self.task.type == LinKonTimerTaskTypeStage) {
            return 0;
        }
    } else if (section == 3) {
        // 温度 设定
        if (self.task.mode == LinKonModeAir) {
            // 换气时, 无温度设定
            return 0;
        }
        
        if (self.task.type == LinKonTimerTaskTypeSwitch) {
            if (self.task.running == DeviceRunningStateTurnON) {
                // 开机任务
                return 1;
            } else {
                // 关机任务
                return 0;
            }
        } else if (self.task.type == LinKonTimerTaskTypeStage) {
            // 阶段任务
            return 1;
        }
    } else if (section == 4) {
        // 风速 模式 情景 设定
        if (self.task.type == LinKonTimerTaskTypeSwitch) {
            if (self.task.running == DeviceRunningStateTurnON) {
                // 开机任务
                return 3;
            } else {
                // 关机任务
                return 0;
            }
        } else if (self.task.type == LinKonTimerTaskTypeStage) {
            // 阶段任务
            return 3;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 36.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView heightForHeaderInSection:section] > 0.0) {
        static NSString *identifierHeader = @"Header";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifierHeader];
            headerView.contentView.backgroundColor = HB_COLOR_BASE_WHITE;
            
            UIView *cutLineBottomView = [UIView new];
            [headerView.contentView addSubview:cutLineBottomView];
            
            cutLineBottomView.backgroundColor = UIColorFromHex(0xd6d5d9);
            
            [cutLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(0);
                make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT);
            }];
        }
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 && self.task.type == LinKonTimerTaskTypeSwitch && self.task.running == DeviceRunningStateTurnON) {
        return 36.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self tableView:tableView heightForFooterInSection:section] > 0.0) {
        static NSString *identifierFooter = @"Footer";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierFooter];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifierFooter];
            headerView.contentView.backgroundColor = HB_COLOR_BASE_WHITE;
            
            
            UIView *bottomLineView = [UIView new];
            [headerView.contentView addSubview:bottomLineView];
            
            bottomLineView.backgroundColor = UIColorFromHex(0xd6d5d9);
            
            [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(0);
                make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT);
            }];
        }
        
        return headerView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        // 周期行高度
        return TaskEditRepeatRowsHeight;
    } else {
        // 其他行高度
        return TaskEditSettingRowsHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        static NSString *identifierRepeatCell = @"TaskRepeatCell";
        TaskRepeatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRepeatCell];
        if (cell == nil) {
            cell = [[TaskRepeatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierRepeatCell];
        }
        
        cell.repeat = self.task.repeat;
        
        WeakObj(self);
        cell.block = ^(Byte repeat) {
            selfWeak.task.repeat = repeat;
        };
        
        return cell;
    } else if (indexPath.section == 2) {
        
        static NSString *switchIdentifierCell = @"SwitchCell";
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifierCell];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchIdentifierCell];
            [cell updateTitleFont:UIFontOf3XPix(51) color:UIColorFromRGBA(0, 0, 0, 0.85) paddingLeft:15];
            cell.baseAccessoryType = BaseTableViewCellAccessoryTypeSwitch;
            cell.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        cell.baseTitleString = KString(@"开关");

        WeakObj(self);
        [cell updateBaseSwitchOn:self.task.running == DeviceRunningStateTurnON switchBlock:^(BOOL on) {
            selfWeak.task.running = on ? DeviceRunningStateTurnON : DeviceRunningStateTurnOFF;
            [selfWeak.baseTableView reloadData];
        }];
        
        return cell;
    } else {
        static NSString *arrowIdentifierCell = @"ArrowCell";
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:arrowIdentifierCell];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arrowIdentifierCell];
            [cell updateTitleFont:UIFontOf3XPix(51) color:UIColorFromRGBA(0, 0, 0, 0.85) paddingLeft:15];
            [cell updateDetailFont:UIFontOf3XPix(42) color:UIColorFromRGBA(0, 0, 0, 0.62) paddingRight:15];

            cell.tintColor = UIColorFromHex(0xc7c7cc);
            cell.baseAccessoryType = BaseTableViewCellAccessoryTypeArrow;
//            cell.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if (self.task.type == LinKonTimerTaskTypeSwitch) {
                    cell.baseTitleString = KString(@"时间");
                } else if (self.task.type == LinKonTimerTaskTypeStage) {
                    cell.baseTitleString = KString(@"开始时间");
                }
                cell.baseDetailString = [LinKonHelper timeString:self.task.timeFrom];
            } else if (indexPath.row == 1) {
                cell.baseTitleString = KString(@"结束时间");
                if (self.task.timeFrom > self.task.timeTo) {
                    cell.baseDetailString = [NSString stringWithFormat:@"%@ %@", KString(@"次日"), [LinKonHelper timeString:self.task.timeTo]];
                } else {
                    cell.baseDetailString = [LinKonHelper timeString:self.task.timeTo];
                }
            }
            cell.baseCutLineInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.baseTitleString = KString(@"温度");
                cell.baseDetailString = [LinKonHelper settingString:self.task.setting];
            }
            cell.baseCutLineInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        } else if (indexPath.section == 4) {
            cell.baseCutLineInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            if (indexPath.row == 0) {
                cell.baseTitleString = KString(@"风速");
                cell.baseDetailString = [LinKonHelper windString:self.task.wind];
            } else if (indexPath.row == 1) {
                cell.baseTitleString = KString(@"模式");
                cell.baseDetailString = [LinKonHelper modeString:self.task.mode];
            } else if (indexPath.row == 2) {
                cell.baseTitleString = KString(@"情景");
                cell.baseDetailString = [LinKonHelper sceneString:self.task.scene];
                cell.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id con = nil;
    
    WeakObj(self);
    if (indexPath.section == 0) {
        BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 0) {
            con = [[TimePickerPage alloc] initWithTitle:cell.baseTitleString time:self.task.timeFrom block:^(NSInteger time) {
                selfWeak.task.timeFrom = time;
                [selfWeak.baseTableView reloadData];
            }];
        } else if (indexPath.row == 1) {
            con = [[TimePickerPage alloc] initWithTitle:cell.baseTitleString time:self.task.timeTo block:^(NSInteger time) {
                selfWeak.task.timeTo = time;
                [selfWeak.baseTableView reloadData];
            }];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            con = [[TemperaturePickerPage alloc] initWithSetting:self.task.setting block:^(float value) {
                selfWeak.task.setting = value;
                [selfWeak.baseTableView reloadData];
            }];
        }
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            con = [[EnumPickerPage alloc] initWithType:EnumPickerTypeWind value:self.task.wind block:^(NSInteger value) {
                selfWeak.task.wind = value;
                [selfWeak.baseTableView reloadData];
            }];
        } else if (indexPath.row == 1) {
            con = [[EnumPickerPage alloc] initWithType:EnumPickerTypeMode value:self.task.mode block:^(NSInteger value) {
                selfWeak.task.mode = value;
                [selfWeak.baseTableView reloadData];
            }];
        } else if (indexPath.row == 2) {
            con = [[EnumPickerPage alloc] initWithType:EnumPickerTypeScene value:self.task.scene block:^(NSInteger value) {
                selfWeak.task.scene = value;
                [selfWeak.baseTableView reloadData];
            }];
        }
    }
    
    if (con) {
        [self presentViewController:con animated:YES completion:^{
            
        }];
    }
}

#pragma mark - 点击事件

- (void)barButtonItemRightPressed:(id)sender {
    LinKonDevice *device = [[DeviceListManager sharedManager] getDevice:self.baseSN];
    if (self.type == TaskEditTypeNew) {
        if ([device updateValue:self.task forKey:KDeviceTimerAdd]) {
            [self popViewController];
            return;
        }
    } else if (self.type == TaskEditTypeEdit) {
        if ([device updateValue:self.task forKey:KDeviceTimerEdit]) {
            [self popViewController];
            return;
        }
    }
    self.baseMessageNotify = KString(@"与其他定时器行为冲突");
}

@end
