//
//  SettingFooterView.m
//  Thermostat
//
//  Created by Keen on 2017/6/2.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SettingFooterView.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"

const CGFloat SettingFooterIntroduceLabelOffsetX = 15.0;
const CGFloat SettingFooterDetailButtonWidth = 80.0;

@interface SettingFooterView () {

}

@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIButton *detailButton;

@end

@implementation SettingFooterView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorFromHex(0xf2f2f2);
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIView *contentView = self.contentView;
        UILabel *introduceLabel = self.introduceLabel;
        UIButton *detailButton = self.detailButton;
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(contentView, introduceLabel, detailButton);
        NSDictionary *metricsDictionary = @{
                                            @"offSetX":@(SettingFooterIntroduceLabelOffsetX),
                                            @"buttonWidth" : @(SettingFooterDetailButtonWidth)
                                            };
        // 对 contentView 进行布局, 是为了解决 iOS 8 的警告.
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-offSetX-[introduceLabel]-(>=offSetX)-[detailButton(buttonWidth)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[introduceLabel]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailButton]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    }
    return self;
}

#pragma mark - Setter

- (void)setIntroduce:(NSString *)value {
    _introduce = value;
    
    self.introduceLabel.text = _introduce;
}

#pragma mark - 懒加载

- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        _introduceLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _introduceLabel.font = UIFontOf3XPix(45);
        _introduceLabel.textColor = HB_COLOR_BASE_GRAY;
        _introduceLabel.numberOfLines = 0;
    }
    return _introduceLabel;
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [Globals addedSubViewClass:[UIButton class] toView:self.contentView];
        [_detailButton setTitleColor:HB_COLOR_BASE_MAIN forState:UIControlStateNormal];
        [_detailButton setTitle:KString(@"了解详情") forState:UIControlStateNormal];
        _detailButton.titleLabel.font = UIFontOf3XPix(45);
    }
    return _detailButton;
}

@end
