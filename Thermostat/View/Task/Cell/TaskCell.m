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

const CGFloat KTaskCellCutLineOffsetYScale = 444.0 / 1242.0;


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
        repeatDictionary = @{NSFontAttributeName : UIFontOf3XPix(KHorizontalRound(39)),
                             NSParagraphStyleAttributeName : paragraphStyle,
                             NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};
        settingDictionary = @{NSFontAttributeName : UIFontOf3XPix(KHorizontalRound(34)),
                              NSParagraphStyleAttributeName : paragraphStyle,
                              NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};

        self.iconImageView.opaque = YES;
        self.timeLabel.opaque = YES;
        self.toLabel.opaque = YES;
        self.cutLineView.opaque = YES;
        self.planLabel.opaque = YES;
        self.validSwitch.opaque = YES;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.cutLineView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.2);
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
        self.timeLabel.font = UIFontOf3XPix(KHorizontalRound(63));
        self.toLabel.hidden = YES;
        self.timeLabel.text = [Globals timeString:task.timeFrom];
    } else if (task.type == TaskTypeStage) {
        // 起止时间
        self.timeLabel.font = UIFontOf3XPix(KHorizontalRound(54));
        self.toLabel.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", [Globals timeString:task.timeFrom], [Globals timeString:task.timeTo]];
        [self.timeLabel changeLineSpace:3];
    }
}

- (void)updatePlanLabelWithTask:(Task *)task {

    // 周期
    NSString *repeatString = [Globals repeatString:task.repeat];
    
    NSString *settingString = nil;
    if (task.type == TaskTypeSwitch && task.running == RunningStateOFF) {
        settingString = KString(@"关");
    } else {
        // 设定
        NSMutableArray *settingArray = [NSMutableArray array];
        if (task.mode != LinKonModeAir) {
            // 非换气, 才有温度
            [settingArray addObject:[Globals settingString:task.setting]];
        }
        [settingArray addObject:[Globals windString:task.wind]];
        [settingArray addObject:[Globals modeString:task.mode]];
        [settingArray addObject:[Globals sceneString:task.scene]];
        settingString = [settingArray componentsJoinedByString:@" "];
    }

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
        _iconImageView = [UIImageView new];
        [self.contentView addSubview:_iconImageView];
        
        CGFloat iconSize = 24;
        
        WeakObj(self);
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.contentView).offset(KHorizontalRound(14));
            make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _iconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [self.contentView addSubview:_timeLabel];

        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        WeakObj(self);
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.iconImageView.mas_right);
            make.right.equalTo(selfWeak.toLabel.mas_centerX);
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _timeLabel;
}

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [UILabel new];
        [self.contentView addSubview:_toLabel];
        
        _toLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        _toLabel.font = UIFontOf3XPix(KHorizontalRound(48));
        _toLabel.text = KString(@"至");
        
        WeakObj(self);
        [_toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(selfWeak.cutLineView.mas_left).offset(-KHorizontalRound(15));
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _toLabel;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [UIView new];
        [self.contentView addSubview:_cutLineView];
        
        _cutLineView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.2);
        
        WeakObj(self);
        [_cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.contentView).offset(MAIN_SCREEN_WIDTH * KTaskCellCutLineOffsetYScale);
            make.size.mas_equalTo(CGSizeMake(1, 33));
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _cutLineView;
}

- (UILabel *)planLabel {
    if (!_planLabel) {
        _planLabel = [UILabel new];
        [self.contentView addSubview:_planLabel];
        
        _planLabel.numberOfLines = 0;
        _planLabel.font = UIFontOf3XPix(36);
        _planLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        
        WeakObj(self);
        [_planLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.cutLineView.mas_right).offset(KHorizontalRound(10));
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _planLabel;
}

- (UISwitch *)validSwitch {
    if (!_validSwitch) {
        _validSwitch = [UISwitch new];
        [self.contentView addSubview:_validSwitch];
        
        [_validSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        WeakObj(self);
        [_validSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CGRectGetWidth(selfWeak.validSwitch.frame));
            make.left.greaterThanOrEqualTo(selfWeak.planLabel.mas_right).offset(8).priorityHigh();
            make.right.equalTo(selfWeak.contentView).offset(-KHorizontalRound(14));
            make.centerY.equalTo(selfWeak.contentView);
        }];
    }
    return _validSwitch;
}


@end
