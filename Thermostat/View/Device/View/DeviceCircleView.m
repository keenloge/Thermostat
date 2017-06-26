//
//  DeviceCircleView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceCircleView.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "DeviceListManager.h"
#import "LinKonDevice.h"
#import "NSTimerAdditions.h"
#import "Globals.h"
#import "TemperatureUnitManager.h"


// 外圈 缩进 / 厚度
const CGFloat CircleInfoViewOutLayerInset           = 19.0;
const CGFloat CircleInfoViewOutLayerInset_3_5       = 14.0;
const CGFloat CircleInfoViewOutLayerBorderWidth     = 1.0;

// 中圈 缩进 / 厚度
const CGFloat CircleInfoViewMiddleLayerInset        = 4.0;
const CGFloat CircleInfoViewMiddleLayerBorderWidth  = 3.0;

// 内圈 缩进 / 厚度
const CGFloat CircleInfoViewInLayerInset            = 3.0;
const CGFloat CircleInfoViewInLayerBorderWidth      = 3.0;


// 当前温度, 湿度 大小
const CGFloat CircleInfoViewImageIconSize           = 16.0;
// 当前温度与湿度横向间距(中心间距)
const CGFloat CircleInfoViewImageIconOffsetCenterX  = 55.0;
// 当前温度湿度图标与文字纵向间距
const CGFloat CircleInfoViewImageIconOffsetY        = 4.0;


// 基准线均以 inLayer 为标准, 用纵横个两条线, 将 inLayer 分为九分(井字,九宫格)
// 上基准线, 距离顶部的距离 与 高度 比值
const CGFloat CircleInfoViewBaseLineTopScale        = 228.0 / 744.0;
const CGFloat CircleInfoViewBaseLineTopScale_3_5    = 114.0 / 360.0;
// 下基准线, 距离顶部的距离 与 高度 比值
const CGFloat CircleInfoViewBaseLineBottomScale     = 408.0 / 744.0;
const CGFloat CircleInfoViewBaseLineBottomScale_3_5 = 204.0 / 360.0;

// 定时器Y值偏移
const CGFloat CircleInfoViewTimerOffsetY            = -2.0;
// 定时器X值偏移
const CGFloat CircleInfoViewTimerOffsetX            = -5.0;

// 倒计时图标大小
const CGFloat CircleInfoViewTimerIconSize           = 30.0;

// 一小时包含秒数 60 * 60
const CGFloat CircleInfoViewSecondsPerHour          = 3600.0;
// 一分钟包含秒数
const CGFloat CircleInfoViewSecondsPerMinute        = 60.0;



@interface DeviceCircleView () {

}

@property (nonatomic, strong) UIImageView *roundImageView;
@property (nonatomic, strong) CALayer *outLayer;
@property (nonatomic, strong) CALayer *middleLayer;
@property (nonatomic, strong) CAGradientLayer *inLayer;

@property (nonatomic, strong) UIView *contentIconView;
@property (nonatomic, strong) UIImageView *humidityImageView;
@property (nonatomic, strong) UIImageView *temperatureImageView;
@property (nonatomic, strong) UILabel *humidityLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;


@property (nonatomic, strong) UIView *contentSettingView;
@property (nonatomic, strong) UILabel *settingLabel;
@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UILabel *mainLabel;

@property (nonatomic, strong) UIView *contentTimerView;
@property (nonatomic, strong) UIImageView *timerImageView;
@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, assign) NSInteger timeOffset;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSTimer *roundTimer;

@property (nonatomic, copy) DeviceDelayTimerFinishBlock block;

@end

@implementation DeviceCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
//    [[DeviceListManager sharedManager] editDevice:self.sn key:KDeviceDelay value:@(0)];
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    if ([self.roundTimer isValid]) {
        [self.roundTimer invalidate];
        self.roundTimer = nil;
    }
}

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.roundImageView.opaque = YES;
    self.outLayer.opaque = YES;
    self.middleLayer.opaque = YES;
    self.inLayer.opaque = YES;
    
    self.contentIconView.opaque = YES;
    self.humidityImageView.opaque = YES;
    self.temperatureImageView.opaque = YES;
    self.humidityLabel.opaque = YES;
    self.temperatureLabel.opaque = YES;
    
    self.contentSettingView.opaque = YES;
    self.settingLabel.opaque = YES;
    self.modeLabel.opaque = YES;
    self.unitLabel.opaque = YES;
    
    self.mainLabel.opaque = YES;
    
    self.contentTimerView.opaque = YES;
    self.timerImageView.opaque = YES;
    self.timerLabel.opaque = YES;
    
    WeakObj(self);
    self.roundTimer = [NSTimer hb_scheduledTimerWithTimeInterval:13 repeats:YES block:^(NSTimer *timer) {
        [selfWeak animationRoundImageView];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.roundTimer forMode:NSRunLoopCommonModes];
    [self.roundTimer fire];
}

