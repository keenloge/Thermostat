//
//  BaseLabel.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseLabel.h"
#import "ColorConfig.h"
#import "Declare.h"

@implementation BaseLabel

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

- (void)baseInitialiseSubViews {
    
}

@end


@implementation InputFrontLabel

- (void)baseInitialiseSubViews {
    self.textAlignment = NSTextAlignmentRight;
    self.font = UIFontOf3XPix(45);
    self.textColor = HB_COLOR_BASE_DEEP;
}

@end
