//
//  ControlTabButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/2.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "ControlTabButton.h"
#import "UIImageAdditions.h"
#import "ColorConfig.h"
#import "Declare.h"

// 图片大小
const CGFloat ControlTabButtonImageSize    = 30.0;

@implementation ControlTabButton

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
    [self setBackgroundColor:HB_COLOR_TABBAR_BACKGROUND];
    [self setTitleColor:HB_COLOR_TABBAR_NORMAL forState:UIControlStateNormal];
    [self setTitleColor:HB_COLOR_TABBAR_SELECT forState:UIControlStateSelected];
    self.titleLabel.font = UIFontOf3XPix(33);
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      0,
                      CGRectGetWidth(contentRect),
                      ControlTabButtonImageSize);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      ControlTabButtonImageSize,
                      CGRectGetWidth(contentRect),
                      CGRectGetHeight(contentRect) - ControlTabButtonImageSize);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.tintColor = HB_COLOR_TABBAR_SELECT;
    } else {
        self.tintColor = HB_COLOR_TABBAR_NORMAL;
    }
}

@end
