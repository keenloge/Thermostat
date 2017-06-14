//
//  TaskBlankView.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskBlankView.h"
#import "TaskBlankButton.h"
#import "TaskSloganView.h"
#import "ColorConfig.h"
#import "Globals.h"

const CGFloat TaskBlankContentButtonViewHeight = 160.0;
const CGFloat TaskBlankContentSloganViewHeight = 80.0;

@interface TaskBlankView () {

}

@property (nonatomic, strong) TaskSloganView *contentSloganView;
@property (nonatomic, strong) UIView *contentButtonView;

@property (nonatomic, strong) TaskBlankButton *switchButton;
@property (nonatomic, strong) TaskBlankButton *stageButton;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *cutLineView;

@end

@implementation TaskBlankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    self.contentSloganView.opaque = YES;
    
    UIView *contentButtonView = self.contentButtonView;
    TaskBlankButton *switchButton = self.switchButton;
    TaskBlankButton *stageButton = self.stageButton;
    UIView *topLineView = self.topLineView;
    UIView *bottomLineView = self.bottomLineView;
    UIView *cutLineView = self.cutLineView;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(contentButtonView, switchButton, stageButton, topLineView, bottomLineView, cutLineView);
    
    NSDictionary *metricsDictionary = @{@"cutLineViewHeight" : @(TaskBlankContentButtonViewHeight * 0.425),
                                        @"lineViewSize" : @(1)};
    
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLineView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLineView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[switchButton][cutLineView(lineViewSize)][stageButton(switchButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLineView(lineViewSize)][switchButton][bottomLineView(lineViewSize)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLineView][stageButton][bottomLineView]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cutLineView(cutLineViewHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.contentButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cutLineView]-(<=1)-[contentButtonView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}

#pragma mark - 懒加载

- (UIView *)contentButtonView {
    if (!_contentButtonView) {
        _contentButtonView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      NAVIGATION_VIEW_HEIGHT * 0.7 - KHorizontalCeil(TaskBlankContentButtonViewHeight) / 2.0,
                                                                      MAIN_SCREEN_WIDTH,
                                                                      KHorizontalCeil(TaskBlankContentButtonViewHeight))];
        [self addSubview:_contentButtonView];
        _contentButtonView.backgroundColor = HB_COLOR_BASE_WHITE;
    }
    return _contentButtonView;
}

- (UIView *)contentSloganView {
    if (!_contentSloganView) {
        _contentSloganView = [[TaskSloganView alloc] initWithFrame:CGRectMake(0,
                                                                      NAVIGATION_VIEW_HEIGHT * 0.3 - KHorizontalCeil(TaskBlankContentSloganViewHeight),
                                                                      MAIN_SCREEN_WIDTH,
                                                                      KHorizontalCeil(TaskBlankContentSloganViewHeight))];
        [self addSubview:_contentSloganView];
    }
    return _contentSloganView;
}

- (TaskBlankButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [Globals addedSubViewClass:[TaskBlankButton class] toView:self.contentButtonView];
        [_switchButton setTitle:KString(@"开关定时") forState:UIControlStateNormal];
        [_switchButton setImage:[UIImage imageNamed:@"btn_switch_n"] forState:UIControlStateNormal];
        [_switchButton setImage:[UIImage imageNamed:@"btn_switch_d"] forState:UIControlStateHighlighted];
        _switchButton.tag = TaskTypeSwitch;
        [_switchButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (TaskBlankButton *)stageButton {
    if (!_stageButton) {
        _stageButton = [Globals addedSubViewClass:[TaskBlankButton class] toView:self.contentButtonView];
        [_stageButton setTitle:KString(@"阶段定时") forState:UIControlStateNormal];
        [_stageButton setImage:[UIImage imageNamed:@"btn_stage_n"] forState:UIControlStateNormal];
        [_stageButton setImage:[UIImage imageNamed:@"btn_stage_d"] forState:UIControlStateHighlighted];
        _stageButton.tag = TaskTypeStage;
        [_stageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stageButton;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentButtonView];
        _topLineView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.1);
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentButtonView];
        _bottomLineView.backgroundColor = self.topLineView.backgroundColor;
    }
    return _bottomLineView;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentButtonView];
        _cutLineView.backgroundColor = self.topLineView.backgroundColor;
    }
    return _cutLineView;
}

@end
