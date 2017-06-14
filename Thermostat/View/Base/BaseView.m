//
//  BaseView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"
#import "LanguageManager.h"

@implementation BaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseRestLanguage) name:KNotificationNameSwitchLanguage object:nil];
        
        [self baseInitialiseSubViews];
        [self baseRestLanguage];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)baseInitialiseSubViews {
    
}

- (void)baseRestLanguage {
    
}

@end
