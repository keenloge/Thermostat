//
//  InfoButton.m
//  LinKon
//
//  Created by Keen on 2017/6/13.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "InfoButton.h"

#define KInfoButtonColor   UIColorFromHex(0xb3b3b3)

const CGFloat KInfoButtonSize = 28.0;  //  = 84.0 / 3.0

@implementation InfoButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"i" forState:UIControlStateNormal];
        self.titleLabel.font = UIFontOf3XPix(55);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:KInfoButtonColor forState:UIControlStateNormal];
        self.titleLabel.layer.borderColor = KInfoButtonColor.CGColor;
        self.titleLabel.layer.borderWidth = 1.0;
        self.titleLabel.layer.cornerRadius = KInfoButtonSize / 2.0;
    }
    return self;
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake((CGRectGetWidth(contentRect) - KInfoButtonSize) / 2.0,
                      (CGRectGetHeight(contentRect) - KInfoButtonSize) / 2.0,
                      KInfoButtonSize,
                      KInfoButtonSize);
}

@end
