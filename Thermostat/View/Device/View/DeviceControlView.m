//
//  DeviceControlView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceControlView.h"
#import "TemperatureControlView.h"
#import "MenuControlView.h"
#import "Declare.h"

@interface DeviceControlView () {
    
}

@property (nonatomic, strong) TemperatureControlView *temperatureView;
@property (nonatomic, strong) MenuControlView *menuView;


@end

@implementation DeviceControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseInitialiseSubViews];
    }
    return self;
}

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.temperatureView.opaque = YES;
    self.menuView.opaque = YES;
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.temperatureView.frame) + CGRectGetHeight(self.menuView.frame));
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
}

/**
 设置按钮图片
 
 @param image 图片
 @param tag 按钮Tag
 */
- (void)updateButtonImage:(UIImage *)image tag:(MenuControlButtonTag)tag {
    [self.menuView updateButtonImage:image tag:tag];
}


/**
 设置按钮可用
 
 @param enabled 可用
 @param tag 按钮Tag
 */
- (void)updateButtonEnabled:(BOOL)enabled tag:(MenuControlButtonTag)tag {
    [self.menuView updateButtonEnabled:enabled tag:tag];
}


/**
 设置温度选择器是否可用
 
 @param enabled 是否可用
 */
- (void)updateTemperatureControlEnabled:(BOOL)enabled {
    [self.temperatureView updateControlEnabled:enabled];
}

/**
 设置温度选择标题
 
 @param array 温度标题组
 @param block 选中回调
 */
- (void)updateTemperatureArray:(NSArray <NSString *>*)array
                    checkBlock:(TemperatureControlCheckBlock)block {
    [self.temperatureView updateTemperatureArray:array checkBlock:block];
}


/**
 设置当前选中项
 
 @param index 当前选中项
 */
- (void)updateTemperatureCheckIndex:(NSInteger)index {
    [self.temperatureView updateTemperatureCheckIndex:index];
}


#pragma mark - Setter

- (void)setBlock:(MenuControlBlock)block {
    self.menuView.block = block;
}

#pragma mark - 懒加载

- (TemperatureControlView *)temperatureView {
    if (!_temperatureView) {
        CGFloat scale = IPHONE_INCH_3_5 ? 0.5 : 0.35;
        _temperatureView = [[TemperatureControlView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    CGRectGetWidth(self.frame),
                                                                                    floor(CGRectGetHeight(self.frame) * scale))];
        [self addSubview:_temperatureView];
    }
    return _temperatureView;
}

- (MenuControlView *)menuView {
    if (!_menuView) {
        CGFloat height = 0.0;
        if (IPHONE_INCH_3_5) {
            height = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.temperatureView.frame)) * 2;
        } else {
            height = CGRectGetHeight(self.frame) - CGRectGetHeight(self.temperatureView.frame);
        }
        
        _menuView = [[MenuControlView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.temperatureView.frame),
                                                                      CGRectGetWidth(self.frame),
                                                                      height)];
        [self addSubview:_menuView];
    }
    return _menuView;
}

@end
