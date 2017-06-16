//
//  TaskBlankView.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskBlankView.h"
#import "TaskBlankButton.h"
#import "Globals.h"

const CGFloat TaskBlankContentButtonViewHeight = 160.0;
const CGFloat TaskBlankContentSloganViewHeight = 80.0;

const CGFloat TaskBlankMainTitleCenterYScale = 384.0 / 2016.0;
const CGFloat TaskBlankSubTitleCenterYScale = 543.0 / 2016.0;

@interface TaskBlankView () {

}

@property (nonatomic, strong) UIView *contentButtonView;

@property (nonatomic, strong) TaskBlankButton *switchButton;
@property (nonatomic, strong) TaskBlankButton *stageButton;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *cutLineView;

// 中文状态使用的主副标题
@property (nonatomic, strong) UIView *contentMainTitleView;
@property (nonatomic, strong) NSArray *mainTitleArray;
@property (nonatomic, strong) UILabel *subTitleLabel;

// 英文状态使用的单独标题
@property (nonatomic, strong) UILabel *singleTitleLabel;

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
    if ([[[LanguageManager sharedManager] currentLanguage] isEqualToString:@"en"]) {
        self.singleTitleLabel.opaque = YES;
    } else {
        self.contentMainTitleView.opaque = YES;
        self.subTitleLabel.opaque = YES;
    }
    
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
                                                                      NAVIGATION_VIEW_HEIGHT * 0.7 - KHorizontalRound(TaskBlankContentButtonViewHeight) / 2.0,
                                                                      MAIN_SCREEN_WIDTH,
                                                                      KHorizontalRound(TaskBlankContentButtonViewHeight))];
        [self addSubview:_contentButtonView];
        _contentButtonView.backgroundColor = HB_COLOR_BASE_WHITE;
    }
    return _contentButtonView;
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

- (UIView *)contentMainTitleView {
    if (!_contentMainTitleView) {
        _contentMainTitleView = [UIView new];
        [self addSubview:_contentMainTitleView];
        
        WeakObj(self);
        if (self.mainTitleArray.count > 0) {
            CGFloat offsetX = KHorizontalRound(14.0);

            __weak UIView *lastView = [self.mainTitleArray firstObject];
            [_contentMainTitleView addSubview:lastView];
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(selfWeak.contentMainTitleView);
                make.left.equalTo(selfWeak.contentMainTitleView);
            }];
            
            if (self.mainTitleArray.count > 1) {
                for (int i = 1; i < self.mainTitleArray.count; i++) {
                    UIView *subView = [self.mainTitleArray objectAtIndex:i];
                    [_contentMainTitleView addSubview:subView];
                    
                    if ([subView isKindOfClass:[UILabel class]]) {
                        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(selfWeak.contentMainTitleView);
                            make.left.equalTo(lastView.mas_right).offset(offsetX);
                        }];
                    } else {
                        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(2, KHorizontalRound(25)));
                            make.centerY.equalTo(selfWeak.contentMainTitleView);
                            make.left.equalTo(lastView.mas_right).offset(offsetX);
                        }];
                    }
                    
                    lastView = subView;
                }
            }
            
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(selfWeak.contentMainTitleView);
            }];
        }

        [_contentMainTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KHorizontalRound(87));
            make.centerX.equalTo(selfWeak);
            make.centerY.equalTo(selfWeak.mas_top).offset(NAVIGATION_VIEW_HEIGHT * TaskBlankMainTitleCenterYScale);
        }];
    }
    return _contentMainTitleView;
}

- (NSArray *)mainTitleArray {
    if (!_mainTitleArray) {
        NSString *mainTitle = @"规划时间";
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i = 0; i < mainTitle.length; i++) {
            NSString *subString = [mainTitle substringWithRange:NSMakeRange(i, 1)];
            [titleArray addObject:subString];
        }
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < titleArray.count; i++) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.textColor = HB_COLOR_BASE_BLACK;
            titleLabel.font = UIFontOf3XPix(KHorizontalRound(87));
            titleLabel.text = [titleArray objectAtIndex:i];
            [tempArray addObject:titleLabel];
            
            if (i < (titleArray.count  - 1)) {
                UIView *lineView = [UIView new];
                lineView.backgroundColor = UIColorFromHex(0xa8a8a8);
                [tempArray addObject:lineView];
            }
        }
        _mainTitleArray = [tempArray copy];
    }
    return _mainTitleArray;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        [self addSubview:_subTitleLabel];
        _subTitleLabel.textColor = HB_COLOR_BASE_BLACK;
        _subTitleLabel.alpha = 0.6;
        _subTitleLabel.font = UIFontOf3XPix(KHorizontalRound(69));
        
        _subTitleLabel.text = @"随心所欲";
        
        WeakObj(self);
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak);
            make.centerY.equalTo(selfWeak.mas_top).offset(NAVIGATION_VIEW_HEIGHT * TaskBlankSubTitleCenterYScale);
        }];
    }
    return _subTitleLabel;
}

- (UILabel *)singleTitleLabel {
    if (!_singleTitleLabel) {
        _singleTitleLabel = [UILabel new];
        [self addSubview:_singleTitleLabel];
        _singleTitleLabel.textColor = HB_COLOR_BASE_BLACK;
        _singleTitleLabel.font = UIFontOf3XPix(KHorizontalRound(87));
        _singleTitleLabel.textAlignment = NSTextAlignmentCenter;
        _singleTitleLabel.numberOfLines = 0;
        _singleTitleLabel.text = @"Manage Your Time\nPlaying By Heart";

        WeakObj(self);
        [_singleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak);
            make.centerY.equalTo(selfWeak.mas_top).offset(NAVIGATION_VIEW_HEIGHT * (TaskBlankMainTitleCenterYScale + TaskBlankSubTitleCenterYScale) / 2.0);
        }];
    }
    return _singleTitleLabel;
}

@end
