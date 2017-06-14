//
//  TaskPickCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskPickCell.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"

@interface TaskPickCell () {

}

@property (nonatomic, strong) UILabel *taskTitleLabel;
@property (nonatomic, strong) UILabel *taskDetailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation TaskPickCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *taskTitleLabel = self.taskTitleLabel;
        UILabel *taskDetailLabel = self.taskDetailLabel;
        UIImageView *arrowImageView = self.arrowImageView;
        UIView *superContentView = self.contentView;
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(taskTitleLabel, taskDetailLabel, arrowImageView, superContentView);
        
        NSDictionary *metricsDictionary = @{
                                            @"paddingLeft" : @(15),
                                            };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingLeft-[taskTitleLabel]-(<=1)-[superContentView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superContentView]-(<=1)-[taskDetailLabel][arrowImageView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[arrowImageView]|" options:0 metrics:nil views:viewsDictionary]];
        [arrowImageView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:arrowImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    
    self.taskTitleLabel.text = _titleString;
}

- (void)setDetailString:(NSString *)detailString {
    _detailString = detailString;
    
    self.taskDetailLabel.text = _detailString;
}

#pragma mark - 懒加载

- (UILabel *)taskTitleLabel {
    if (!_taskTitleLabel) {
        _taskTitleLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _taskTitleLabel.font = UIFontOf3XPix(51);
        _taskTitleLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.85);
    }
    return _taskTitleLabel;
}

- (UILabel *)taskDetailLabel {
    if (!_taskDetailLabel) {
        _taskDetailLabel = [Globals addedSubViewClass:[UILabel class] toView:self.contentView];
        _taskDetailLabel.font = UIFontOf3XPix(42);
        _taskDetailLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.62);
    }
    return _taskDetailLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [Globals addedSubViewClass:[UIImageView class] toView:self.contentView];
        _arrowImageView.image = [UIImage imageNamed:@"cell_arrow"];
        _arrowImageView.tintColor = UIColorFromHex(0xc7c7cc);
    }
    return _arrowImageView;
}

@end
