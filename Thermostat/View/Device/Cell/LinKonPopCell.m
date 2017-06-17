//
//  LinKonPopCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonPopCell.h"

@interface LinKonPopCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel* nameLabel;

@end

@implementation LinKonPopCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.85);
}

#pragma mark - 懒加载

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    
    self.iconImageView.image = _iconImage;
}

- (void)setNameString:(NSString *)nameString {
    _nameString = nameString;
    
    self.nameLabel.text = _nameString;
}

#pragma mark - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.contentView addSubview:_iconImageView];
        
        WeakObj(self);
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.contentView);
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.left.mas_equalTo(14);
        }];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        
        _nameLabel.textColor = HB_COLOR_BASE_WHITE;
        _nameLabel.font = UIFontOf3XPix(54);
        _nameLabel.numberOfLines = 0;
        
        WeakObj(self);
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selfWeak.contentView);
            make.left.equalTo(selfWeak.iconImageView.mas_right).offset(12);
            make.top.mas_greaterThanOrEqualTo(14);
            make.width.mas_equalTo(106);
        }];
    }
    return _nameLabel;
}

@end
