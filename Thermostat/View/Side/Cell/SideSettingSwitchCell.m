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

- (UISwitch *)settingSwitch {
    if (!_settingSwitch) {
        _settingSwitch = [UISwitch new];
        [self.contentView addSubview:_settingSwitch];
        
        
        WeakObj(self);
        [_settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(selfWeak.contentView).offset(-12);
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _settingSwitch;
}

@end
