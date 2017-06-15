//
//  DeviceBlankView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceBlankView.h"

const CGFloat KDeviceBlankButtonSize = 38.0;
const CGFloat KDeviceBlankLabelOffsetY = 6.0;

@interface DeviceBlankView ()

@property (nonatomic, strong) UIButton *blankButton;
@property (nonatomic, strong) UILabel *blankLabel;

@end

@implementation DeviceBlankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.blankButton.opaque = YES;
}

- (void)baseRestLanguage {
    self.blankLabel.text = KString(@"搜索设备");
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

#pragma mark - 懒加载

- (UIButton *)blankButton {
    if (!_blankButton) {
        _blankButton = [UIButton new];
        [self addSubview:_blankButton];
        [_blankButton setImage:[UIImage imageNamed:@"btn_device_search"] forState:UIControlStateNormal];
        [_blankButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        WeakObj(self);
        [_blankButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(selfWeak);
            make.size.mas_equalTo(CGSizeMake(KDeviceBlankButtonSize, KDeviceBlankButtonSize));
        }];
    }
    return _blankButton;
}

- (UILabel *)blankLabel {
    if (!_blankLabel) {
        _blankLabel = [UILabel new];
        [self addSubview:_blankLabel];
        
        _blankLabel.textColor = HB_COLOR_BASE_DEEP;
        _blankLabel.font = UIFontOf3XPix(48);
        
        WeakObj(self);
        [_blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak.blankButton);
            make.top.equalTo(selfWeak.blankButton.mas_bottom).offset(KDeviceBlankLabelOffsetY);
        }];
    }
    return _blankLabel;
}

@end
