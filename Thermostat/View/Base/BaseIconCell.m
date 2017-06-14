//
//  BaseIconCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/2.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseIconCell.h"
#import "Declare.h"
#import "ColorConfig.h"
#import "Globals.h"

// 左边距
const CGFloat BaseIconCellPaddingLeft   = 10.0;
// 图标大小
const CGFloat BaseIconCellIconSize      = 36.0;
// 图标与文本间距
const CGFloat BaseIconCellOffsetX       = 10.0;

@interface BaseIconCell () {

}

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *iconTitleLabel;

@end

@implementation BaseIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconImageView = self.iconImageView;
        UILabel *iconTitleLabel = self.iconTitleLabel;
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(iconImageView, iconTitleLabel);
        
        NSDictionary *metricsDictionary = @{
                                            @"paddingLeft" : @(BaseIconCellPaddingLeft),
                                            @"iconSize" : @(BaseIconCellIconSize),
                                            @"offsetX" : @(BaseIconCellOffsetX),
                                            };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingLeft-[iconImageView(iconSize)]-offsetX-[iconTitleLabel]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconImageView]|" options:0 metrics:nil views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconTitleLabel]|" options:0 metrics:nil views:viewsDictionary]];
    }
    return self;
}

#pragma mark - Setter

- (void)setIconImage:(UIImage *)image {
    _iconImage = image;
    
    self.iconImageView.image = _iconImage;
}

- (void)setIconTitle:(NSString *)iconTitle {
    _iconTitle = iconTitle;
    
    self.iconTitleLabel.text = _iconTitle;
}

#pragma mark - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [Globals addedSubViewClass:[UIImageView class] toView:self.contentView];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)iconTitleLabel {
    if (!_iconTitleLabel) {
        _iconTitleLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _iconTitleLabel.textColor = HB_COLOR_BASE_BLACK;
        _iconTitleLabel.font = UIFontOf3XPix(65);
    }
    return _iconTitleLabel;
}

@end

