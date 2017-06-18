//
//  LinKonDeviceControlPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonDeviceControlPage.h"
#import "ControlTabButton.h"
#import "DeviceInfoView.h"
#import "DeviceControlView.h"
#import "SettingFooterView.h"
#import "SettingSwitchCell.h"
#import "SettingArrowCell.h"
#import "LinKonPopView.h"
#import "TaskListPage.h"
#import "DeviceManager.h"
#import "LinKonDevice.h"

// 设置列表行高
const CGFloat DeviceControlSettingRowsHeight    = 68.0;

// 设备列表底部间距高度
const CGFloat DeviceControlSettingFooterHeight  = 47.0;

// 底部 Tabbar 高度
const CGFloat DeviceControlTabBarHeight         = 49.0;

// 设备信息展示宽高比, 分别在 16:9 或者 3:2 的屏幕中的比例
const CGFloat DeviceControlInfoViewScale_16_9   = 1095.0 / 1242.0;
const CGFloat DeviceControlInfoViewScale_3_2    = 495.0 / 640.0;


typedef NS_ENUM(NSInteger, ControlTabButtonTag) {
    ControlTabButtonTagControl = 0,
    ControlTabButtonTagSetting = 1,
};

@interface LinKonDeviceControlPage () <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, strong) DeviceInfoView *infoView;
@property (nonatomic, strong) DeviceControlView *controlView;
@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) ControlTabButton *controlButton;
@property (nonatomic, strong) ControlTabButton *settingButton;
@property (nonatomic, strong) UITableView *settingTableView;

@property (nonatomic, strong) LinKonPopView *popView;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LinKonDeviceControlPage

- (instancetype)initWithDevice:(NSString *)sn {
    if (self = [super init]) {
        self.sn = sn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.selectedIndex = ControlTabButtonTagControl;
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
    self.infoView.opaque = YES;
    self.controlView.opaque = YES;
    self.tabView.opaque = YES;
    
    self.selectedIndex = ControlTabButtonTagControl;
    self.controlView.sn = self.sn;
    self.infoView.sn = self.sn;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != 2) {
        return DeviceControlSettingFooterHeight;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 2) {
        static NSString *identifierFooter = @"Footer";
        SettingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierFooter];
        if (!footerView) {
            footerView = [[SettingFooterView alloc] initWithReuseIdentifier:identifierFooter];
        }
        
        if (section == 0) {
            footerView.introduce = KString(@"开启后，将室内温度智能恒温控制在设置的温度内。");
        } else if (section == 1) {
            footerView.introduce = KString(@"开启后，空调将按曲线自动设置温度。");
        }
        
        return footerView;
    } else {
        return [UIView new];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseIconCell *cell = nil;
    if (indexPath.section != 2) {
        static NSString *identifierSwitchCell = @"SwitchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifierSwitchCell];
        if (cell == nil) {
            cell = [[SettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSwitchCell];
        }
    } else {
        static NSString *identifierArrowCell = @"ArrowCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifierArrowCell];
        if (cell == nil) {
            cell = [[SettingArrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierArrowCell];
        }
    }
    
    if (indexPath.section == 0) {
        cell.iconImage = [UIImage imageNamed:@"cell_constant"];
        cell.iconTitle = KString(@"智能恒温");
    } else if (indexPath.section == 1) {
        cell.iconImage = [UIImage imageNamed:@"cell_chart"];
        cell.iconTitle = KString(@"温度曲线");
    } else if (indexPath.section == 2) {
        cell.iconImage = [UIImage imageNamed:@"cell_task"];
        cell.iconTitle = KString(@"定时器");
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        id con = [[TaskListPage alloc] initWithDevice:self.sn];
        [self pushViewController:con];
    }
}

#pragma mark - 点击事件

- (void)barButtonItemLeftPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)barButtonItemRightPressed:(id)sender {
    self.popView.hidden = NO;
}

- (void)baseButtonPressed:(UIButton *)sender {
    self.selectedIndex = sender.tag;
}

#pragma mark - Setter

- (void)setSelectedIndex:(NSInteger)index {
    _selectedIndex = index;
    
    self.controlButton.selected = _selectedIndex == self.controlButton.tag;
    self.settingButton.selected = _selectedIndex == self.settingButton.tag;
    
    if (index == ControlTabButtonTagSetting) {
        [self.view bringSubviewToFront:self.settingTableView];
        self.settingTableView.hidden = NO;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = KString(@"智能设置");
    } else {
        if (_settingTableView) {
            self.settingTableView.hidden = YES;
        }
        [self addBarButtonItemBackWithAction:@selector(barButtonItemLeftPressed:)];
        [self addBarButtonItemRightNormalImageName:@"nav_add_blank" hightLited:nil];
        
        WeakObj(self);
        [[DeviceManager sharedManager] registerListener:self device:self.sn group:LinKonPropertyGroupBinding block:^(NSObject *object) {
            LinKonDevice *device = (LinKonDevice *)object;
            selfWeak.navigationItem.title = device.nickname;
        }];
    }
}

#pragma mark - 懒加载

- (DeviceInfoView *)infoView {
    if (!_infoView) {
        CGFloat scale = IPHONE_INCH_3_5 ? DeviceControlInfoViewScale_3_2 : DeviceControlInfoViewScale_16_9;
        
        _infoView = [[DeviceInfoView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     MAIN_SCREEN_WIDTH,
                                                                     floorf(MAIN_SCREEN_WIDTH * scale))];
        [self.view addSubview:_infoView];
    }
    return _infoView;
}

- (DeviceControlView *)controlView {
    if (!_controlView) {
        _controlView = [[DeviceControlView alloc] initWithFrame:CGRectMake(0,
                                                                        CGRectGetMaxY(self.infoView.frame),
                                                                        MAIN_SCREEN_WIDTH,
                                                                        NAVIGATION_VIEW_HEIGHT \
                                                                        - CGRectGetHeight(self.infoView.frame) \
                                                                        - CGRectGetHeight(self.tabView.frame))];
        [self.view addSubview:_controlView];
    }
    return _controlView;
}

- (UIView *)tabView {
    if (!_tabView) {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            NAVIGATION_VIEW_HEIGHT - DeviceControlTabBarHeight,
                                                            MAIN_SCREEN_WIDTH,
                                                            DeviceControlTabBarHeight)];
        [self.view addSubview:_tabView];
        
        _tabView.backgroundColor = HB_COLOR_TABBAR_CUTLINE;
    }
    return _tabView;
}

