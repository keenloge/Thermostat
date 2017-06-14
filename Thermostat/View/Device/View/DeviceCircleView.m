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
#import "DeviceManager.h"
#import "Device.h"
#import "NSTimerAdditions.h"
#import "Globals.h"

// 当前温度, 湿度, 倒计时图标 大小
const CGFloat CircleInfoViewImageIconSize = 30.0;

// 基准线均以 inLayer 为标准, 用纵横个两条线, 将 inLayer 分为九分(井字,九宫格)
// 上基准线, 距离顶部的距离 与 高度 比值
const CGFloat CircleInfoViewBaseLineTopScale        = 0.3;
// 下基准线, 距离底部的距离 与 高度 比值
const CGFloat CircleInfoViewBaseLineBottomScale     = 0.3;
// 左基准线, 距离左边的距离 与 宽度 比值
const CGFloat CircleInfoViewBaseLineLeftScale       = 0.35;
// 右基准线, 距离右边的距离 与 宽度 比值
const CGFloat CircleInfoViewBaseLineRightScale      = 0.35;

// 当前温度, 湿度 文本 高度 与 inLayer 高度 比值
const CGFloat CircleInfoViewCurrentLabelHeightScale = 0.08;

// 换气/待机 主文本 宽/高 与 inLayer 宽/高 比值
const CGFloat CircleInfoViewMainLabelWidthScale     = 0.8;
const CGFloat CircleInfoViewMainLabelHeightScale    = 0.3;

// 设定温度 文本 宽/高 与 inLayer 宽/高 比值
const CGFloat CircleInfoViewSettingLabelWidthScale  = 0.5;
const CGFloat CircleInfoViewSettingLabelHeightScale = 0.3;

// 模式 文本 宽/高 与 inLayer 宽/高 比值
const CGFloat CircleInfoViewModeLabelWidthScale     = 0.2;
const CGFloat CircleInfoViewModeLabelHeightScale    = 0.08;

// 单位 文本 宽/高 与 inLayer 宽/高 比值
const CGFloat CircleInfoViewUnitLabelWidthScale     = 0.2;
const CGFloat CircleInfoViewUnitLabelHeightScale    = 0.14;

// 倒计时文本 高度 与 计时图标 高度 比值
const CGFloat CircleInfoViewTimerLabelHeightScale   = 0.6;

// 一小时包含秒数 60 * 60
const CGFloat CircleInfoViewSecondsPerHour          = 3600.0;
// 一分钟包含秒数
const CGFloat CircleInfoViewSecondsPerMinute        = 60.0;


// 外围转圈图片 缩进
const CGFloat CircleInfoViewRoundImageViewInset     = -3.0;

// 外圈 缩进 / 厚度
const CGFloat CircleInfoViewOutLayerInset           = 17.0;
const CGFloat CircleInfoViewOutLayerBorderWidth     = 1.0;

// 中圈 缩进 / 厚度
const CGFloat CircleInfoViewMiddleLayerInset        = 3.0;
const CGFloat CircleInfoViewMiddleLayerBorderWidth  = 3.0;

// 内圈 缩进 / 厚度
const CGFloat CircleInfoViewInLayerInset            = 3.0;
const CGFloat CircleInfoViewInLayerBorderWidth      = 3.0;




@interface DeviceCircleView () {
    // 基准线
    CGFloat baseLineTop;    // 上基准线
    CGFloat baseLineBottom; // 下基准线
    CGFloat baseLineLeft;   // 左基准线
    CGFloat baseLineRight;  // 右基准线
    
    // 延时开关
    UIFont *timerLabelFont;
    CGSize timerLabelSize;
    
    // 温度,湿度
    UIFont *currentLabelFont;
    CGSize currentLabelSize;
    
    // 换气,待机
    CGSize mainLabelSize;
    UIFont *mainLabelFont;
    
    // 设置温度
    CGSize settingLabelSize;
    UIFont *settingLabelFont;
    
    // 模式
    CGSize modeLabelSize;
    UIFont *modeLabelFont;
    
