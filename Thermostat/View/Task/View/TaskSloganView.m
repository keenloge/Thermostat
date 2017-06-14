//
//  TaskSloganView.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskSloganView.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"
#import "LanguageManager.h"

@interface TaskSloganView ()


/**
 英文状态, 提示文本
 */
@property (nonatomic, strong) UILabel *singleTitleLabel;


/**
 中文状态, 大标题框架
 */
@property (nonatomic, strong) UIView *contentMainTitleView;


/**
 中文状态, 副标题
 */
@property (nonatomic, strong) UILabel *subTitleLabel;


@end

@implementation TaskSloganView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 Manage Your Time
 Playing By Heart
}
*/

- (void)baseInitialiseSubViews {
    if ([[[LanguageManager sharedManager] currentLanguage] isEqualToString:@"en"]) {
        self.singleTitleLabel.text = @"Manage Your Time\nPlaying By Heart";
    } else {
        UIView *contentMainTitleView = self.contentMainTitleView;
        UILabel *subTitleLabel = self.subTitleLabel;
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(contentMainTitleView, subTitleLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentMainTitleView]|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subTitleLabel]|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentMainTitleView(35)]" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subTitleLabel(25)]|" options:0 metrics:nil views:viewsDictionary]];
        
        UIView *cutLineMiddleView = [self addedCutLineViewBetweenMainTitleToView:contentMainTitleView];
        UIView *cutLineLeftView = [self addedCutLineViewBetweenMainTitleToView:contentMainTitleView];
        UIView *cutLineRightView = [self addedCutLineViewBetweenMainTitleToView:contentMainTitleView];
        
        UILabel *main0TitleLabel = [self addedMainTitle:@"规" toView:contentMainTitleView];
        UILabel *main1TitleLabel = [self addedMainTitle:@"划" toView:contentMainTitleView];
        UILabel *main2TitleLabel = [self addedMainTitle:@"时" toView:contentMainTitleView];
        UILabel *main3TitleLabel = [self addedMainTitle:@"间" toView:contentMainTitleView];
        
        viewsDictionary = NSDictionaryOfVariableBindings(contentMainTitleView, cutLineMiddleView, cutLineLeftView, cutLineRightView, main0TitleLabel, main1TitleLabel, main2TitleLabel, main3TitleLabel);
        NSDictionary *metricsDictionary = @{@"mainTitleOffset" : @(15),
                                            @"cutLineWidth" : @(1),
                                            @"cutLineHeight" : @(25)};
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                              @"H:[main0TitleLabel]-mainTitleOffset-[cutLineLeftView(cutLineWidth)]-mainTitleOffset-[main1TitleLabel]-mainTitleOffset-[cutLineMiddleView(cutLineWidth)]-mainTitleOffset-[main2TitleLabel]-mainTitleOffset-[cutLineRightView(cutLineWidth)]-mainTitleOffset-[main3TitleLabel]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main0TitleLabel]|" options:0 metrics:nil views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main1TitleLabel]|" options:0 metrics:nil views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main2TitleLabel]|" options:0 metrics:nil views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main3TitleLabel]|" options:0 metrics:nil views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cutLineLeftView(cutLineHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cutLineMiddleView(cutLineHeight)]-(<=1)-[contentMainTitleView]" options:NSLayoutFormatAlignAllCenterX metrics:metricsDictionary views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cutLineRightView(cutLineHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cutLineLeftView]-(<=1)-[contentMainTitleView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cutLineMiddleView]-(<=1)-[contentMainTitleView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [contentMainTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cutLineRightView]-(<=1)-[contentMainTitleView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    }
}

- (UIView *)addedCutLineViewBetweenMainTitleToView:(UIView *)contentView {
    UIView *cutLineView = [Globals addedSubViewClass:[UIView class] toView:contentView];
    
    cutLineView.backgroundColor = UIColorFromHex(0xa8a8a8);
    
    return cutLineView;
}

- (UILabel *)addedMainTitle:(NSString *)title toView:(UIView *)contentView {
    UILabel *mainTitleLabel = [Globals addedSubViewClass:[UILabel class] toView:contentView];
    
    mainTitleLabel.textColor = HB_COLOR_BASE_BLACK;
    mainTitleLabel.font = UIFontOf3XPix(87);
    mainTitleLabel.text = title;
    
    return mainTitleLabel;
}

#pragma mark - 懒加载

- (UILabel *)singleTitleLabel {
    if (!_singleTitleLabel) {
        _singleTitleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:_singleTitleLabel];
        _singleTitleLabel.textColor = HB_COLOR_BASE_BLACK;
        _singleTitleLabel.font = UIFontOf3XPix(87);
        _singleTitleLabel.numberOfLines = 0;
        _singleTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _singleTitleLabel;
}

- (UIView *)contentMainTitleView {
    if (!_contentMainTitleView) {
        _contentMainTitleView = [Globals addedSubViewClass:[UIView class] toView:self];
    }
    return _contentMainTitleView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [Globals addedSubViewClass:[UILabel class] toView:self];
        _subTitleLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        _subTitleLabel.font = UIFontOf3XPix(69);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = KString(@"随心所欲");
    }
    return _subTitleLabel;
}

@end
