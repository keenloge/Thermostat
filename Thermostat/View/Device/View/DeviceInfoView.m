//
//  DeviceInfoView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceInfoView.h"
#import "ColorConfig.h"
#import "DeviceCircleView.h"
#import "DeviceManager.h"
#import "Device.h"
#import "Declare.h"

// 设备信息圈大小
const CGFloat KDeviceCircleInfoViewSize     = 300.0;
// 设备信息圈在3.5寸设备上的大小
const CGFloat KDeviceCircleInfoViewSize_3_5 = 212.0;
// 设备信息圈Y值偏移
const CGFloat KDeviceCircleInfoViewOffsetY  = 8.0;

// 设备 儿童锁, 情景, 风速 图标X偏移
const CGFloat KDeviceInfoIconOffsetX            = 35.0;
// 底部间距
const CGFloat KDeviceInfoIconPaddingBottom      = 12.0;
// 3.5寸设备上的底部间距
const CGFloat KDeviceInfoIconPaddingBottom_3_5  = 6.0;
// 图标大小
const CGFloat KDeviceInfoIconSize               = 30.0;

@interface DeviceInfoView () {
    CGFloat imageViewOffsetX;
    CGFloat imageViewBottomPadding;
    CGFloat imageViewSize;
}

@property (nonatomic, strong) DeviceCircleView *circleInfoView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *sceneImageView;
@property (nonatomic, strong) UIImageView *windImageView;

@end

@implementation DeviceInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.backgroundColor = HB_COLOR_BASE_MAIN;
    
    imageViewOffsetX = KHorizontalRound(KDeviceInfoIconOffsetX);
    if (IPHONE_INCH_3_5) {
        imageViewBottomPadding = KDeviceInfoIconPaddingBottom_3_5;
    } else {
        imageViewBottomPadding = KHorizontalRound(KDeviceInfoIconPaddingBottom);
    }
    imageViewSize = KHorizontalRound(KDeviceInfoIconSize);
    
    self.circleInfoView.opaque = YES;
    self.lockImageView.opaque = YES;
    self.sceneImageView.opaque = YES;
    self.windImageView.opaque = YES;
}

#pragma mark - Setter

- (void)setSn:(NSString *)sn {
    _sn = sn;
    
    self.circleInfoView.sn = sn;
    
    WeakObj(self);
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceLock block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        selfWeak.lockImageView.alpha = device.lock ? 0.5 : 1.0;
    }];
    
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceScene block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        switch (device.scene) {
            case LinKonSceneConstant:
                selfWeak.sceneImageView.image = [UIImage imageNamed:@"icon_scene_constant"];
                break;
            case LinKonSceneGreen:
                selfWeak.sceneImageView.image = [UIImage imageNamed:@"icon_scene_green"];
                break;
            case LinKonSceneLeave:
                selfWeak.sceneImageView.image = [UIImage imageNamed:@"icon_scene_leave"];
                break;
            default:
                break;
        }
    }];
    
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceWind block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        switch (device.wind) {
            case LinKonWindLow:
                selfWeak.windImageView.image = [UIImage imageNamed:@"icon_wind_low"];
                break;
            case LinKonWindMedium:
                selfWeak.windImageView.image = [UIImage imageNamed:@"icon_wind_medium"];
                break;
            case LinKonWindHigh:
                selfWeak.windImageView.image = [UIImage imageNamed:@"icon_wind_high"];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 懒加载

- (DeviceCircleView *)circleInfoView {
    if (!_circleInfoView) {
        CGFloat circleSize = 0.0;
        CGFloat offsetY = 0.0;
        if (IPHONE_INCH_3_5) {
            circleSize = KDeviceCircleInfoViewSize_3_5 + KHorizontalRound(KDeviceCircleInfoViewOffsetY);
        } else {
            circleSize = KHorizontalRound(KDeviceCircleInfoViewSize);
            offsetY = KHorizontalRound(KDeviceCircleInfoViewOffsetY);
        }
        CGFloat offsetX = (CGRectGetWidth(self.frame) - circleSize) / 2.0;
        
        _circleInfoView = [[DeviceCircleView alloc] initWithFrame:CGRectMake(offsetX, offsetY, circleSize, circleSize)];
        [self addSubview:_circleInfoView];
    }
    return _circleInfoView;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewOffsetX,
                                                                       CGRectGetHeight(self.frame) - imageViewBottomPadding - imageViewSize,
                                                                       imageViewSize,
                                                                       imageViewSize)];
        [self addSubview:_lockImageView];
        
        [_lockImageView setImage:[UIImage imageNamed:@"icon_child_lock"]];
    }
    return _lockImageView;
}

- (UIImageView *)sceneImageView {
    if (!_sceneImageView) {
        _sceneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf((CGRectGetWidth(self.frame) - imageViewSize) / 2.0),
                                                                        CGRectGetHeight(self.frame) - imageViewBottomPadding - imageViewSize,
                                                                        imageViewSize,
                                                                        imageViewSize)];
        [self addSubview:_sceneImageView];
        
        [_sceneImageView setImage:[UIImage imageNamed:@"icon_scene_green"]];
    }
    return _sceneImageView;
}

- (UIImageView *)windImageView {
    if (!_windImageView) {
        _windImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - imageViewOffsetX - imageViewSize,
                                                                       CGRectGetHeight(self.frame) - imageViewBottomPadding - imageViewSize,
                                                                       imageViewSize,
                                                                       imageViewSize)];
        [self addSubview:_windImageView];
        
        [_windImageView setImage:[UIImage imageNamed:@"icon_wind_high"]];
    }
    return _windImageView;
}

@end
