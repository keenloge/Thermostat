//
//  BaseButton.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseButton.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "UIImageAdditions.h"

@implementation BaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.titleLabel.shadowOffset = CGSizeZero;
    [self baseInitialiseSubViews];
}

- (void)baseInitialiseSubViews {
    
}

@end

@implementation ColorMainButton

- (void)baseInitialiseSubViews {
    self.titleLabel.font = UIFontOf3XPix(60);
    [self setTitleColor:HB_COLOR_BASE_WHITE forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:HB_COLOR_BASE_MAIN] forState:UIControlStateNormal];
}

@end
