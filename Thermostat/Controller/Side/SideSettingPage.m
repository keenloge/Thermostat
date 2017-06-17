//
//  SideSettingPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideSettingPage.h"
#import "SideSettingSwitchCell.h"
#import "SideSettingCheckCell.h"

@interface SideSettingPage ()

@end

@implementation SideSettingPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"系统设置");
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
            make.height.mas_equalTo(1);
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
    if (indexPath.section == 0) {
        static NSString *identifierSwitchCell = @"SwitchCell";
        SideSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierSwitchCell];
        if (cell == nil) {
            cell = [[SideSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSwitchCell];
        }
        
        if (indexPath.row == 0) {
            cell.titleString = KString(@"声音");
        } else if (indexPath.row == 1) {
            cell.titleString = KString(@"振动");
        }
        
        return cell;
    } else {
        static NSString *identifierCheckCell = @"CheckCell";
        SideSettingCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCheckCell];
        if (cell == nil) {
            cell = [[SideSettingCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCheckCell];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.titleString = KString(@"摄氏度");
            } else if (indexPath.row == 1) {
                cell.titleString = KString(@"华氏度");
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.titleString = KString(@"简体中文");
            } else if (indexPath.row == 1) {
                cell.titleString = KString(@"English");
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SideSettingCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.lineOffset = 0;
    } else {
        cell.lineOffset = 17;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
