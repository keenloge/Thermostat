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

- (instancetype)init {
    if (self = [super init]) {
        [self _baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _baseInit];
    }
    return self;
}

- (void)_baseInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseRestLanguage) name:KNotificationNameSwitchLanguage object:nil];
    
    [self baseInitialiseSubViews];
    [self baseRestLanguage];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)baseInitialiseSubViews {
    
}

- (void)baseRestLanguage {
    
}

@end
