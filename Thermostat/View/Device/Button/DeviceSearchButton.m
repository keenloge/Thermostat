//
//  DeviceSearchButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/6.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceSearchButton.h"
#import "UIImageAdditions.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "NSTimerAdditions.h"

@interface DeviceSearchButton () {
    int pulsingCount;
    CGFloat animationDuration;
    NSInteger countDownTimes;
}

@property (nonatomic, copy) DeviceSearchBlock block;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) CALayer *animationLayer;

@end

@implementation DeviceSearchButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    if ([self.countdownTimer isValid]) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return contentRect;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    return bounds;
}

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setImage:[UIImage imageWithColor:HB_COLOR_BASE_MAIN] forState:UIControlStateNormal];
    
    pulsingCount = 2.0;
    animationDuration = 2.0;
}


#pragma mark - 动画

- (void)startAnimationWithDuration:(NSInteger)duration finishBlock:(DeviceSearchBlock)block {
    self.block = block;
    
    self.userInteractionEnabled = NO;
    self.titleString = self.titleLabel.text;
    
    [self beginAnimation];
    countDownTimes = duration;
    WeakObj(self);
    self.countdownTimer = [NSTimer hb_scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
        [selfWeak countDown];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    [self.countdownTimer fire];
}

- (void)beginAnimation {
    CGRect rect = self.bounds;
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = HB_COLOR_BASE_MAIN.CGColor;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        // 大小
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1;
        scaleAnimation.toValue = @4;
        
        // 宽度
        CABasicAnimation * widthAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        widthAnimation.fromValue = @2;
        widthAnimation.toValue = @5;
        
        
        // 不透明度
        CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @1;
        opacityAnimation.toValue = @0;

//        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
//        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, widthAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [self.animationLayer addSublayer:pulsingLayer];
    }
}

- (void)stopAnimation {
    for (int i = 0; i < self.animationLayer.sublayers.count; i++) {
        CALayer *subLayer = [self.animationLayer.sublayers objectAtIndex:i];
        [subLayer removeAllAnimations];
        [subLayer removeFromSuperlayer];
        i--;
    }
}

#pragma mark - 计时函数

- (void)countDown {
    [self setTitle:[NSString stringWithFormat:@"%zd", countDownTimes--] forState:UIControlStateNormal];
    if (countDownTimes < 0) {
//        [self setTitle:self.titleString forState:UIControlStateNormal];
        [self stopAnimation];
        self.userInteractionEnabled = YES;
        [self.countdownTimer invalidate];
        if (self.block) {
            self.block();
        }
    }
}

#pragma mark - 点击事件

- (void)buttonPressed:(id)sender {
}

#pragma mark - 懒加载

- (CALayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CALayer layer];
        [self.superview.layer addSublayer:_animationLayer];
        _animationLayer.frame = self.frame;
    }
    return _animationLayer;
}

@end