    // 单位
    CGSize unitLabelSize;
    UIFont *unitLabelFont;
    
    // 修正高度
    CGFloat fixHeight;
}

@property (nonatomic, strong) UIImageView *roundImageView;
@property (nonatomic, strong) CALayer *outLayer;
@property (nonatomic, strong) CALayer *middleLayer;
@property (nonatomic, strong) CAGradientLayer *inLayer;

@property (nonatomic, strong) UIImageView *humidityImageView;
@property (nonatomic, strong) UIImageView *temperatureImageView;
@property (nonatomic, strong) UILabel *humidityLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *settingLabel;
@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UIImageView *timerImageView;
@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, assign) int   timeOffset;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSTimer *roundTimer;

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
    [[DeviceManager sharedManager] editDevice:self.sn key:KDeviceDelay value:@(0)];
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
    self.backgroundColor = HB_COLOR_BASE_MAIN;
    
    // 外围圈
    self.roundImageView.opaque = YES;
    self.outLayer.opaque = YES;
    self.middleLayer.opaque = YES;
    self.inLayer.opaque = YES;
    
    // 基准线 参考了 inLayer 所以一定要放在 inLayer 之后计算.
    baseLineTop = floorf(CGRectGetMinY(self.inLayer.frame) + CGRectGetHeight(self.inLayer.frame) * CircleInfoViewBaseLineTopScale);
    baseLineBottom = floorf(CGRectGetMaxY(self.inLayer.frame) - CGRectGetHeight(self.inLayer.frame) * CircleInfoViewBaseLineBottomScale);
    baseLineLeft = floorf(CGRectGetMinX(self.inLayer.frame) + CGRectGetWidth(self.inLayer.frame) * CircleInfoViewBaseLineLeftScale);
    baseLineRight = floorf(CGRectGetMaxX(self.inLayer.frame) - CGRectGetWidth(self.inLayer.frame) * CircleInfoViewBaseLineRightScale);
    
    
    // 当前 温度, 湿度, 分别以左右基准线居中显示, 紧贴, 因此最大宽度则为 左右基准线之间距离
    currentLabelSize = CGSizeMake(floorf(CGRectGetWidth(self.inLayer.frame) * (1 - CircleInfoViewBaseLineLeftScale - CircleInfoViewBaseLineRightScale)),
                                  floorf(CGRectGetHeight(self.inLayer.frame) * CircleInfoViewCurrentLabelHeightScale));
    currentLabelFont = UIFontOf1XPix(currentLabelSize.height);
    self.humidityImageView.opaque = YES;
    self.temperatureImageView.opaque = YES;
    self.humidityLabel.opaque = YES;
    self.temperatureLabel.opaque = YES;
    
    // 换气, 待机
    mainLabelSize = CGSizeMake(floorf(CGRectGetWidth(self.inLayer.frame) * CircleInfoViewMainLabelWidthScale),
                              floorf(CGRectGetHeight(self.inLayer.frame) * CircleInfoViewMainLabelHeightScale));
    mainLabelFont = UIFontOf1XPix(mainLabelSize.height);
    
    
    // 设置温度, 单位, 模式
    settingLabelSize = CGSizeMake(floorf(CGRectGetWidth(self.inLayer.frame) * CircleInfoViewSettingLabelWidthScale),
                                  floorf(CGRectGetHeight(self.inLayer.frame) * CircleInfoViewSettingLabelHeightScale));
    unitLabelSize = CGSizeMake(floorf(CGRectGetWidth(self.inLayer.frame) * CircleInfoViewUnitLabelWidthScale),
                               floorf(CGRectGetHeight(self.inLayer.frame) * CircleInfoViewUnitLabelHeightScale));
    modeLabelSize = CGSizeMake(floorf(CGRectGetWidth(self.inLayer.frame) * CircleInfoViewModeLabelWidthScale),
                               floorf(CGRectGetHeight(self.inLayer.frame) * CircleInfoViewModeLabelHeightScale));
    settingLabelFont = UIFontOf1XPix(settingLabelSize.height);
    unitLabelFont = UIFontOf1XPix(unitLabelSize.height);
    modeLabelFont = UIFontOf1XPix(modeLabelSize.height);
    
    // 修正因字号差距形成的高度差
    fixHeight = ceilf((settingLabelSize.height - settingLabelFont.capHeight) / 2.0);
    modeLabelSize.height = modeLabelFont.capHeight;
    unitLabelSize.height = unitLabelFont.capHeight;
    
    self.settingLabel.opaque = YES;
    self.unitLabel.opaque = YES;
    self.modeLabel.opaque = YES;
    
    
    // 延时开关
    NSString *timerString = @"000\"00'00";
    timerLabelFont = UIFontOf1XPix(CircleInfoViewImageIconSize * CircleInfoViewTimerLabelHeightScale);
    timerLabelSize = [timerString sizeWithAttributes:@{NSFontAttributeName : timerLabelFont}];
    self.timerImageView.opaque = YES;
    self.timerLabel.opaque = YES;
}

