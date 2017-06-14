//
//  BasePickerPage.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BasePickerPage.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "Globals.h"

const CGFloat BasePickerTitleHeight = 44.0;
const CGFloat BasePickerButtonHeight = 44.0;
const CGFloat BasePickerCheckHeight = 177.0;
const CGFloat BasePickerOffset = 1.0;

@interface BasePickerPage () <UIPickerViewDataSource, UIPickerViewDelegate> {
    BOOL hasShowCutLine;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *cutLineView;

@end

@implementation BasePickerPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 数据更新

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = _titleString;
}

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    UIView *contentView = self.contentView;
    UILabel *titleLabel = self.titleLabel;
    UIPickerView *checkPickerView = self.checkPickerView;
    UIButton *confirmButton = self.confirmButton;
    UIButton *cancelButton = self.cancelButton;
    UIView *topLineView = self.topLineView;
    UIView *bottomLineView = self.bottomLineView;
    UIView *cutLineView = self.cutLineView;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(contentView, titleLabel, checkPickerView, confirmButton, cancelButton, topLineView, bottomLineView, cutLineView);
    NSDictionary *metricsDictionary = @{
                                        @"titleHeight" : @(BasePickerTitleHeight),
                                        @"buttonHeight" : @(BasePickerButtonHeight),
                                        @"checkHeight" : @(BasePickerCheckHeight),
                                        @"offset" : @(BasePickerOffset),
                                        };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView]|" options:0 metrics:nil views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:nil views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLineView]|" options:0 metrics:nil views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLineView]|" options:0 metrics:nil views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[checkPickerView]|" options:0 metrics:nil views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cancelButton][cutLineView(offset)][confirmButton(cancelButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel(titleHeight)][topLineView(offset)][checkPickerView(checkHeight)][bottomLineView(offset)][cancelButton(buttonHeight)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLineView][confirmButton]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLineView][cutLineView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view setNeedsLayout];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return MAIN_SCREEN_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    // 显示分割线
    if (!hasShowCutLine) {
        hasShowCutLine = YES;
        for(UIView *speartorView in pickerView.subviews) {
            if (speartorView.frame.size.height < 1) {
                speartorView.backgroundColor = UIColorFromHex(0xcccccc);
            }
        }
    }
    
    UILabel *showLabel = (UILabel *)view;
    if (!showLabel) {
        CGFloat componentWidth = [self pickerView:pickerView widthForComponent:component];
        CGFloat rowHeight = [self pickerView:pickerView rowHeightForComponent:component];
        showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, componentWidth, rowHeight)];
        showLabel.textAlignment = NSTextAlignmentCenter;
        showLabel.backgroundColor = HB_COLOR_BASE_WHITE;
        showLabel.textColor = HB_COLOR_BASE_BLACK;
        showLabel.font = UIFontOf3XPix(70);
    }
    
    showLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return showLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    if (sender == self.cancelButton) {
        [self baseBack];
    } else if (sender == self.confirmButton) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
        [self baseBack];
    }
}

#pragma mark - 懒加载

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [Globals addedSubViewClass:[UIView class] toView:self.view];
        _contentView.backgroundColor = HB_COLOR_BASE_WHITE;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _titleLabel.backgroundColor = HB_COLOR_BASE_WHITE;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromHex(0x858585);
        _titleLabel.font = UIFontOf3XPix(51);
        _titleLabel.text = self.titleString;
    }
    return _titleLabel;
}

- (UIPickerView *)checkPickerView {
    if (!_checkPickerView) {
        _checkPickerView = [Globals addedSubViewClass:[UIPickerView class] toView:self.contentView];
        _checkPickerView.backgroundColor = HB_COLOR_BASE_WHITE;
        _checkPickerView.dataSource = self;
        _checkPickerView.delegate = self;
        _checkPickerView.showsSelectionIndicator = NO;
    }
    return _checkPickerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [Globals addedSubViewClass:[UIButton class] toView:self.contentView];
        _cancelButton.backgroundColor = HB_COLOR_BASE_WHITE;
        [_cancelButton setTitle:KString(@"取消") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HB_COLOR_BASE_MAIN forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = UIFontOf3XPix(54);
        [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [Globals addedSubViewClass:[UIButton class] toView:self.contentView];
        _confirmButton.backgroundColor = HB_COLOR_BASE_WHITE;
        [_confirmButton setTitle:KString(@"确定") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HB_COLOR_BASE_MAIN forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = UIFontOf3XPix(54);
        [_confirmButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentView];
        _topLineView.backgroundColor = UIColorFromHex(0xcccccc);
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentView];
        _bottomLineView.backgroundColor = UIColorFromHex(0xcccccc);
    }
    return _bottomLineView;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentView];
        _cutLineView.backgroundColor = UIColorFromHex(0xcccccc);
    }
    return _cutLineView;
}

@end