- (void)updateRoundImage:(UIImage *)image
               colorFrom:(UIColor *)colorFrom
                 colorTo:(UIColor *)colorTo {
    self.roundImageView.hidden = image == nil;
    self.roundImageView.image = image;
    self.inLayer.colors = @[(__bridge id)colorFrom.CGColor, (__bridge id)colorTo.CGColor];
}

- (void)updateHumidityString:(NSString *)text {
    self.humidityLabel.text = text;
}

- (void)updateTemperatureString:(NSString *)text {
    self.temperatureLabel.text = text;
}

- (void)updateStateString:(NSString *)state
                  setting:(NSString *)setting
                     mode:(NSString *)mode
                     unit:(NSString *)unit {
    if (state.length > 0) {
        self.mainLabel.hidden = NO;
        self.contentSettingView.hidden = YES;
        setting = @" ";
        mode = @" ";
        unit = @" ";
    } else {
        self.mainLabel.hidden = YES;
        self.contentSettingView.hidden = NO;
    }
    self.mainLabel.text = state;
    self.settingLabel.text = setting;
    self.modeLabel.text = mode;
    self.unitLabel.text = unit;
}

- (void)updateTimerOffset:(NSInteger)timeOffset image:(UIImage *)image block:(DeviceDelayTimerFinishBlock)block {
    // 不管怎么样, 先取消旧的 Timer
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }

    if (timeOffset <= 0) {
        self.contentTimerView.hidden = YES;
    } else {
        self.contentTimerView.hidden = NO;
        self.timerImageView.image = image;
        self.block = block;
        
        self.timeOffset = timeOffset;
    }
}

- (void)animationRoundImageView {
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 10;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1; // MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.roundImageView.layer addAnimation:animation forKey:nil];
}

#pragma mark - Setter

- (void)setTimeOffset:(NSInteger)timeOffset {
    _timeOffset = timeOffset;
    
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
    __block NSInteger timeOut = _timeOffset;
    WeakObj(self);
    self.countDownTimer = [NSTimer hb_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        if (timeOut > 0) {
            // 倒计时
            int hour = timeOut / CircleInfoViewSecondsPerHour;
            int minute = (timeOut - (hour * CircleInfoViewSecondsPerHour)) / CircleInfoViewSecondsPerMinute;
            int second = (timeOut - (hour * CircleInfoViewSecondsPerHour) - (minute * CircleInfoViewSecondsPerMinute));
            selfWeak.timerLabel.text = [NSString stringWithFormat:@"%02d'%02d\"%02d", hour, minute, second];
            timeOut--;
        } else {
            // 倒计时结束了
            [timer invalidate];
            if (selfWeak.block) {
                selfWeak.block();
            }
//            LinKonDevice *device = (LinKonDevice *)[[DeviceListManager sharedManager] getDevice:blockSN];
//            [[DeviceListManager sharedManager] editDevice:blockSN key:KDeviceRunning value:@(device.switchRunning)];
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    [self.countDownTimer fire];
}

#pragma mark - 懒加载

- (UIImageView *)roundImageView {
    if (!_roundImageView) {
        _roundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_roundImageView];
        _roundImageView.image = [UIImage imageNamed:@"bkg_cycle_hot"];
    }
    return _roundImageView;
}

- (CALayer *)outLayer {
    if (!_outLayer) {
        _outLayer = [CALayer layer];
        CGFloat offset = 0.0;
        if (IPHONE_INCH_3_5) {
            offset = CircleInfoViewOutLayerInset_3_5;
        } else {
            offset = KHorizontalRound(CircleInfoViewOutLayerInset);
        }
        _outLayer.frame = CGRectInset(self.roundImageView.frame, offset, offset);
        [self.layer addSublayer:_outLayer];
        _outLayer.cornerRadius = CGRectGetHeight(_outLayer.frame) / 2.0;
        _outLayer.borderColor = UIColorFromHex(0xa1d9f2).CGColor;
        _outLayer.borderWidth = CircleInfoViewOutLayerBorderWidth;
        _outLayer.backgroundColor = HB_COLOR_BASE_MAIN.CGColor;
    }
    return _outLayer;
}

- (CALayer *)middleLayer {
    if (!_middleLayer) {
        _middleLayer = [CALayer layer];
        CGFloat offset = KHorizontalRound(CircleInfoViewMiddleLayerInset);
        _middleLayer.frame = CGRectInset(self.outLayer.frame, offset, offset);
        [self.layer addSublayer:_middleLayer];
        _middleLayer.cornerRadius = CGRectGetHeight(_middleLayer.frame) / 2.0;
        _middleLayer.borderColor = UIColorFromHex(0xd5eef9).CGColor;
        _middleLayer.borderWidth = CircleInfoViewMiddleLayerBorderWidth;
    }
    return _middleLayer;
}

- (CAGradientLayer *)inLayer {
    if (!_inLayer) {
        _inLayer = [CAGradientLayer layer];
        CGFloat offset = KHorizontalRound(CircleInfoViewInLayerInset);
        _inLayer.frame = CGRectInset(self.middleLayer.frame, offset, offset);
        _inLayer.colors = @[(__bridge id)UIColorFromHex(0xff5c23).CGColor, (__bridge id)UIColorFromHex(0xffd1d1).CGColor];
        _inLayer.startPoint = CGPointMake(0, 0);
        _inLayer.endPoint = CGPointMake(0, 1.0);
        [self.layer addSublayer:_inLayer];
        _inLayer.cornerRadius = CGRectGetHeight(_inLayer.frame) / 2.0;
        _inLayer.borderColor = UIColorFromRGBA(0, 0, 0, 0.2).CGColor;
        _inLayer.borderWidth = CircleInfoViewInLayerBorderWidth;
        _inLayer.backgroundColor = HB_COLOR_BASE_RED.CGColor;
    }
    return _inLayer;
}

#pragma mark - 当前温度 与 湿度

- (UIView *)contentIconView {
    if (!_contentIconView) {
        _contentIconView = [UIView new];
        [self addSubview:_contentIconView];
        
        WeakObj(self);
        [_contentIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak);
        }];
    }
    return _contentIconView;
}