- (void)updateInfoViewWithDevice:(Device *)device {
    self.roundImageView.hidden = NO;
    
    if (device.running == RunningStateOFF || device.mode == LinKonModeAir) {
        // 待机 或者 换气
        self.mainLabel.hidden = NO;
        self.settingLabel.hidden = YES;
        self.modeLabel.hidden = YES;
        self.unitLabel.hidden = YES;
        
        if (device.running == RunningStateOFF) {
            self.mainLabel.text = [Globals runningString:device.running];
            self.inLayer.colors = @[(__bridge id)UIColorFromHex(0xa6ff94).CGColor, (__bridge id)UIColorFromHex(0x38c1ff).CGColor];
            self.roundImageView.hidden = YES;
        } else {
            self.mainLabel.text = [Globals modeString:device.mode];
            self.inLayer.colors = @[(__bridge id)UIColorFromHex(0xa6cff9).CGColor, (__bridge id)UIColorFromHex(0x3498ff).CGColor];
            self.roundImageView.image = [UIImage imageNamed:@"bkg_cycle_air"];
        }
    } else {
        self.mainLabel.hidden = YES;
        self.settingLabel.hidden = NO;
        self.modeLabel.hidden = NO;
        self.unitLabel.hidden = NO;

        self.settingLabel.text = [NSString stringWithFormat:@"%.1f", device.setting];
        self.modeLabel.text = [Globals modeString:device.mode];
        switch (device.mode) {
            case LinKonModeHot:
                self.inLayer.colors = @[(__bridge id)UIColorFromHex(0xff5c23).CGColor, (__bridge id)UIColorFromHex(0xffd1d1).CGColor];
                self.roundImageView.image = [UIImage imageNamed:@"bkg_cycle_hot"];
                break;
            case LinKonModeCool:
                self.inLayer.colors = @[(__bridge id)UIColorFromHex(0x3243d2).CGColor, (__bridge id)UIColorFromHex(0x54bdf1).CGColor];
                self.roundImageView.image = [UIImage imageNamed:@"bkg_cycle_cool"];
                break;
            case LinKonModeAir:
                // 不应该到这里来了
                break;
            default:
                break;
        }
    }
}

- (void)animationRoundImageView {
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 10;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = 1;MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.roundImageView.layer addAnimation:animation forKey:nil];
}

#pragma mark - Setter

