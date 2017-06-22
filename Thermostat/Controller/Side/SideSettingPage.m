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
#import "BaseTableViewCell.h"

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
    self.baseTableView.rowHeight = 54.0;
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
    NSInteger labelTag = 11;
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifierHeader];
        headerView.contentView.backgroundColor = UIColorFromHex(0xf7f7f7);
        
        UILabel *titleLabel = [UILabel new];
        [headerView.contentView addSubview:titleLabel];
        
        titleLabel.tag = labelTag;
        titleLabel.textColor = HB_COLOR_BASE_BLACK;
        titleLabel.alpha = 0.6;
        titleLabel.font = UIFontOf1XPix(14);
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(17);
        }];
        
        
        UIView *cutLineBottomView = [UIView new];
        [headerView.contentView addSubview:cutLineBottomView];
        
        cutLineBottomView.backgroundColor = UIColorFromHex(0xd6d5d9);
        
        [cutLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT);
        }];
    }
    
    UILabel *titleLabel = [headerView viewWithTag:labelTag];
    
    if (section == 0) {
        titleLabel.text = KString(@"控制反馈");
    } else if (section == 1) {
        titleLabel.text = KString(@"温度单位");
    } else if (section == 2) {
        titleLabel.text = KString(@"语言设置");
    }
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *baseIdentifierCell = @"BaseCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifierCell];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseIdentifierCell];
        [cell updateTitleFont:UIFontOf1XPix(17) color:UIColorFromRGBA(0, 0, 0, 0.85) paddingLeft:16];
        cell.tintColor = HB_COLOR_BASE_MAIN;
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    WeakObj(self);
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.baseAccessoryType = BaseTableViewCellAccessoryTypeSwitch;
        if (indexPath.row == 0) {
            cell.baseTitleString = KString(@"声音");
            [cell updateBaseSwitchOn:[FeedBackManager sharedManager].isSound switchBlock:^(BOOL on) {
                [FeedBackManager sharedManager].sound = on;
                [selfWeak.baseTableView reloadData];
            }];
        } else if (indexPath.row == 1) {
            cell.baseTitleString = KString(@"振动");
            [cell updateBaseSwitchOn:[FeedBackManager sharedManager].isVibrate switchBlock:^(BOOL on) {
                [FeedBackManager sharedManager].vibrate = on;
                [selfWeak.baseTableView reloadData];
            }];
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.baseTitleString = KString(@"摄氏度");
            if ([TemperatureUnitManager sharedManager].unitType == TemperatureUnitTypeCentigrade) {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeCheck;
            } else {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeNone;
            }
        } else if (indexPath.row == 1) {
            cell.baseTitleString = KString(@"华氏度");
            if ([TemperatureUnitManager sharedManager].unitType == TemperatureUnitTypeFahrenheit) {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeCheck;
            } else {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeNone;
            }
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.baseTitleString = KString(@"简体中文");
            if ([LanguageManager sharedManager].typeLanguage == LanguageTypeChinese) {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeCheck;
            } else {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeNone;
            }
        } else if (indexPath.row == 1) {
            cell.baseTitleString = KString(@"English");
            if ([LanguageManager sharedManager].typeLanguage == LanguageTypeEnglish) {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeCheck;
            } else {
                cell.baseAccessoryType = BaseTableViewCellAccessoryTypeNone;
            }
        }
        
    }
    
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        cell.baseCutLineInsets = UIEdgeInsetsMake(0, 17, 0, 0);
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
