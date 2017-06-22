//
//  MenuControlView.h
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, MenuControlButtonTag) {
    MenuControlButtonTagTimer   = 1,
    MenuControlButtonTagRunning,
    MenuControlButtonTagScene,
    MenuControlButtonTagLock,
    MenuControlButtonTagMode,
    MenuControlButtonTagWind,
};

typedef void(^MenuControlBlock)(MenuControlButtonTag tag);

@interface MenuControlView : BaseView

@property (nonatomic, copy) MenuControlBlock block;

- (void)updateButtonImage:(UIImage *)image tag:(MenuControlButtonTag)tag;

- (void)updateButtonEnabled:(BOOL)enabled tag:(MenuControlButtonTag)tag;

@end