- (void)setSn:(NSString *)sn {
    _sn = sn;
    
    WeakObj(self);
    self.roundTimer = [NSTimer hb_scheduledTimerWithTimeInterval:13 repeats:YES block:^(NSTimer *timer) {
        [selfWeak animationRoundImageView];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.roundTimer forMode:NSRunLoopCommonModes];
    [self.roundTimer fire];
    
    // 监听运行状态
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceRunning block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak updateInfoViewWithDevice:device];
    }];
    
    // 监听设置温度
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceSetting block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak updateInfoViewWithDevice:device];
    }];
    
    // 监听模式
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceMode block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        [selfWeak updateInfoViewWithDevice:device];
    }];
    
    // 监听延时开关
    [[DeviceManager sharedManager] registerListener:self device:sn key:KDeviceDelay block:^(NSObject *object) {
        if (![object isKindOfClass:[Device class]]) {
            return ;
        }
        Device *device = (Device *)object;
        if (device.delay > 0.0) {
            selfWeak.timerImageView.hidden = NO;
            selfWeak.timerLabel.hidden = NO;
            if (device.running == RunningStateON) {
                selfWeak.timerImageView.image = [UIImage imageNamed:@"icon_timer_off"];
            } else {
                selfWeak.timerImageView.image = [UIImage imageNamed:@"icon_timer_on"];
            }
            selfWeak.timeOffset = device.delay - [NSDate timeIntervalSinceReferenceDate];
        } else {
            selfWeak.timerImageView.hidden = YES;
            selfWeak.timerLabel.hidden = YES;
        }
    }];
}

- (void)setTimeOffset:(int)timeOffset {
    _timeOffset = timeOffset;
    
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
    __block int timeOut = _timeOffset;
    __block NSString *blockSN = self.sn;
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
            Device *device = [[DeviceManager sharedManager] getDevice:blockSN];
            [[DeviceManager sharedManager] editDevice:blockSN key:KDeviceRunning value:@(device.switchRunning)];
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    [self.countDownTimer fire];
}

#pragma mark - 懒加载

- (UIImageView *)roundImageView {
    if (!_roundImageView) {
        _roundImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, CircleInfoViewRoundImageViewInset, CircleInfoViewRoundImageViewInset)];
        [self addSubview:_roundImageView];
        
        _roundImageView.image = [UIImage imageNamed:@"bkg_cycle_hot"];
    }
    return _roundImageView;
}

- (CALayer *)outLayer {
    if (!_outLayer) {
        _outLayer = [CALayer layer];
        CGFloat offset = KHorizontalCeil(CircleInfoViewOutLayerInset);
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
        _middleLayer.frame = CGRectInset(self.outLayer.frame, CircleInfoViewMiddleLayerInset, CircleInfoViewMiddleLayerInset);
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
        _inLayer.frame = CGRectInset(self.middleLayer.frame, CircleInfoViewInLayerInset, CircleInfoViewInLayerInset);
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

- (UIImageView *)humidityImageView {
    if (!_humidityImageView) {
        _humidityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(baseLineLeft - CircleInfoViewImageIconSize / 2.0,
                                                                           baseLineTop - CircleInfoViewImageIconSize,
                                                                           CircleInfoViewImageIconSize,
                                                                           CircleInfoViewImageIconSize)];
        [self addSubview:_humidityImageView];
        
        _humidityImageView.image = [UIImage imageNamed:@"icon_humidity"];
        _humidityImageView.alpha = 0.8;
    }
    return _humidityImageView;
}

- (UILabel *)humidityLabel {
    if (!_humidityLabel) {
        _humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseLineLeft - currentLabelSize.width / 2.0,
                                                                   baseLineTop,
                                                                   currentLabelSize.width,
                                                                   currentLabelSize.height)];
        [self addSubview:_humidityLabel];
        
        _humidityLabel.font = currentLabelFont;
        _humidityLabel.textAlignment = NSTextAlignmentCenter;
        _humidityLabel.textColor = HB_COLOR_BASE_WHITE;
        _humidityLabel.text = @"70%";
        _humidityLabel.alpha = 0.8;
    }
    return _humidityLabel;
}

