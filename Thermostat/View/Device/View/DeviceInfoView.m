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
#import "DeviceListManager.h"
#import "LinKonDevice.h"
#import "Declare.h"

// 设备信息圈大小
const CGFloat KDeviceCircleInfoViewSize     = 300.0;
// 设备信息圈在3.5寸设备上的大小
const CGFloat KDeviceCircleInfoViewSize_3_5 = 212.0;
// 设备信息圈Y值偏移
const CGFloat KDeviceCircleInfoViewOffsetY  = 8.0;

// 设备 儿童锁, 情景, 风速 图标X偏移
const CGFloat KDeviceInfoIconOffsetX            = 40.0;
// 底部间距
const CGFloat KDeviceInfoIconPaddingBottom      = 17.0;
// 3.5寸设备上的底部间距
const CGFloat KDeviceInfoIconPaddingBottom_3_5  = 10.0;
// 图标大小
const CGFloat KDeviceInfoIconSize               = 24;

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

- (void)updateLockImageAlpha:(CGFloat)alpha {
    self.lockImageView.alpha = alpha;
}

- (void)updateSceneImage:(UIImage *)image alpha:(CGFloat)alpha {
    self.sceneImageView.image = image;
    self.sceneImageView.alpha = alpha;
}

- (void)updateWindImage:(UIImage *)image alpha:(CGFloat)alpha {
    self.windImageView.image = image;
    self.windImageView.alpha = alpha;
}

- (void)updateRoundImage:(UIImage *)image
               colorFrom:(UIColor *)colorFrom
                 colorTo:(UIColor *)colorTo {
    [self.circleInfoView updateRoundImage:image
                                colorFrom:colorFrom
                                  colorTo:colorTo];
}

- (void)updateHumidityString:(NSString *)text {
    [self.circleInfoView updateHumidityString:text];
}

- (void)updateTemperatureString:(NSString *)text {
    [self.circleInfoView updateTemperatureString:text];
}

- (void)updateStateString:(NSString *)state
                  setting:(NSString *)setting
                     mode:(NSString *)mode
                     unit:(NSString *)unit {
    [self.circleInfoView updateStateString:state
                                   setting:setting
                                      mode:mode
                                      unit:unit];
}

- (void)updateTimerOffset:(NSInteger)timeOffset
                    image:(UIImage *)image
                    block:(DeviceDelayTimerFinishBlock)block {
    [self.circleInfoView updateTimerOffset:timeOffset
                                     image:image
                                     block:block];
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
