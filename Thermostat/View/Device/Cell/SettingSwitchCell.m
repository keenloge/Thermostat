//
//  SettingSwitchCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/2.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SettingSwitchCell.h"
#import "Globals.h"

@interface SettingSwitchCell () {

}

@property (nonatomic, strong) UISwitch *iconSwitch;

@end

@implementation SettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UISwitch *iconSwitch = self.iconSwitch;
        UIView *superContentView = self.contentView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(iconSwitch, superContentView);
        
        NSDictionary *metricsDictionary = @{
                                            @"paddingRight" : @(14),
                                            };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superContentView]-(<=1)-[iconSwitch]-paddingRight-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    }
    return self;
}

#pragma mark - 懒加载

- (UISwitch *)iconSwitch {
    if (!_iconSwitch) {
        _iconSwitch = [Globals addedSubViewClass:[UISwitch class] toView:self.contentView];
    }
    return _iconSwitch;
}

@end

