//
//  TaskCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskCell.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"
#import "UILabelAdditions.h"
#import "TaskManager.h"
#import "Task.h"

@interface TaskCell () {
    CGFloat lineSpace;  // 行间距, 起止时间行间距, 任务计划周期与设置行间距
    NSDictionary *repeatDictionary;
    NSDictionary *settingDictionary;
}

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) UIView *cutLineView;
@property (nonatomic, strong) UILabel *planLabel;
@property (nonatomic, strong) UISwitch *validSwitch;


@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        lineSpace = 8.0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        repeatDictionary = @{NSFontAttributeName : UIFontOf3XPix(48),
                             NSParagraphStyleAttributeName : paragraphStyle,
                             NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};
        settingDictionary = @{NSFontAttributeName : UIFontOf3XPix(36),
                              NSParagraphStyleAttributeName : paragraphStyle,
                              NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};
        
        UIImageView *iconImageView = self.iconImageView;
        UILabel *timeLabel = self.timeLabel;
        UILabel *toLabel = self.toLabel;
        UIView *cutLineView = self.cutLineView;
        UILabel *planLabel = self.planLabel;
        UISwitch *validSwitch = self.validSwitch;
        UIView *superContentView = self.contentView;
        
        NSDictionary *metricsDictionary = @{
                                            @"paddingLeft" : @(14),
                                            @"paddingRight" : @(14),
                                            @"iconSize" : @(24),
                                            @"timeWidth" : @(45),
                                            @"lineWidth" : @(1),
                                            @"lineHeight" : @(33),
                                            @"offsetX" : @(8),
                                            @"switchWidth" : @(CGRectGetWidth(validSwitch.frame)),
                                            };
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(iconImageView, timeLabel, toLabel, cutLineView, planLabel, validSwitch, superContentView);

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingLeft-[iconImageView(iconSize)]-offsetX-[timeLabel(timeWidth)][toLabel]-offsetX-[cutLineView(lineWidth)]-offsetX-[planLabel]-(<=1)-[superContentView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superContentView]-(<=1)-[validSwitch(switchWidth)]-paddingRight-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[planLabel]-(>=offsetX)-[validSwitch(switchWidth)]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconImageView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[timeLabel]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toLabel]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cutLineView(lineHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[planLabel]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    }
    return self;
}

#pragma mark - 界面刷新

- (void)updateIconImageViewWithTask:(Task *)task {
    NSString *imageName = nil;
    if (task.validate) {
        self.timeLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.85);
        if (task.type == TaskTypeSwitch) {
            imageName = @"cell_switch_on";
        } else if (task.type == TaskTypeStage) {
            imageName = @"cell_stage_on";
        }
    } else {
        self.timeLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        if (task.type == TaskTypeSwitch) {
            imageName = @"cell_switch_off";
        } else if (task.type == TaskTypeStage) {
            imageName = @"cell_stage_off";
        }
    }
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.validSwitch.on = task.validate;
}

- (void)updateTimeLabelWithTask:(Task *)task {
    if (task.type == TaskTypeSwitch) {
        // 开关时间
        self.timeLabel.font = UIFontOf3XPix(63);
        self.toLabel.hidden = YES;
        self.timeLabel.text = [Globals timeString:task.timeFrom];
    } else if (task.type == TaskTypeStage) {
        // 起止时间
        self.timeLabel.font = UIFontOf3XPix(54);
        self.toLabel.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", [Globals timeString:task.timeFrom], [Globals timeString:task.timeTo]];
        [self.timeLabel changeLineSpace:lineSpace];
    }
}

- (void)updatePlanLabelWithTask:(Task *)task {

    // 周期
    NSString *repeatString = [Globals repeatString:task.repeat];
    
    // 设定
    NSMutableArray *settingArray = [NSMutableArray array];
    if (task.mode != LinKonModeAir) {
        // 非换气, 才有温度
        [settingArray addObject:[Globals settingString:task.setting]];
    }
    [settingArray addObject:[Globals windString:task.wind]];
    [settingArray addObject:[Globals modeString:task.mode]];
    [settingArray addObject:[Globals sceneString:task.scene]];
    NSString *settingString = [settingArray componentsJoinedByString:@" "];

    if (repeatString.length > 0) {
        NSAttributedString *repeatAttributedString = [[NSAttributedString alloc] initWithString:repeatString attributes:repeatDictionary];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

        [attributedString appendAttributedString:repeatAttributedString];
        settingString = [NSString stringWithFormat:@"\n%@", settingString];
        NSAttributedString *settingAttributedString = [[NSAttributedString alloc] initWithString:settingString attributes:settingDictionary];
        [attributedString appendAttributedString:settingAttributedString];
        
        self.planLabel.attributedText = attributedString;
    } else {
        self.planLabel.attributedText = nil;
        self.planLabel.text = settingString;
    }
}

#pragma mark - 点击事件

- (void)switchValueChanged:(UISwitch *)sender {
    [[TaskManager sharedManager] editTask:self.task.number device:self.task.sn key:KTaskValidate value:@(sender.isOn)];
}

#pragma mark - Setter

- (void)setTask:(Task *)task {
    _task = task;
    
    WeakObj(self);
    [[TaskManager sharedManager] registerListener:self task:task.number device:task.sn key:KTaskValidate block:^(NSObject *object) {
        Task *task = (Task *)object;
        [selfWeak updateIconImageViewWithTask:task];
    }];
    
    [self updateTimeLabelWithTask:task];
    [self updatePlanLabelWithTask:task];
}

#pragma mark - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [Globals addedSubViewClass:[UIImageView class] toView:self.contentView];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _timeLabel.font = UIFontOf3XPix(54);
        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _toLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        _toLabel.font = UIFontOf3XPix(48);
        _toLabel.text = KString(@"至");
    }
    return _toLabel;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [Globals addedSubViewClass:[UIView class] toView:self.contentView];
        _cutLineView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.2);
    }
    return _cutLineView;
}

- (UILabel *)planLabel {
    if (!_planLabel) {
        _planLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _planLabel.numberOfLines = 0;
        _planLabel.font = UIFontOf3XPix(36);
        _planLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
    }
    return _planLabel;
}

- (UISwitch *)validSwitch {
    if (!_validSwitch) {
        _validSwitch = [Globals addedSubViewClass:[UISwitch class] toView:self.contentView];
        [_validSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _validSwitch;
}


@end
