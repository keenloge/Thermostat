//
//  BaseTableCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/22.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTableCell.h"

// 附件边距
const CGFloat BaseTableCellAttachPaddingLeft    = 14.0;
// 文本边距
const CGFloat BaseTableCellLabelPaddingSide     = 10.0;
// 箭头有效宽度
const CGFloat BaseTableCellArrowWidth           = 8.0;
// 箭头图片宽度
const CGFloat BaseTableCellArrowSize            = 77.0;

@interface BaseTableCell () {
    
}

// 容器界面
@property (nonatomic, strong) UIView *baseContentView;
@property (nonatomic, strong) UIView *baseAttachView;

// 右侧附加界面
@property (nonatomic, strong) UISwitch *baseSwitch;
@property (nonatomic, strong) UIImageView *baseArrowImageView;

// 主要显示界面
@property (nonatomic, strong) UIImageView *baseImageView;
@property (nonatomic, strong) UILabel *baseTitleLabel;
@property (nonatomic, strong) UILabel *baseDetailLabel;

// 分割线
@property (nonatomic, strong) UIView *baseCutLineView;

// 渐变背景
@property (nonatomic, strong) BaseTableCellGradientLayerView *backgroundLayerView;

@property (nonatomic, copy) BaseTableCellSwitchBlock baseSwitchBlock;

@end

@implementation BaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _baseAttachType = BaseTableCellAttachTypeNone;
        _baseAttachPaddingLeft = KHorizontalRound(BaseTableCellAttachPaddingLeft);
        
        [self baseInitialiseSubViews];
    }
    return self;
}

- (void)baseInitialiseSubViews {
    
}

#pragma mark - 界面更新

- (void)updateIconImageSize:(CGSize)size paddingLeft:(CGFloat)paddingLeft {
    [self.baseImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.baseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(paddingLeft).priorityHigh();
        if (size.height > 0 && size.width > 0) {
            make.size.mas_equalTo(size).priorityHigh();
        }
    }];
}

- (void)updateTitlePaddingLeft:(CGFloat)paddingLeft {
    WeakObj(self);
    [self.baseTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfWeak.baseImageView.mas_right).offset(paddingLeft).priorityHigh();
    }];
}

- (void)updateTitleInsets:(UIEdgeInsets)insets {
    [self.baseTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.baseTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    WeakObj(self);
    [self.baseTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(insets.top).priorityLow();
        make.left.equalTo(selfWeak.baseImageView.mas_right).offset(insets.left);
        make.bottom.mas_equalTo(-insets.bottom).priorityLow();
        make.right.mas_equalTo(-insets.right);
    }];
}

- (void)updateMinHeight:(CGFloat)height {
    [self.baseContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(height).priorityHigh();
    }];
}

- (void)updateDetailPaddingRight:(CGFloat)paddingRight {
    [self.baseDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-paddingRight).priorityHigh();
    }];
}


- (void)updateBaseSwitchOn:(BOOL)on switchBlock:(BaseTableCellSwitchBlock)block {
    if (self.baseAttachType == BaseTableCellAttachTypeSwitch) {
        [self.baseSwitch setOn:on];
        self.baseSwitchBlock = block;
    }
}

/**
 更新渐变背景颜色
 
 @param colors 颜色组
 @param start 起始点
 @param end 结束点
 */
- (void)updateBackgroundColors:(NSArray <UIColor *>*)colors
                    pointStart:(CGPoint)start
                      pointEnd:(CGPoint)end {
    CAGradientLayer *layer = (CAGradientLayer *)self.backgroundLayerView.layer;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [tempArray addObject:(__bridge id)color.CGColor];
    }
    layer.colors = tempArray;
    layer.startPoint = start;
    layer.endPoint = end;
}

#pragma mark - 点击事件

- (void)baseSwitchValueChanged:(UISwitch *)sender {
    if (self.baseSwitchBlock) {
        self.baseSwitchBlock(sender.isOn);
    }
}

#pragma mark - Setter

- (void)setBaseAttachType:(BaseTableCellAttachType)baseAttachType {
    _baseAttachType = baseAttachType;

    self.accessoryType = UITableViewCellAccessoryNone;
    if (_baseAttachType == BaseTableCellAttachTypeSwitch) {
        self.baseSwitch.opaque = YES;
    } else if (_baseAttachType == BaseTableCellAttachTypeArrow) {
        self.baseArrowImageView.opaque = YES;
    } else if (_baseAttachType == BaseTableCellAttachTypeNone) {
        for (UIView *subView in self.baseAttachView.subviews) {
            [subView removeFromSuperview];
        }
    } else if (_baseAttachType == BaseTableCellAttachTypeCheck) {
        for (UIView *subView in self.baseAttachView.subviews) {
            [subView removeFromSuperview];
        }
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)setBaseCutLineInsets:(UIEdgeInsets)baseCutLineInsets {
    _baseCutLineInsets = baseCutLineInsets;
    
    WeakObj(self);
    [self.baseCutLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selfWeak.baseCutLineInsets.left);
        make.right.mas_equalTo(-selfWeak.baseCutLineInsets.right);
    }];
}

