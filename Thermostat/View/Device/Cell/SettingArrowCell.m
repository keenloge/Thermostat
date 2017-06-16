//
//  SettingArrowCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/2.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SettingArrowCell.h"
#import "Globals.h"
#import "ColorConfig.h"

@interface SettingArrowCell () {

}

@property (nonatomic, strong) UIImageView *iconArrowImageView;

@end

@implementation SettingArrowCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iconArrowImageView = self.iconArrowImageView;
        
        UIView *superContentView = self.contentView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(iconArrowImageView, superContentView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superContentView]-(<=-1)-[iconArrowImageView(77)]-(-21)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
        [iconArrowImageView addConstraint:[NSLayoutConstraint constraintWithItem:iconArrowImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:iconArrowImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
    return self;
}

#pragma mark - 懒加载

- (UIImageView *)iconArrowImageView {
    if (!_iconArrowImageView) {
        _iconArrowImageView = [Globals addedSubViewClass:[UIImageView class] toView:self.contentView];
        _iconArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconArrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        _iconArrowImageView.tintColor = HB_COLOR_BASE_MAIN;
    }
    return _iconArrowImageView;
}

@end

