//
//  DevicePopButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DevicePopButton.h"
#import "ColorConfig.h"
#import "Declare.h"

// 上边距
const CGFloat PopMenuButtonOffsetTop    = 22.0;

// 下边距
const CGFloat PopMenuButtonOffsetBottom = 16.0;

// 图片大小
const CGFloat PopMenuButtonImageSize    = 25.0;

// 标题高度
const CGFloat PopMenuButtonTitleHeight  = 13.0;

@implementation DevicePopButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInitialiseSubViews {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:HB_COLOR_POP_ACTION forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    self.titleLabel.font = UIFontOf3XPix(39);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      PopMenuButtonOffsetTop,
                      CGRectGetWidth(contentRect),
                      PopMenuButtonImageSize);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      CGRectGetHeight(contentRect) - PopMenuButtonOffsetBottom - PopMenuButtonTitleHeight,
                      CGRectGetWidth(contentRect),
                      PopMenuButtonTitleHeight);
}

@end