- (UIImageView *)temperatureImageView {
    if (!_temperatureImageView) {
        _temperatureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(baseLineRight - CircleInfoViewImageIconSize / 2.0,
                                                                              baseLineTop - CircleInfoViewImageIconSize,
                                                                              CircleInfoViewImageIconSize,
                                                                              CircleInfoViewImageIconSize)];
        [self addSubview:_temperatureImageView];
        
        _temperatureImageView.image = [UIImage imageNamed:@"icon_temperature"];
        _temperatureImageView.alpha = 0.8;
    }
    return _temperatureImageView;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseLineRight - currentLabelSize.width / 2.0,
                                                                      baseLineTop,
                                                                      currentLabelSize.width,
                                                                      currentLabelSize.height)];
        [self addSubview:_temperatureLabel];
        
        _temperatureLabel.font = currentLabelFont;
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.textColor = HB_COLOR_BASE_WHITE;
        _temperatureLabel.text = @"27.5℃";
        _temperatureLabel.alpha = 0.8;
    }
    return _temperatureLabel;
}

- (UILabel *)mainLabel {
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(floorf(CGRectGetMidX(self.inLayer.frame) - mainLabelSize.width / 2.0),
                                                              baseLineBottom - mainLabelSize.height,
                                                              mainLabelSize.width,
                                                              mainLabelSize.height)];
        [self addSubview:_mainLabel];
        
        _mainLabel.textColor = HB_COLOR_BASE_WHITE;
        _mainLabel.font = mainLabelFont;
        _mainLabel.adjustsFontSizeToFitWidth = YES;
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.text = KString(@"--");
    }
    return _mainLabel;
}

- (UILabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseLineRight - settingLabelSize.width,
                                                                  baseLineBottom - settingLabelSize.height,
                                                                  settingLabelSize.width,
                                                                  settingLabelSize.height)];
        [self addSubview:_settingLabel];
        
        _settingLabel.font = settingLabelFont;
        _settingLabel.textColor = HB_COLOR_BASE_WHITE;
        _settingLabel.textAlignment = NSTextAlignmentRight;
        _settingLabel.text = @"--";
    }
    return _settingLabel;
}

- (UILabel *)modeLabel {
    if (!_modeLabel) {
        _modeLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseLineRight,
                                                               CGRectGetMinY(self.settingLabel.frame) + fixHeight,
                                                               modeLabelSize.width,
                                                               modeLabelSize.height)];
        [self addSubview:_modeLabel];
        
        _modeLabel.font = modeLabelFont;
        _modeLabel.textColor = HB_COLOR_BASE_WHITE;
        _modeLabel.textAlignment = NSTextAlignmentLeft;
        _modeLabel.text = KString(@"--");
        _modeLabel.alpha = 0.8;
    }
    return _modeLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseLineRight,
                                                               CGRectGetMaxY(self.settingLabel.frame) - unitLabelSize.height - fixHeight,
                                                               unitLabelSize.width,
                                                               unitLabelSize.height)];
        [self addSubview:_unitLabel];
        
        _unitLabel.font = unitLabelFont;
        _unitLabel.textColor = HB_COLOR_BASE_WHITE;
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.text = KString(@"℃");
    }
    return _unitLabel;
}


- (UIImageView *)timerImageView {
    if (!_timerImageView) {
        CGFloat totalWidth = CircleInfoViewImageIconSize + timerLabelSize.width;
        CGFloat offsetWidth = floorf((CGRectGetWidth(self.inLayer.frame) - totalWidth) / 2.0);
        _timerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.inLayer.frame) + offsetWidth,
                                                                        baseLineBottom,
                                                                        CircleInfoViewImageIconSize,
                                                                        CircleInfoViewImageIconSize)];
        [self addSubview:_timerImageView];
        
        _timerImageView.image = [UIImage imageNamed:@"icon_timer_off"];
        _timerImageView.tintColor = HB_COLOR_BASE_BLACK;
        _timerImageView.alpha = 0.7;
    }
    return _timerImageView;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timerImageView.frame),
                                                                CGRectGetMinY(self.timerImageView.frame),
                                                                timerLabelSize.width,
                                                                CGRectGetHeight(self.timerImageView.frame))];
        [self addSubview:_timerLabel];
        
        _timerLabel.font = timerLabelFont;
        _timerLabel.textColor = HB_COLOR_BASE_BLACK;
        _timerLabel.text = @"00\"00'00";
    }
    return _timerLabel;
}

@end
