//
//  SideSettingPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideSettingPage.h"
#import "TemperatureUnitManager.h"
#import "FeedBackManager.h"
#import "BaseTableCell.h"
#import "BaseHeaderFooterView.h"

@interface SideSettingPage ()

@end

@implementation SideSettingPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)baseInitialiseSubViews {
    self.baseTableView.rowHeight = KHorizontalRound(54.0);
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)baseResetLanguage {
    self.navigationItem.title = KString(@"系统设置");
    [self.baseTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifierHeader = @"Header";
    BaseHeaderFooterView *headerView = (BaseHeaderFooterView *)[tableView dequeueReusableCellWithIdentifier:identifierHeader];
    if (!headerView) {
        headerView = [[BaseHeaderFooterView alloc] initWithReuseIdentifier:identifierHeader];
        headerView.baseTitleLabel.textColor = HB_COLOR_BASE_BLACK;
        headerView.baseTitleLabel.alpha = 0.6;
        headerView.baseTitleLabel.font = UIFontOf1XPix(KHorizontalRound(14.0));
        [headerView updateTitlePaddingLeft:KHorizontalRound(17)];
        headerView.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (section == 0) {
        headerView.baseTitleLabel.text = KString(@"控制反馈");
    } else if (section == 1) {
        headerView.baseTitleLabel.text = KString(@"温度单位");
    } else if (section == 2) {
        headerView.baseTitleLabel.text = KString(@"语言设置");
    }
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *baseIdentifierCell = @"SideSettingCell";
    BaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifierCell];
    if (!cell) {
        cell = [[BaseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseIdentifierCell];
        cell.baseTitleLabel.font = UIFontOf1XPix(KHorizontalRound(17));
        cell.baseTitleLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.85);
        [cell updateTitlePaddingLeft:KHorizontalRound(16)];
        cell.tintColor = HB_COLOR_BASE_MAIN;
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    WeakObj(self);
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseAttachType = BaseTableCellAttachTypeSwitch;
        if (indexPath.row == 0) {
            cell.baseTitleLabel.text = KString(@"声音");
            [cell updateBaseSwitchOn:[FeedBackManager sharedManager].isSound switchBlock:^(BOOL on) {
                [FeedBackManager sharedManager].sound = on;
                [selfWeak.baseTableView reloadData];
            }];
        } else if (indexPath.row == 1) {
            cell.baseTitleLabel.text = KString(@"振动");
            [cell updateBaseSwitchOn:[FeedBackManager sharedManager].isVibrate switchBlock:^(BOOL on) {
                [FeedBackManager sharedManager].vibrate = on;
                [selfWeak.baseTableView reloadData];
            }];
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.baseTitleLabel.text = KString(@"摄氏度");
            if ([TemperatureUnitManager sharedManager].unitType == TemperatureUnitTypeCentigrade) {
                cell.baseAttachType = BaseTableCellAttachTypeCheck;
            } else {
                cell.baseAttachType = BaseTableCellAttachTypeNone;
            }
        } else if (indexPath.row == 1) {
            cell.baseTitleLabel.text = KString(@"华氏度");
            if ([TemperatureUnitManager sharedManager].unitType == TemperatureUnitTypeFahrenheit) {
                cell.baseAttachType = BaseTableCellAttachTypeCheck;
            } else {
                cell.baseAttachType = BaseTableCellAttachTypeNone;
            }
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.baseTitleLabel.text = KString(@"简体中文");
            if ([LanguageManager sharedManager].typeLanguage == LanguageTypeChinese) {
                cell.baseAttachType = BaseTableCellAttachTypeCheck;
            } else {
                cell.baseAttachType = BaseTableCellAttachTypeNone;
            }
        } else if (indexPath.row == 1) {
            cell.baseTitleLabel.text = KString(@"English");
            if ([LanguageManager sharedManager].typeLanguage == LanguageTypeEnglish) {
                cell.baseAttachType = BaseTableCellAttachTypeCheck;
            } else {
                cell.baseAttachType = BaseTableCellAttachTypeNone;
            }
        }
        
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        cell.baseCutLineInsets = UIEdgeInsetsMake(0, KHorizontalRound(17), 0, 0);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [TemperatureUnitManager sharedManager].unitType = TemperatureUnitTypeCentigrade;
        } else if (indexPath.row == 1) {
            [TemperatureUnitManager sharedManager].unitType = TemperatureUnitTypeFahrenheit;
        }
        [self.baseTableView reloadData];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [LanguageManager sharedManager].typeLanguage = LanguageTypeChinese;
        } else if (indexPath.row == 1) {
            [LanguageManager sharedManager].typeLanguage = LanguageTypeEnglish;
        }
    }
}


@end
