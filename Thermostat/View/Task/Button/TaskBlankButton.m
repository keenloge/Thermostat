//
//  TaskBlankButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskBlankButton.h"
#import "Declare.h"
#import "ColorConfig.h"

@implementation TaskBlankButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInitialiseSubViews {
    self.backgroundColor = HB_COLOR_BASE_WHITE;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = UIFontOf3XPix(48);
    [self setTitleColor:UIColorFromRGBA(0, 0, 0, 0.85) forState:UIControlStateNormal];
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      CGRectGetHeight(contentRect) * 0.2,
                      CGRectGetWidth(contentRect),
                      CGRectGetHeight(contentRect) * 0.4);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0,
                      CGRectGetHeight(contentRect) * 0.6,
                      CGRectGetWidth(contentRect),
                      CGRectGetHeight(contentRect) * 0.4);
}

@end
