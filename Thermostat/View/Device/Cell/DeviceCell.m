//
//  DeviceCell.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceCell.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "Globals.h"
#import "Device.h"
#import "DeviceManager.h"

#define KInfoButtonColor   UIColorFromHex(0xb3b3b3)

const CGFloat KInfoButtonSize = 28.0;  //  = 84.0 / 3.0

@interface DeviceInfoButton : UIButton

@end

@implementation DeviceInfoButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"i" forState:UIControlStateNormal];
        self.titleLabel.font = UIFontOf3XPix(55);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:KInfoButtonColor forState:UIControlStateNormal];
        self.titleLabel.layer.borderColor = KInfoButtonColor.CGColor;
        self.titleLabel.layer.borderWidth = 1.0;
        self.titleLabel.layer.cornerRadius = KInfoButtonSize / 2.0;
    }
    return self;
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake((CGRectGetWidth(contentRect) - KInfoButtonSize) / 2.0,
                      (CGRectGetHeight(contentRect) - KInfoButtonSize) / 2.0,
                      KInfoButtonSize,
                      KInfoButtonSize);
}

@end

@interface DeviceCell () {

}

@property (nonatomic, strong) UIView             *circleView;
@property (nonatomic, strong) UIImageView        *deviceImageView;
@property (nonatomic, strong) UILabel            *nicknameLabel;
@property (nonatomic, strong) UILabel            *stateDetailLabel;
@property (nonatomic, strong) DeviceInfoButton   *infoButton;


@end

@implementation DeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView             *circleView = self.circleView;
        UIImageView        *deviceImageView = self.deviceImageView;
        UILabel            *nicknameLabel = self.nicknameLabel;
        UILabel            *stateDetailLabel = self.stateDetailLabel;
        DeviceInfoButton   *infoButton = self.infoButton;
        
        UIView *superContentView = self.contentView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(circleView, deviceImageView, nicknameLabel, stateDetailLabel, infoButton, superContentView);
        
        NSDictionary *metricsDictionary = @{
                                            @"paddingLeft" : @(18),
                                            @"paddingTop" : @(20),
                                            @"circleSize" : @(52),
                                            @"offsetX" : @(13),
                                            @"offsetY" : @(11),
                                            @"infoWidth" : @(64),
                                            @"nameHeight" : @(17),
                                            @"stateHeight" : @(14),
                                            @"iconSize" : @(36),
                                            };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingLeft-[circleView(circleSize)]-offsetX-[nicknameLabel]-(>=offsetX)-[infoButton(infoWidth)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[circleView(circleSize)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[infoButton]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[circleView]-(<=1)-[superContentView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[nicknameLabel(nameHeight)]-offsetY-[stateDetailLabel(stateHeight)]" options:NSLayoutFormatAlignAllLeft metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[deviceImageView(iconSize)]-(<=1)-[circleView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[deviceImageView(iconSize)]-(<=1)-[circleView]" options:NSLayoutFormatAlignAllCenterX metrics:metricsDictionary views:viewsDictionary]];
        
        [self.contentView layoutIfNeeded];
        
        self.circleView.layer.cornerRadius = self.circleView.frame.size.height / 2.0;
    }
    return self;
}

#pragma mark - 界面刷新

- (void)changeStateWithDevice:(Device *)device {
    self.stateDetailLabel.text = device.stateString;
    if (device.connection == ConnectionStateOFF) {
        self.stateDetailLabel.textColor = HB_COLOR_BASE_RED;
    } else if (device.running == RunningStateOFF) {
        self.stateDetailLabel.textColor = HB_COLOR_BASE_GREEN;
    } else {
        self.stateDetailLabel.textColor = HB_COLOR_BASE_GRAY;
    }
}

#pragma mark - 点击事件

- (void)buttonPressed:(id)sender {
    if (self.infoBlock) {
        self.infoBlock();
    }
}

#pragma mark - Setter

- (void)setSn:(NSString *)sn {
    _sn = sn;
    
    WeakObj(self);
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceNickname block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        selfWeak.nicknameLabel.text = device.nickname;
    }];
    
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceConnection block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak changeStateWithDevice:device];
    }];
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceRunning block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak changeStateWithDevice:device];
    }];
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceSetting block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak changeStateWithDevice:device];
    }];
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceMode block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak changeStateWithDevice:device];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.circleView.backgroundColor = HB_COLOR_BASE_MAIN;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.circleView.backgroundColor = HB_COLOR_BASE_MAIN;
}

#pragma mark - 懒加载

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [Globals addedSubViewClass:[UIView class] toView:self.contentView];
        _circleView.backgroundColor = HB_COLOR_BASE_MAIN;
    }
    return _circleView;
}

- (UIImageView *)deviceImageView {
    if (!_deviceImageView) {
        _deviceImageView = [Globals addedSubViewClass:[UIImageView class] toView:self.circleView];
        _deviceImageView.image = [UIImage imageNamed:@"cell_device"];
    }
    return _deviceImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _nicknameLabel.font = UIFontOf3XPix(51);
        _nicknameLabel.textColor = HB_COLOR_BASE_DARK;
    }
    return _nicknameLabel;
}

- (UILabel *)stateDetailLabel {
    if (!_stateDetailLabel) {
        _stateDetailLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _stateDetailLabel.font = UIFontOf3XPix(42);
        _stateDetailLabel.textColor = HB_COLOR_BASE_GRAY;
    }
    return _stateDetailLabel;
}

- (DeviceInfoButton *)infoButton {
    if (!_infoButton) {
        _infoButton = [Globals addedSubViewClass:[DeviceInfoButton class] toView:self.contentView];
        [_infoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoButton;
}

@end
