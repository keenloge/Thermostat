//
//  DeviceBlankButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceBlankButton.h"

const CGFloat KDeviceBlankButtonImageScale      = 0.6;
const CGFloat KDeviceBlankButtonTitleScale      = 0.25;

@implementation DeviceBlankButton

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
//    [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
}


- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      0,
                      CGRectGetWidth(contentRect),
                      floorf(CGRectGetHeight(contentRect) * KDeviceBlankButtonImageScale));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat pointY = floorf(CGRectGetHeight(contentRect) * (1 - KDeviceBlankButtonTitleScale));
    return CGRectMake(0,
                      pointY,
                      CGRectGetWidth(contentRect),
                      CGRectGetHeight(contentRect) - pointY);
}

@end