- (UIImageView *)humidityImageView {
    if (!_humidityImageView) {
        _humidityImageView = [UIImageView new];
        [self.contentIconView addSubview:_humidityImageView];
        _humidityImageView.image = [UIImage imageNamed:@"icon_humidity"];
//        _humidityImageView.alpha = 0.8;

        WeakObj(self);
        [_humidityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(selfWeak.contentIconView);
            CGFloat size = KHorizontalRound(CircleInfoViewImageIconSize);
            make.size.mas_equalTo(CGSizeMake(size, size));
        }];
    }
    return _humidityImageView;
}

- (UIImageView *)temperatureImageView {
    if (!_temperatureImageView) {
        _temperatureImageView = [UIImageView new];
        [self.contentIconView addSubview:_temperatureImageView];
        _temperatureImageView.image = [UIImage imageNamed:@"icon_temperature"];
//        _temperatureImageView.alpha = 0.8;

        WeakObj(self);
        [_temperatureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(selfWeak.contentIconView);
            make.centerX.equalTo(selfWeak.humidityImageView).offset(KHorizontalRound(CircleInfoViewImageIconOffsetCenterX));
            make.width.equalTo(selfWeak.humidityImageView);
        }];
    }
    return _temperatureImageView;
}

- (UILabel *)humidityLabel {
    if (!_humidityLabel) {
        _humidityLabel = [UILabel new];
        [self addSubview:_humidityLabel];
        if (IPHONE_INCH_3_5) {
            _humidityLabel.font = UIFontOf2XPix(20);
        } else {
            _humidityLabel.font = UIFontOf3XPix(KHorizontalRound(39));
        }
        _humidityLabel.textColor = HB_COLOR_BASE_WHITE;
        
        WeakObj(self);
        [_humidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.contentIconView.mas_bottom).offset(KHorizontalRound(CircleInfoViewImageIconOffsetY));
            make.centerX.equalTo(selfWeak.humidityImageView);
            CGFloat scale = 0.0;
            if (IPHONE_INCH_3_5) {
                scale = CircleInfoViewBaseLineTopScale_3_5;
            } else {
                scale = CircleInfoViewBaseLineTopScale;
            }
            CGFloat offsetCenterY = (selfWeak.inLayer.frame.size.height * scale) + CGRectGetMinY(selfWeak.inLayer.frame);
            make.centerY.equalTo(selfWeak.mas_top).offset(offsetCenterY);
        }];
    }
    return _humidityLabel;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [UILabel new];
        [self addSubview:_temperatureLabel];
        _temperatureLabel.font = self.humidityLabel.font;
        _temperatureLabel.textColor = HB_COLOR_BASE_WHITE;

        WeakObj(self);
        [_temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.humidityLabel);
            make.centerX.equalTo(selfWeak.temperatureImageView);
        }];
    }
    return _temperatureLabel;
}

#pragma mark - 设置温度 单位 与 模式

