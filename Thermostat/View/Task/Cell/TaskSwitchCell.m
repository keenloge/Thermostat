//
//  TaskSwitchCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskSwitchCell.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"

@interface TaskSwitchCell () {

}

@property (nonatomic, strong) UILabel *taskTitleLabel;
@property (nonatomic, strong) UISwitch *iconSwitch;

@end

@implementation TaskSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *taskTitleLabel = self.taskTitleLabel;
        UISwitch *iconSwitch = self.iconSwitch;
        UIView *superContentView = self.contentView;
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(taskTitleLabel, iconSwitch, superContentView);
        NSDictionary *metricsDictionary = @{
                                            @"paddingLeft" : @(15),
                                            @"paddingRight" : @(14),
                                            };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingLeft-[taskTitleLabel]-(<=1)-[superContentView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superContentView]-(<=1)-[iconSwitch]-paddingRight-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        
    }
    return self;
}

#pragma mark - 点击事件

- (void)switchValueChanged:(UISwitch *)sender {
    if (self.block) {
        self.block(sender.isOn);
    }
}

#pragma mark - Setter

- (void)setOpen:(BOOL)open {
    _open = open;
    
    self.iconSwitch.on = _open;
}

#pragma mark - 懒加载

- (UILabel *)taskTitleLabel {
    if (!_taskTitleLabel) {
        _taskTitleLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _taskTitleLabel.font = UIFontOf3XPix(51);
        _taskTitleLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.85);
        _taskTitleLabel.text = KString(@"开关");
    }
    return _taskTitleLabel;
}

- (UISwitch *)iconSwitch {
    if (!_iconSwitch) {
        _iconSwitch = [Globals addedSubViewClass:[UISwitch class] toView:self.contentView];
        [_iconSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _iconSwitch;
}

@end
