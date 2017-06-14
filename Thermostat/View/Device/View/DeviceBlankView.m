//
//  DeviceBlankView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceBlankView.h"
#import "DeviceBlankButton.h"
#import "UIViewAdditions.h"
#import "ColorConfig.h"
#import "Declare.h"

const CGFloat KDeviceBlankButtonWidth = 100.0;
const CGFloat KDeviceBlankButtonHeight = 63;

@interface DeviceBlankView ()

@property (nonatomic, strong) DeviceBlankButton *blankButton;

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
    [self.blankButton setTitle:KString(@"搜索设备") forState:UIControlStateNormal];
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

#pragma mark - 懒加载

- (DeviceBlankButton *)blankButton {
    if (!_blankButton) {
        _blankButton = [[DeviceBlankButton alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           KDeviceBlankButtonWidth,
                                                                           KDeviceBlankButtonHeight)];
        _blankButton.centerX = self.centerX;
        _blankButton.centerY = self.centerY - self.top;
        _blankButton.titleLabel.font = UIFontOf3XPix(48);
        [_blankButton setTitleColor:HB_COLOR_BASE_DARK forState:UIControlStateNormal];
        [_blankButton setImage:[UIImage imageNamed:@"btn_device_search"] forState:UIControlStateNormal];
        [_blankButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_blankButton];
    }
    return _blankButton;
}

@end
