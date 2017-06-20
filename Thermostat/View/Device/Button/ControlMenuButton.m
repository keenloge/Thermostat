//
//  ControlMenuButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "ControlMenuButton.h"
#import "ColorConfig.h"
#import "Declare.h"

const CGFloat ControlMenuButtonImageSize = 55;

@implementation ControlMenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize imageSize = CGSizeMake(KHorizontalRound(ControlMenuButtonImageSize), KHorizontalRound(ControlMenuButtonImageSize));
    
    if (MIN(CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)) < MAX(imageSize.height, imageSize.width)) {
        return contentRect;
    }
    
    return CGRectMake((CGRectGetWidth(contentRect) - imageSize.width) / 2.0,
                      (CGRectGetHeight(contentRect) - imageSize.height) / 2.0,
                      imageSize.width,
                      imageSize.height);
}

- (void)baseInitialiseSubViews {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = HB_COLOR_BASE_WHITE;
    self.tintColor = HB_COLOR_BASE_MAIN;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        self.tintColor = HB_COLOR_BASE_MAIN;
    } else {
        self.tintColor = HB_COLOR_BASE_LIGHT;
    }
}

@end
