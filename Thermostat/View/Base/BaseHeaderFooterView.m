//
//  BaseHeaderFooterView.m
//  Thermostat
//
//  Created by Keen on 2017/6/23.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseHeaderFooterView.h"

@interface BaseHeaderFooterView ()

@property (nonatomic, strong) UILabel *baseTitleLabel;
@property (nonatomic, strong) UILabel *baseDetailLabel;

// 分割线
@property (nonatomic, strong) UIView *baseCutLineView;


@end

@implementation BaseHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 界面更新

- (void)updateTitlePaddingLeft:(CGFloat)paddingLeft {
    [self.baseTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(paddingLeft);
    }];
}

- (void)updateDetailPaddingRight:(CGFloat)paddingRight {
    [self.baseDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-paddingRight);
    }];
}

- (void)setBaseCutLineInsets:(UIEdgeInsets)baseCutLineInsets {
    _baseCutLineInsets = baseCutLineInsets;
    
    [self.baseCutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_baseCutLineInsets.left);
        make.right.mas_equalTo(-_baseCutLineInsets.right);
    }];
}

#pragma mark - 懒加载

- (UILabel *)baseTitleLabel {
    if (!_baseTitleLabel) {
        _baseTitleLabel = [UILabel new];
        [self.contentView addSubview:_baseTitleLabel];
        _baseTitleLabel.font = [UIFont systemFontOfSize:17];
        _baseTitleLabel.textColor = [UIColor blackColor];
        
        WeakObj(self);
        [_baseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak).priorityLow();
            make.left.mas_equalTo(10);
        }];
    }
    return _baseTitleLabel;
}

- (UILabel *)baseDetailLabel {
    if (!_baseDetailLabel) {
        _baseDetailLabel = [UILabel new];
        [self.contentView addSubview:_baseDetailLabel];
        _baseDetailLabel.font = [UIFont systemFontOfSize:14];
        _baseDetailLabel.textColor = [UIColor darkGrayColor];
        [_baseDetailLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        WeakObj(self);
        [_baseDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak).priorityLow();
            make.right.mas_equalTo(-10);
            make.left.equalTo(selfWeak.baseTitleLabel.mas_right).offset(8);
        }];
    }
    return _baseDetailLabel;
}

#pragma mark - 分割线

- (UIView *)baseCutLineView {
    if (!_baseCutLineView) {
        _baseCutLineView = [UIView new];
        [self.contentView addSubview:_baseCutLineView];
        
        _baseCutLineView.backgroundColor = UIColorFromHex(0xcccccc);
        [_baseCutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0).priorityLow();
            make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT);
        }];
    }
    return _baseCutLineView;
}


@end