- (UIView *)contentSettingView {
    if (!_contentSettingView) {
        _contentSettingView = [UIView new];
        [self addSubview:_contentSettingView];
        
        WeakObj(self);
        [_contentSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak);
            CGFloat scale = 0.0;
            if (IPHONE_INCH_3_5) {
                scale = CircleInfoViewBaseLineBottomScale_3_5;
            } else {
                scale = CircleInfoViewBaseLineBottomScale;
            }
            CGFloat offsetCenterY = (selfWeak.inLayer.frame.size.height * scale) + CGRectGetMinY(selfWeak.inLayer.frame);
            make.centerY.equalTo(selfWeak.mas_top).offset(offsetCenterY);
        }];
    }
    return _contentSettingView;
}

- (UILabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [UILabel new];
        [self.contentSettingView addSubview:_settingLabel];
        
        if (IPHONE_INCH_3_5) {
            _settingLabel.font = UIFontOf2XPix(124);
        } else {
            _settingLabel.font = UIFontOf3XPix(KHorizontalRound(240));
        }
        _settingLabel.textColor = HB_COLOR_BASE_WHITE;
        
        WeakObj(self);
        [_settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(selfWeak.contentSettingView);
        }];
    }
    return _settingLabel;
}

- (UILabel *)modeLabel {
    if (!_modeLabel) {
        _modeLabel = [UILabel new];
        [self.contentSettingView addSubview:_modeLabel];
        
        if (IPHONE_INCH_3_5) {
            _modeLabel.font = UIFontOf2XPix(24);
        } else {
            _modeLabel.font = UIFontOf3XPix(KHorizontalRound(48));
        }
        _modeLabel.textColor = HB_COLOR_BASE_WHITE;
        
        WeakObj(self);
        [_modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.unitLabel);
            make.bottom.equalTo(selfWeak.unitLabel.mas_top);
        }];
    }
    return _modeLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [UILabel new];
        [self.contentSettingView addSubview:_unitLabel];
        
        if (IPHONE_INCH_3_5) {
            _unitLabel.font = UIFontOf2XPix(62);
        } else {
            _unitLabel.font = UIFontOf3XPix(KHorizontalRound(120));
        }
        _unitLabel.textColor = HB_COLOR_BASE_WHITE;
        _unitLabel.text = [TemperatureUnitManager sharedManager].unitString;
        
        WeakObj(self);
        [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(selfWeak.settingLabel.mas_right);
            make.baseline.equalTo(selfWeak.settingLabel);
            make.right.equalTo(selfWeak.contentSettingView);
        }];
    }
    return _unitLabel;
}

- (UILabel *)mainLabel {
    if (!_mainLabel) {
        _mainLabel = [UILabel new];
        [self addSubview:_mainLabel];
        
        _mainLabel.textColor = HB_COLOR_BASE_WHITE;
        _mainLabel.font = self.settingLabel.font;
        _mainLabel.text = KString(@"换气");
        _mainLabel.adjustsFontSizeToFitWidth = YES;
        
        WeakObj(self);
        [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(selfWeak.contentSettingView);
            make.width.mas_lessThanOrEqualTo(CGRectGetWidth(selfWeak.inLayer.frame) - 20);
        }];
    }
    return _mainLabel;
}

#pragma mark - 定时器

- (UIView *)contentTimerView {
    if (!_contentTimerView) {
        _contentTimerView = [UIView new];
        [self addSubview:_contentTimerView];
        
        _contentTimerView.alpha = 0.6;
        
        WeakObj(self);
        [_contentTimerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.contentSettingView.mas_bottom).offset(KHorizontalRound(CircleInfoViewTimerOffsetY));
            make.centerX.equalTo(selfWeak);
        }];
    }
    return _contentTimerView;
}

- (UIImageView *)timerImageView {
    if (!_timerImageView) {
        _timerImageView = [UIImageView new];
        [self.contentTimerView addSubview:_timerImageView];
        
        _timerImageView.image = [UIImage imageNamed:@"icon_timer_off"];
        _timerImageView.tintColor = HB_COLOR_BASE_BLACK;
        
        WeakObj(self);
        [_timerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(selfWeak.contentTimerView);
            CGFloat size = KHorizontalRound(CircleInfoViewTimerIconSize);
            make.size.mas_equalTo(CGSizeMake(size, size));
        }];
    }
    return _timerImageView;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [UILabel new];
        [self.contentTimerView addSubview:_timerLabel];
        
        _timerLabel.font = UIFontOf3XPix(KHorizontalRound(40));
        _timerLabel.textColor = HB_COLOR_BASE_BLACK;

        WeakObj(self);
        [_timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(selfWeak.contentTimerView);
            make.left.equalTo(selfWeak.timerImageView.mas_right).offset(KHorizontalRound(CircleInfoViewTimerOffsetX));
        }];
    }
    return _timerLabel;
}

@end
