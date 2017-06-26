//
//  TaskListPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskListPage.h"
#import "DeviceListManager.h"
#import "TaskBlankView.h"
#import "TaskEditPage.h"
#import "TaskCell.h"
#import "LinKonDevice.h"
#import "LinKonTimerTask.h"

const CGFloat TaskListRowsHeight = 80.0;

@interface TaskListPage () {
    CGFloat lineSpace;  // 行间距, 起止时间行间距, 任务计划周期与设置行间距
    NSDictionary *repeatDictionary;
    NSDictionary *settingDictionary;
}


@property (nonatomic, strong) TaskBlankView *blankView;

@end

@implementation TaskListPage

- (instancetype)initWithDevice:(long long)sn {
    if (self = [super initWithSN:sn typeGroup:DeviceNotifyTypeTimer]) {
        lineSpace = 8.0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        repeatDictionary = @{NSFontAttributeName : UIFontOf3XPix(KHorizontalRound(39)),
                             NSParagraphStyleAttributeName : paragraphStyle,
                             NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};
        settingDictionary = @{NSFontAttributeName : UIFontOf3XPix(KHorizontalRound(34)),
                              NSParagraphStyleAttributeName : paragraphStyle,
                              NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBarButtonItemRightNormalImageName:@"nav_add_blank" hightLited:nil];
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

}

- (void)baseReceiveNotifyWithSN:(long long)sn key:(NSString *)key {
    LinKonDevice *device = (LinKonDevice *)[[DeviceListManager sharedManager] getDevice:self.baseSN];
    [self.baseContentArr removeAllObjects];
    [self.baseContentArr addObjectsFromArray:device.timerArray];
    [self.baseTableView reloadData];
    if (self.baseContentArr.count > 0) {
        [self hideBlankView];
    } else {
        [self showBlankView];
    }
}

- (void)showBlankView {
    self.navigationItem.title = KString(@"定时");
    self.blankView.hidden = NO;
    self.baseTableView.hidden = YES;
    WeakObj(self);
    self.blankView.block = ^(LinKonTimerTaskType type) {
        id con = [[TaskEditPage alloc] initWithType:type device:selfWeak.baseSN];
        [selfWeak pushViewController:con];
    };
}

- (void)hideBlankView {
    self.navigationItem.title = KString(@"定时器列表");
    if (_blankView) {
        self.blankView.hidden = YES;
    }
    self.baseTableView.separatorInset = UIEdgeInsetsMake(0, KHorizontalRound(57), 0, 0);
    self.baseTableView.hidden = NO;
    self.baseTableView.rowHeight = KHorizontalRound(TaskListRowsHeight);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.baseContentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"TaskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    LinKonTimerTask *task = [self.baseContentArr objectAtIndex:indexPath.row];
    
    NSString *imageName = nil;
    UIColor *timeColor = nil;
    UIFont *timeFont = nil;
    NSString *timeString = nil;
    NSString *planString = nil;
    NSMutableAttributedString *attributedText = nil;
    
    if (task.validate) {
        timeColor = UIColorFromRGBA(0, 0, 0, 0.85);
        if (task.type == LinKonTimerTaskTypeSwitch) {
            imageName = @"cell_switch_on";
        } else if (task.type == LinKonTimerTaskTypeStage) {
            imageName = @"cell_stage_on";
        }
    } else {
        timeColor = UIColorFromRGBA(0, 0, 0, 0.6);
        if (task.type == LinKonTimerTaskTypeSwitch) {
            imageName = @"cell_switch_off";
        } else if (task.type == LinKonTimerTaskTypeStage) {
            imageName = @"cell_stage_off";
        }
    }

    
    if (task.type == LinKonTimerTaskTypeSwitch) {
        // 开关时间
        timeFont = UIFontOf3XPix(KHorizontalRound(63));
        timeString = [LinKonHelper timeString:task.timeFrom];
    } else if (task.type == LinKonTimerTaskTypeStage) {
        // 起止时间
        timeFont = UIFontOf3XPix(KHorizontalRound(54));
        timeString = [NSString stringWithFormat:@"%@\n%@", [LinKonHelper timeString:task.timeFrom], [LinKonHelper timeString:task.timeTo]];
    }

    NSString *repeatString = [LinKonHelper repeatString:task.repeat];
    
    NSString *settingString = nil;
    if (task.type == LinKonTimerTaskTypeSwitch && task.running == DeviceRunningStateTurnOFF) {
        settingString = KString(@"关");
    } else {
        // 设定
        NSMutableArray *settingArray = [NSMutableArray array];
        if (task.mode != LinKonModeAir) {
            // 非换气, 才有温度
            [settingArray addObject:[LinKonHelper settingString:task.setting]];
        }
        [settingArray addObject:[LinKonHelper windString:task.wind]];
        [settingArray addObject:[LinKonHelper modeString:task.mode]];
        [settingArray addObject:[LinKonHelper sceneString:task.scene]];
        settingString = [settingArray componentsJoinedByString:@" "];
    }
    
    if (repeatString.length > 0) {
        NSAttributedString *repeatAttributedString = [[NSAttributedString alloc] initWithString:repeatString attributes:repeatDictionary];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        
        [attributedString appendAttributedString:repeatAttributedString];
        settingString = [NSString stringWithFormat:@"\n%@", settingString];
        NSAttributedString *settingAttributedString = [[NSAttributedString alloc] initWithString:settingString attributes:settingDictionary];
        [attributedString appendAttributedString:settingAttributedString];
        
        attributedText = attributedString;
    } else {
        attributedText = nil;
        planString = settingString;
    }

    cell.baseImageView.image = [UIImage imageNamed:imageName];

    [cell updateTimeString:timeString font:timeFont color:timeColor];
    [cell updatePlanString:planString attributedText:attributedText];
    
    WeakObj(self);
    WeakObj(task);

    [cell updateBaseSwitchOn:task.validate switchBlock:^(BOOL on) {
        task.validate = on;
        LinKonDevice *device = (LinKonDevice *)[[DeviceListManager sharedManager] getDevice:selfWeak.baseSN];
        if (![device updateValue:task forKey:KDeviceTimerEdit]) {
            // 修改失败, 撤销操作, 刷新界面
            selfWeak.baseMessageNotify = KString(@"与其他定时器行为冲突");
            taskWeak.validate = !on;
            [selfWeak.baseTableView reloadData];
        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LinKonTimerTask *item = [self.baseContentArr objectAtIndex:indexPath.row];
    id con = [[TaskEditPage alloc] initWithTask:item device:self.baseSN];
    [self pushViewController:con];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 该函数存在的意义在于, 没它的话, iOS 8 侧滑不出菜单
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self);
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:KString(@"编辑") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        action.backgroundColor = UIColorFromHex(0xcccccc);
        LinKonTimerTask *item = [selfWeak.baseContentArr objectAtIndex:indexPath.row];
        id con = [[TaskEditPage alloc] initWithTask:item device:selfWeak.baseSN];
        [selfWeak pushViewController:con];
        [selfWeak.baseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:KString(@"删除") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        action.backgroundColor = UIColorFromHex(0xff0021);
        LinKonDevice *device = (LinKonDevice *)[[DeviceListManager sharedManager] getDevice:selfWeak.baseSN];
        LinKonTimerTask *item = [selfWeak.baseContentArr objectAtIndex:indexPath.row];
        [device updateValue:item forKey:KDeviceTimerRemove];
    }];
    return @[removeAction, editAction];
}

#pragma mark - 点击事件

- (void)barButtonItemRightPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakObj(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:KString(@"开关定时") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id con = [[TaskEditPage alloc] initWithType:LinKonTimerTaskTypeSwitch device:selfWeak.baseSN];
        [selfWeak pushViewController:con];
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:KString(@"阶段定时") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id con = [[TaskEditPage alloc] initWithType:LinKonTimerTaskTypeStage device:selfWeak.baseSN];
        [selfWeak pushViewController:con];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:searchAction];
    [alert addAction:addAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


#pragma mark - 懒加载

- (TaskBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TaskBlankView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     MAIN_SCREEN_WIDTH,
                                                                     NAVIGATION_VIEW_HEIGHT)];
        [self.view addSubview:_blankView];
    }
    return _blankView;
}

@end