- (ControlTabButton *)controlButton {
    if (!_controlButton) {
        _controlButton = [[ControlTabButton alloc] initWithFrame:CGRectMake(0,
                                                                            1,
                                                                            CGRectGetWidth(self.tabView.frame) / 2.0,
                                                                            CGRectGetHeight(self.tabView.frame) - 1)];
        [self.tabView addSubview:_controlButton];
        
        [self baseAddTargetForButton:_controlButton];
        _controlButton.tag = ControlTabButtonTagControl;
        [_controlButton setTitle:KString(@"遥控面板") forState:UIControlStateNormal];
        [_controlButton setImage:[UIImage imageNamed:@"tab_control"] forState:UIControlStateNormal];
    }
    return _controlButton;
}

- (ControlTabButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [[ControlTabButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.tabView.frame) / 2.0,
                                                                            1,
                                                                            CGRectGetWidth(self.tabView.frame) / 2.0,
                                                                            CGRectGetHeight(self.tabView.frame) - 1)];
        [self.tabView addSubview:_settingButton];
        
        [self baseAddTargetForButton:_settingButton];
        _settingButton.tag = ControlTabButtonTagSetting;
        [_settingButton setTitle:KString(@"智能设置") forState:UIControlStateNormal];
        [_settingButton setImage:[UIImage imageNamed:@"tab_setting"] forState:UIControlStateNormal];
    }
    return _settingButton;
}

- (UITableView *)settingTableView {
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          MAIN_SCREEN_WIDTH,
                                                                          NAVIGATION_VIEW_HEIGHT - CGRectGetHeight(self.tabView.frame))
                                                         style:UITableViewStylePlain];
        [self.view addSubview:_settingTableView];
        
        _settingTableView.dataSource = self;
        _settingTableView.delegate = self;
        _settingTableView.rowHeight = DeviceControlSettingRowsHeight;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingTableView.tableFooterView = [UIView new];
        
    }
    return _settingTableView;
}

- (LinKonPopView *)popView {
    if (!_popView) {
        _popView = [LinKonPopView new];
        [self.view addSubview:_popView];
        
        WeakObj(self);
        _popView.popBlock = ^(NSInteger index) {
            selfWeak.messageNotify = @"24小时曲线";
        };
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.equalTo(selfWeak.tabView.mas_top);
        }];
    }
    return _popView;
}

@end
