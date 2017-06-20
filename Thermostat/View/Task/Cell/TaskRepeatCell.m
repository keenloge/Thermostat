//
//  TaskRepeatCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskRepeatCell.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"
#import "UIImageAdditions.h"

@interface TaskRepeatCell () {
    CGFloat buttonSize;
    CGFloat buttonOffsetX;
    CGFloat buttonOffsetY;
    CGFloat buttonPaddingTop;
    CGFloat buttonPaddingRight;
}

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIView *buttonContentView;
@property (nonatomic, strong) UILabel *taskTitleLabel;
@property (nonatomic, strong) UIButton *mondayButton;
@property (nonatomic, strong) UIButton *tuesdayButton;
@property (nonatomic, strong) UIButton *wednesdayButton;
@property (nonatomic, strong) UIButton *thursdayButton;
@property (nonatomic, strong) UIButton *fridayButton;
@property (nonatomic, strong) UIButton *saturdayButton;
@property (nonatomic, strong) UIButton *sundayButton;
@property (nonatomic, strong) UIButton *allDayButton;

@end

@implementation TaskRepeatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        buttonSize = 34.0;
        buttonOffsetX = 20.0;
        buttonOffsetY = 8.0;
        
        UIView *buttonContentView = self.buttonContentView;
        UILabel *taskTitleLabel = self.taskTitleLabel;
        
        UIView *superContentView = self.contentView;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(taskTitleLabel, buttonContentView, superContentView);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[taskTitleLabel]" options:0 metrics:nil views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[taskTitleLabel]" options:0 metrics:nil views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superContentView]-(<=1)-[buttonContentView]-14-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
        
        UIButton *mondayButton = self.mondayButton;
        UIButton *tuesdayButton = self.tuesdayButton;
        UIButton *wednesdayButton = self.wednesdayButton;
        UIButton *thursdayButton = self.thursdayButton;
        UIButton *fridayButton = self.fridayButton;
        UIButton *saturdayButton = self.saturdayButton;
        UIButton *sundayButton = self.sundayButton;
        UIButton *allDayButton = self.allDayButton;

        
        NSDictionary *metricsDictionary = @{
                                            @"buttonSize" : @(buttonSize),
                                            @"buttonOffsetX" : @(buttonOffsetX),
                                            @"buttonOffsetY" : @(buttonOffsetY)
                                            };
        viewsDictionary = NSDictionaryOfVariableBindings(mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton, allDayButton);
        
        [buttonContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mondayButton(buttonSize)]-buttonOffsetX-[tuesdayButton(mondayButton)]-buttonOffsetX-[wednesdayButton(mondayButton)]-buttonOffsetX-[thursdayButton(mondayButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        
        [buttonContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fridayButton(mondayButton)]-buttonOffsetX-[saturdayButton(mondayButton)]-buttonOffsetX-[sundayButton(mondayButton)]-buttonOffsetX-[allDayButton(mondayButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        
        [buttonContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mondayButton(buttonSize)]-buttonOffsetY-[fridayButton(mondayButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        
        [buttonContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tuesdayButton(buttonSize)]-buttonOffsetY-[saturdayButton(mondayButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [buttonContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wednesdayButton(buttonSize)]-buttonOffsetY-[sundayButton(mondayButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [buttonContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[thursdayButton(buttonSize)]-buttonOffsetY-[allDayButton(mondayButton)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        
        UIView *cutLineBottomView = [UIView new];
        [self.contentView addSubview:cutLineBottomView];
        
        cutLineBottomView.backgroundColor = UIColorFromHex(0xd6d5d9);
        
        [cutLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.67);
        }];
    }
    return self;
}

- (UIButton *)addedRepeatButtonWithTag:(NSInteger)tag {
    UIButton *button = [Globals addedSubViewClass:[UIButton class] toView:self.buttonContentView];
    button.tag = tag;
    
    [button setTitle:[Globals weekString:tag] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageWithColor:HB_COLOR_BASE_MAIN] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xe5e5e5)] forState:UIControlStateNormal];
    [button setTitleColor:HB_COLOR_BASE_WHITE forState:UIControlStateSelected];
    [button setTitleColor:UIColorFromRGBA(0, 0, 0, 0.6) forState:UIControlStateNormal];
    button.titleLabel.font = UIFontOf3XPix(39);
    button.layer.cornerRadius = buttonSize / 2.0;
    button.clipsToBounds = YES;
    
    [self.buttonArray addObject:button];
    
    return button;
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    Byte repeat = sender.tag;
    if (sender.tag == TimerRepeatEveryDay) {
        if (sender.isSelected) {
            repeat = TimerRepeatNone;
        } else {
            repeat = TimerRepeatEveryDay;
        }
    } else {
        if (sender.isSelected) {
            repeat = (~repeat) & self.repeat;
        } else {
            repeat = repeat | self.repeat;
        }
    }
    
    self.repeat = repeat;
    
    if (self.block) {
        self.block(repeat);
    }
}

#pragma mark - Setter

- (void)setRepeat:(Byte)repeat {
    _repeat = repeat;
    
    for (UIButton *button in self.buttonArray) {
        button.selected = (button.tag & repeat) == button.tag;
    }
}

#pragma mark - Getter

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

#pragma mark - 懒加载

- (UIView *)buttonContentView {
    if (!_buttonContentView) {
        _buttonContentView = [Globals addedSubViewClass:[UIView class] toView:self.contentView];
    }
    return _buttonContentView;
}

- (UILabel *)taskTitleLabel {
    if (!_taskTitleLabel) {
        _taskTitleLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _taskTitleLabel.text = KString(@"重复");
        _taskTitleLabel.font = UIFontOf3XPix(51);
        _taskTitleLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.85);
    }
    return _taskTitleLabel;
}

- (UIButton *)mondayButton {
    if (!_mondayButton) {
        _mondayButton    = [self addedRepeatButtonWithTag:TimerRepeatMonday];
    }
    return _mondayButton;
}

- (UIButton *)tuesdayButton {
    if (!_tuesdayButton) {
        _tuesdayButton   = [self addedRepeatButtonWithTag:TimerRepeatTuesday];
    }
    return _tuesdayButton;
}

- (UIButton *)wednesdayButton {
    if (!_wednesdayButton) {
        _wednesdayButton = [self addedRepeatButtonWithTag:TimerRepeatWednesday];
    }
    return _wednesdayButton;
}

- (UIButton *)thursdayButton {
    if (!_thursdayButton) {
        _thursdayButton  = [self addedRepeatButtonWithTag:TimerRepeatThursday];
    }
    return _thursdayButton;
}

- (UIButton *)fridayButton {
    if (!_fridayButton) {
        _fridayButton    = [self addedRepeatButtonWithTag:TimerRepeatFriday];
    }
    return _fridayButton;
}

- (UIButton *)saturdayButton {
    if (!_saturdayButton) {
        _saturdayButton  = [self addedRepeatButtonWithTag:TimerRepeatSaturday];
    }
    return _saturdayButton;
}

- (UIButton *)sundayButton {
    if (!_sundayButton) {
        _sundayButton    = [self addedRepeatButtonWithTag:TimerRepeatSunday];
    }
    return _sundayButton;
}

- (UIButton *)allDayButton {
    if (!_allDayButton) {
        _allDayButton    = [self addedRepeatButtonWithTag:TimerRepeatEveryDay];
    }
    return _allDayButton;
}

@end
