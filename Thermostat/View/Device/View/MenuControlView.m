//
//  MenuControlView.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "MenuControlView.h"
#import "ControlMenuButton.h"
#import "FeedBackManager.h"

@interface MenuControlView () {
    CGFloat offsetX;
    CGFloat offsetY;
    CGFloat sideButtonWidth;
    CGFloat middleButtonWidth;
    CGFloat topButtonHeight;
    CGFloat bottomButtonHeight;
}

@property (nonatomic, strong) ControlMenuButton *timerButton;
@property (nonatomic, strong) ControlMenuButton *runningButton;
@property (nonatomic, strong) ControlMenuButton *sceneButton;
@property (nonatomic, strong) ControlMenuButton *lockButton;
@property (nonatomic, strong) ControlMenuButton *modeButton;
@property (nonatomic, strong) ControlMenuButton *windButton;

@end

@implementation MenuControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.backgroundColor = HB_COLOR_MENU_CUTLINE;
    offsetX = 1.0;
    offsetY = 1.0;
    sideButtonWidth = ceilf((CGRectGetWidth(self.frame) - (offsetY * 2)) / 3);
    middleButtonWidth = CGRectGetWidth(self.frame) - (sideButtonWidth * 2) - (offsetY * 2.0);
    topButtonHeight = ceilf((CGRectGetHeight(self.frame) - (offsetX * 2)) / 2);
    bottomButtonHeight = CGRectGetHeight(self.frame) - topButtonHeight - (offsetX * 2.0);
    
    self.timerButton.opaque = YES;
    self.runningButton.opaque = YES;
    self.sceneButton.opaque = YES;
    self.lockButton.opaque = YES;
    self.modeButton.opaque = YES;
    self.windButton.opaque = YES;
}

- (void)updateButtonImage:(UIImage *)image tag:(MenuControlButtonTag)tag {
    ControlMenuButton *button = [self viewWithTag:tag];
    [button setImage:image forState:UIControlStateNormal];
}

- (void)updateButtonEnabled:(BOOL)enabled tag:(MenuControlButtonTag)tag {
    ControlMenuButton *button = [self viewWithTag:tag];
    button.enabled = enabled;
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}


#pragma mark - 懒加载

- (ControlMenuButton *)timerButton {
    if (!_timerButton) {
        _timerButton = [[ControlMenuButton alloc] initWithFrame:CGRectMake(0,
                                                                           offsetY,
                                                                           sideButtonWidth,
                                                                           topButtonHeight)];
        [self addSubview:_timerButton];
        _timerButton.tag = MenuControlButtonTagTimer;
        [_timerButton setImage:[UIImage imageNamed:@"btn_menu_timer_on"] forState:UIControlStateNormal];
        [_timerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerButton;
}

- (ControlMenuButton *)runningButton {
    if (!_runningButton) {
        _runningButton = [[ControlMenuButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timerButton.frame) + offsetX,
                                                                             offsetY,
                                                                             middleButtonWidth,
                                                                             topButtonHeight)];
        [self addSubview:_runningButton];
        _runningButton.tag = MenuControlButtonTagRunning;
        [_runningButton setImage:[UIImage imageNamed:@"btn_menu_running"] forState:UIControlStateNormal];
        [_runningButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runningButton;
}

- (ControlMenuButton *)sceneButton {
    if (!_sceneButton) {
        _sceneButton = [[ControlMenuButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.runningButton.frame) + offsetX,
                                                                           offsetY,
                                                                           sideButtonWidth,
                                                                           topButtonHeight)];
        [self addSubview:_sceneButton];
        _sceneButton.tag = MenuControlButtonTagScene;
        [_sceneButton setImage:[UIImage imageNamed:@"btn_menu_scene"] forState:UIControlStateNormal];
        [_sceneButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sceneButton;
}

- (ControlMenuButton *)lockButton {
    if (!_lockButton) {
        _lockButton = [[ControlMenuButton alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(self.timerButton.frame) + offsetY,
                                                                          sideButtonWidth,
                                                                          bottomButtonHeight)];
        [self addSubview:_lockButton];
        _lockButton.tag = MenuControlButtonTagLock;
        [_lockButton setImage:[UIImage imageNamed:@"btn_menu_lock"] forState:UIControlStateNormal];
        [_lockButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockButton;
}

- (ControlMenuButton *)modeButton {
    if (!_modeButton) {
        _modeButton = [[ControlMenuButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lockButton.frame) + offsetX,
                                                                          CGRectGetMinY(self.lockButton.frame),
                                                                          middleButtonWidth,
                                                                          bottomButtonHeight)];
        [self addSubview:_modeButton];
        _modeButton.tag = MenuControlButtonTagMode;
        [_modeButton setImage:[UIImage imageNamed:@"btn_menu_mode"] forState:UIControlStateNormal];
        [_modeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}

- (ControlMenuButton *)windButton {
    if (!_windButton) {
        _windButton = [[ControlMenuButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.modeButton.frame) + offsetX,
                                                                          CGRectGetMinY(self.lockButton.frame),
                                                                          sideButtonWidth,
                                                                          bottomButtonHeight)];
        [self addSubview:_windButton];
        _windButton.tag = MenuControlButtonTagWind;
        [_windButton setImage:[UIImage imageNamed:@"btn_menu_wind"] forState:UIControlStateNormal];
        [_windButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _windButton;
}

@end