- (void)setBaseAttachPaddingLeft:(CGFloat)baseAttachPaddingLeft {
    _baseAttachPaddingLeft = baseAttachPaddingLeft;
    
    UIView *tempView = nil;
    for (UIView *subView in self.baseAttachView.subviews) {
        tempView = subView;
        [subView removeFromSuperview];
    }
    if (tempView == _baseArrowImageView) {
        self.baseArrowImageView.opaque = YES;
    } else if (tempView == _baseSwitch) {
        self.baseSwitch.opaque = YES;
    }
}

#pragma mark - 懒加载

- (UIView *)baseContentView {
    if (!_baseContentView) {
        _baseContentView = [UIView new];
        [self.contentView addSubview:_baseContentView];
        
        WeakObj(self);
        [_baseContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(selfWeak.contentView);
            make.right.equalTo(selfWeak.baseAttachView.mas_left);
        }];
    }
    return _baseContentView;
}

- (UILabel *)baseTitleLabel {
    if (!_baseTitleLabel) {
        _baseTitleLabel = [UILabel new];
        [self.baseContentView addSubview:_baseTitleLabel];
        _baseTitleLabel.font = [UIFont systemFontOfSize:17];
        _baseTitleLabel.textColor = [UIColor blackColor];
        
        WeakObj(self);
        [_baseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.baseContentView).priorityLow();
            make.left.equalTo(selfWeak.baseImageView.mas_right).offset(BaseTableCellLabelPaddingSide).priorityLow();
        }];
    }
    return _baseTitleLabel;
}

- (UILabel *)baseDetailLabel {
    if (!_baseDetailLabel) {
        _baseDetailLabel = [UILabel new];
        [self.baseContentView addSubview:_baseDetailLabel];
        _baseDetailLabel.font = [UIFont systemFontOfSize:14];
        _baseDetailLabel.textColor = [UIColor darkGrayColor];
        
        WeakObj(self);
        [_baseDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.baseContentView).priorityLow();
            make.right.mas_equalTo(-BaseTableCellLabelPaddingSide).priorityLow();
        }];
    }
    return _baseDetailLabel;
}

- (UIImageView *)baseImageView {
    if (!_baseImageView) {
        _baseImageView = [UIImageView new];
        [self.baseContentView addSubview:_baseImageView];
        _baseImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        WeakObj(self);
        [_baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0).priorityLow();
            make.centerY.equalTo(selfWeak.baseContentView);
            make.width.mas_equalTo(0).priorityLow();
        }];
    }
    return _baseImageView;
}

#pragma mark - AccessoryView

- (UIView *)baseAttachView {
    if (!_baseAttachView) {
        _baseAttachView = [UIView new];
        [self.contentView addSubview:_baseAttachView];
        
        WeakObj(self);
        [_baseAttachView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(selfWeak.contentView);
            make.width.mas_equalTo(0).priorityLow();
        }];
    }
    
    return _baseAttachView;
}

- (UISwitch *)baseSwitch {
    if (!_baseSwitch) {
        _baseSwitch = [UISwitch new];
        [_baseSwitch addTarget:self action:@selector(baseSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    if (!_baseSwitch.superview) {
        for (UIView *subView in self.baseAttachView.subviews) {
            [subView removeFromSuperview];
        }
        
        [self.baseAttachView addSubview:_baseSwitch];
        WeakObj(self);
        [_baseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(selfWeak.baseAttachView);
            make.right.equalTo(selfWeak.baseAttachView).offset(-selfWeak.baseAttachPaddingLeft);
            make.width.mas_equalTo(CGRectGetWidth(selfWeak.baseSwitch.frame));
        }];
    }
    
    return _baseSwitch;
}

- (UIImageView *)baseArrowImageView {
    if (!_baseArrowImageView) {
        _baseArrowImageView = [UIImageView new];
        _baseArrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        
    }
    if (!_baseArrowImageView.superview) {
        for (UIView *subView in self.baseAttachView.subviews) {
            [subView removeFromSuperview];
        }

        [self.baseAttachView addSubview:_baseArrowImageView];
        WeakObj(self);
        [_baseArrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(BaseTableCellArrowSize, BaseTableCellArrowSize));
            make.centerY.equalTo(selfWeak.baseAttachView);
            make.left.mas_equalTo(-(BaseTableCellArrowSize - BaseTableCellArrowWidth) / 2.0);
            make.right.mas_equalTo((BaseTableCellArrowSize - BaseTableCellArrowWidth) / 2.0 - selfWeak.baseAttachPaddingLeft);
        }];
    }
    
    return _baseArrowImageView;
}

#pragma mark - 分割线

- (UIView *)baseCutLineView {
    if (!_baseCutLineView) {
        _baseCutLineView = [UIView new];
        [self addSubview:_baseCutLineView];
        
        _baseCutLineView.backgroundColor = UIColorFromHex(0xcccccc);
        [_baseCutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0).priorityLow();
            make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT);
        }];
    }
    return _baseCutLineView;
}

#pragma mark - 渐变背景
- (BaseTableCellGradientLayerView *)backgroundLayerView {
    if (!_backgroundLayerView) {
        _backgroundLayerView = [[BaseTableCellGradientLayerView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView insertSubview:_backgroundLayerView atIndex:0];
        _backgroundLayerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _backgroundLayerView;
}

@end

@implementation BaseTableCellGradientLayerView

+ (Class)layerClass{
    return [CAGradientLayer class];
}

@end

