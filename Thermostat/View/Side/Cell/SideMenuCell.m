//
//  SideMenuCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideMenuCell.h"
#import "BaseGradientLayerView.h"

const CGFloat KSideMenuCellPaddingLeft  = 19.0;
const CGFloat KSideMenuCellOffsetX      = 19.0;
const CGFloat KSideMenuCellIconSize     = 18.0;

@interface SideMenuCell ()

@property (nonatomic, strong) BaseGradientLayerView *backgroundLayerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation SideMenuCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInitialiseSubViews {
    self.backgroundLayerView.opaque = YES;
    self.iconImageView.opaque = YES;
    self.mainTitleLabel.opaque = YES;
    self.arrowImageView.opaque = YES;
}

#pragma mark - Setter

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    
    self.iconImageView.image = _iconImage;
}

- (void)setMainTitle:(NSString *)mainTitle {
    _mainTitle = mainTitle;
    
    self.mainTitleLabel.text = _mainTitle;
}

#pragma mark - 懒加载

- (BaseGradientLayerView *)backgroundLayerView {
    if (!_backgroundLayerView) {
        _backgroundLayerView = [[BaseGradientLayerView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_backgroundLayerView];
        _backgroundLayerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        CAGradientLayer *layer = (CAGradientLayer *)_backgroundLayerView.layer;
        layer.colors = @[(__bridge id)UIColorFromHex(0x4b4b4b).CGColor, (__bridge id)UIColorFromHex(0x3c3c3c).CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1.0);
    }
    return _backgroundLayerView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.contentView addSubview:_iconImageView];
        CGFloat iconSize = KSideMenuCellIconSize;

        _iconImageView.layer.cornerRadius = iconSize / 2.0;
        _iconImageView.clipsToBounds = YES;
        
        WeakObj(self);
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.contentView);
            make.left.mas_equalTo(KHorizontalRound(KSideMenuCellPaddingLeft));
            make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        }];
    }
    return _iconImageView;
}

- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        _mainTitleLabel = [UILabel new];
        [self.contentView addSubview:_mainTitleLabel];
        
        _mainTitleLabel.textColor = HB_COLOR_BASE_WHITE;
        _mainTitleLabel.font = UIFontOf3XPix(51);
        
        WeakObj(self);
        [_mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.iconImageView);
            make.left.equalTo(selfWeak.iconImageView.mas_right).offset(KHorizontalRound(KSideMenuCellOffsetX));
        }];
    }
    return _mainTitleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        [self.contentView addSubview:_arrowImageView];
        
        _arrowImageView.tintColor = HB_COLOR_BASE_WHITE;
        _arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        
        WeakObj(self);
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.contentView);
            CGFloat arrowSize = 77.0;
            make.size.mas_equalTo(CGSizeMake(arrowSize, arrowSize));
            make.right.mas_equalTo(14);
        }];
    }
    return _arrowImageView;
}

@end
