//
//  SideSettingSwitchCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideSettingSwitchCell.h"

@interface SideSettingSwitchCell ()

@property (nonatomic, strong) UISwitch *settingSwitch;

@end

@implementation SideSettingSwitchCell

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    
    self.settingSwitch.opaque = YES;
}

#pragma mark - 点击事件

- (void)switchValueChanged:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

#pragma mark - Setter

- (void)setOpen:(BOOL)open {
    _open = open;
    
    [self.settingSwitch setOn:_open];
}


#pragma mark - 懒加载

- (UISwitch *)settingSwitch {
    if (!_settingSwitch) {
        _settingSwitch = [UISwitch new];
        [self.contentView addSubview:_settingSwitch];
        
        [self.settingSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        WeakObj(self);
        [_settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(selfWeak.contentView).offset(-12);
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _settingSwitch;
}

@end
