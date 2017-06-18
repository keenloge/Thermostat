//
//  TemperatureControlView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TemperatureControlView.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "DeviceManager.h"
#import "LinKonDevice.h"
#import "Globals.h"

const CGFloat KTemperatureControlCountShow      = 5.0;
const CGFloat KTemperatureControlCutLineOffsetY = 12.0;
const CGFloat KTemperatureControlCutLineHeight  = 11.0;
const CGFloat KTemperatureControlCutLineWidth   = 1.0;


@interface TemperatureControlView () <UIScrollViewDelegate> {
    CGFloat offsetX;        // 指示线X偏移
    CGFloat offsetY;        // 指示线Y偏移
    CGFloat lineViewHeight; // 指示线高度
    CGFloat lineViewWidth;  // 指示线宽度
    CGFloat numberShow;     // 文本总显示数量
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) NSArray *slideViewArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger scrollToIndex;

@end

@implementation TemperatureControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 数据更新

- (void)updateCurrentIndex {
    self.currentIndex = self.contentScrollView.contentOffset.x / CGRectGetWidth(self.contentScrollView.frame) + 0.5;
}

- (void)editTemperature {
    [[DeviceManager sharedManager] editDevice:self.sn key:KDeviceSetting value:@(self.currentIndex * LINKON_TEMPERATURE_OFFSET + LINKON_TEMPERATURE_MIN)];
}

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    numberShow = KTemperatureControlCountShow;
    offsetY = KHorizontalRound(KTemperatureControlCutLineOffsetY);
    lineViewHeight = KHorizontalRound(KTemperatureControlCutLineHeight);
    lineViewWidth = KTemperatureControlCutLineWidth;
    offsetX = floor((CGRectGetWidth(self.frame) - lineViewWidth) / 2.0);
    
    
    self.backgroundColor = HB_COLOR_BASE_WHITE;
    
    self.contentScrollView.opaque = YES;
    self.topLineView.opaque = YES;
    self.bottomLineView.opaque = YES;
}

- (void)updateSlideView {
    CGFloat itemWidth = CGRectGetWidth(self.contentScrollView.frame);
    self.currentIndex = self.contentScrollView.contentOffset.x / itemWidth + 0.5;
    
    CGFloat currentCenterX = self.contentScrollView.contentOffset.x + (itemWidth / 2.0);
    CGFloat preCount = (numberShow + 1) / 2.0;
    NSInteger beginIndex = MAX(0, floor(self.currentIndex - preCount));
    NSInteger endIndex = MIN(ceil(self.currentIndex + preCount), self.slideViewArray.count - 1);
    
    CGFloat offsetIndex = 0.0;
    CGFloat labelAlpha = 0.0;
    CGFloat labelScale = 0.0;
    UILabel *label = nil;
    
    for (NSInteger i = beginIndex; i <= endIndex; i++) {
        label = [self.slideViewArray objectAtIndex:i];
        
        offsetIndex = fabs((label.center.x - currentCenterX) / itemWidth);
        labelAlpha = 1 - offsetIndex / (preCount + 0);
        labelScale = 1 - offsetIndex / (preCount * 2);
        
        label.alpha = labelAlpha;
        label.transform = CGAffineTransformMakeScale(labelScale, labelScale);
    }
}

- (void)updateSlideViewStateWithDevice:(LinKonDevice *)device {
    self.userInteractionEnabled = YES;
    if (device.running == DeviceRunningStateTurnOFF || device.mode == LinKonModeAir) {
        self.userInteractionEnabled = NO;
    }
    for (UILabel *label in self.slideViewArray) {
        label.textColor = self.userInteractionEnabled ? label.textColor = HB_COLOR_BASE_MAIN : HB_COLOR_BASE_LIGHT;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateSlideView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self editTemperature];
    self.scrollToIndex = self.currentIndex;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self editTemperature];
        self.scrollToIndex = self.currentIndex;
    }
}

#pragma mark - 点击事件

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.userInteractionEnabled) {
        return self.contentScrollView;
    }
    return nil;
}

- (void)handleTapGesture:( UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    CGFloat changeIndex = (point.x - CGRectGetMinX(self.contentScrollView.frame)) / CGRectGetWidth(self.contentScrollView.frame);
    self.scrollToIndex = self.currentIndex + changeIndex;
    self.currentIndex = self.scrollToIndex;
    [self editTemperature];
}

#pragma mark - Setter

- (void)setSn:(NSString *)sn {
    _sn = sn;
    
    WeakObj(self);
    [[DeviceManager sharedManager] registerListener:self device:sn group:LinKonPropertyGroupState | LinKonPropertyGroupSetting block:^(NSObject *object) {
        if (![object isKindOfClass:[LinKonDevice class]]) {
            return ;
        }
        LinKonDevice *device = (LinKonDevice *)object;
        [selfWeak updateSlideViewStateWithDevice:device];
        selfWeak.scrollToIndex = (device.setting - LINKON_TEMPERATURE_MIN) / LINKON_TEMPERATURE_OFFSET;
    }];
}

- (void)setScrollToIndex:(NSInteger)index {
    if (index < 0 || index >= self.slideViewArray.count) {
        return;
    }
    _scrollToIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.contentScrollView.frame) * index, 0) animated:YES];
}

#pragma mark - Getter

- (NSArray *)slideViewArray {
    if (!_slideViewArray) {
        CGFloat itemWidth = CGRectGetWidth(self.contentScrollView.frame);
        CGFloat itemHeight = CGRectGetHeight(self.frame);
        CGFloat itemOffsetX = 0.0;
        NSInteger count = 0;
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (CGFloat i = LINKON_TEMPERATURE_MIN; i <= LINKON_TEMPERATURE_MAX; i += LINKON_TEMPERATURE_OFFSET) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((itemWidth + itemOffsetX) * count, 0, itemWidth, itemHeight)];
            [_contentScrollView addSubview:label];
            label.backgroundColor = HB_COLOR_BASE_WHITE;
            label.font = UIFontOf3XPix(KHorizontalRound(68));
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = HB_COLOR_BASE_MAIN;
            label.text = [Globals settingString:i];
            [tmpArray addObject:label];
            count++;
        }
        [_contentScrollView setContentSize:CGSizeMake(count * (itemWidth) + (count - 1) * itemOffsetX, CGRectGetHeight(_contentScrollView.frame))];
        _slideViewArray = [tmpArray copy];
    }
    return _slideViewArray;
}

#pragma mark - 懒加载

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGFloat scrollWidth = CGRectGetWidth(self.frame) / numberShow;
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - scrollWidth) / 2.0,
                                                                            0,
                                                                            scrollWidth,
                                                                            CGRectGetHeight(self.frame))];
        [self addSubview:_contentScrollView];
        _contentScrollView.backgroundColor = HB_COLOR_BASE_WHITE;
        _contentScrollView.clipsToBounds = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        sigleTapRecognizer.numberOfTapsRequired = 1;
        [_contentScrollView addGestureRecognizer:sigleTapRecognizer];
    }
    return _contentScrollView;
}


- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX,
                                                                offsetY,
                                                                lineViewWidth,
                                                                lineViewHeight)];
        _topLineView.backgroundColor = HB_COLOR_BASE_MAIN;
        _topLineView.alpha = 0.3;
        [self addSubview:_topLineView];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX,
                                                                   CGRectGetHeight(self.frame) - offsetY - lineViewHeight,
                                                                   lineViewWidth,
                                                                   lineViewHeight)];
        _bottomLineView.backgroundColor = HB_COLOR_BASE_MAIN;
        _bottomLineView.alpha = 0.3;
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

@end
