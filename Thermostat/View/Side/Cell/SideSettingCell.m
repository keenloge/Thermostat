//
//  SideSettingCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideSettingCell.h"

@interface SideSettingCell ()

@property (nonatomic, strong) UILabel *settingLabel;
@property (nonatomic, strong) UIView *cutLineView;

@end

@implementation SideSettingCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    
    self.settingLabel.opaque = YES;
}


#pragma mark - Setter

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    self.settingLabel.text = _titleString;
}

- (void)setLineOffset:(CGFloat)lineOffset {
    _lineOffset = lineOffset;
    
    [self.cutLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_lineOffset);
    }];
}

#pragma mark - 懒加载

- (UILabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [UILabel new];
        [self.contentView addSubview:_settingLabel];
        
        _settingLabel.textColor = HB_COLOR_BASE_BLACK;
        _settingLabel.alpha = 0.85;
        _settingLabel.font = UIFontOf1XPix(17);
        
        WeakObj(self);
        [_settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    
    return _settingLabel;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [UIView new];
        [self addSubview:_cutLineView];
        
        _cutLineView.backgroundColor = UIColorFromHex(0xd6d5d9);
        
        [_cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.67);
        }];
    }
    return _cutLineView;
}

@end
