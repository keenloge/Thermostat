//
//  TaskCell.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskCell.h"
#import "Globals.h"
#import "UILabelAdditions.h"

const CGFloat KTaskCellCutLineOffsetYScale = 444.0 / 1242.0;


@interface TaskCell () {
    CGFloat lineSpace;  // 行间距, 起止时间行间距, 任务计划周期与设置行间距
    NSDictionary *repeatDictionary;
    NSDictionary *settingDictionary;
}

@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) UIView *cutLineView;

@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 右侧开关
        self.baseAttachType = BaseTableCellAttachTypeSwitch;
        
        // 图片大小与边距
        [self updateIconImageSize:CGSizeMake(24, 24) paddingLeft:KHorizontalRound(14)];
        
        // 标题
        self.baseTitleLabel.numberOfLines = 0;
        self.baseTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self updateTitlePaddingLeft:0];
        WeakObj(self);
        [self.baseTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(selfWeak.toLabel.mas_centerX).priorityHigh();
        }];
        
        // 内容
        self.baseDetailLabel.numberOfLines = 0;
        self.baseDetailLabel.textAlignment = NSTextAlignmentLeft;
        self.baseDetailLabel.font = UIFontOf3XPix(KHorizontalRound(34));
        self.baseDetailLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        [self updateDetailPaddingRight:8];
        [self.baseDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.cutLineView.mas_right).offset(KHorizontalRound(10));
        }];
        
        lineSpace = 8.0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        repeatDictionary = @{NSFontAttributeName : UIFontOf3XPix(KHorizontalRound(39)),
                             NSParagraphStyleAttributeName : paragraphStyle,
                             NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};
        settingDictionary = @{NSFontAttributeName : UIFontOf3XPix(KHorizontalRound(34)),
                              NSParagraphStyleAttributeName : paragraphStyle,
                              NSForegroundColorAttributeName : UIColorFromRGBA(0, 0, 0, 0.6)};

        self.toLabel.opaque = YES;
        self.cutLineView.opaque = YES;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.cutLineView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.2);
}

#pragma mark - 界面刷新

- (void)updateTimeString:(NSString *)timeString font:(UIFont *)font color:(UIColor *)color {
    self.toLabel.hidden = ![timeString containsString:@"\n"];
    
    self.baseTitleLabel.text = timeString;
    self.baseTitleLabel.font = font;
    self.baseTitleLabel.textColor = color;
    [self.baseTitleLabel changeLineSpace:3.0];
}

- (void)updatePlanString:(NSString *)planString attributedText:(NSAttributedString *)attributedText {
    if (attributedText) {
        self.baseDetailLabel.text = nil;
        self.baseDetailLabel.attributedText = attributedText;
    } else {
        self.baseDetailLabel.attributedText = nil;
        self.baseDetailLabel.text = planString;
    }
}


#pragma mark - 懒加载

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [UILabel new];
        [self.baseContentView addSubview:_toLabel];
        
        _toLabel.textColor = UIColorFromRGBA(0, 0, 0, 0.6);
        _toLabel.font = UIFontOf3XPix(KHorizontalRound(48));
        _toLabel.text = KString(@"至");
        
        WeakObj(self);
        [_toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(selfWeak.cutLineView.mas_left).offset(-KHorizontalRound(15));
            make.centerY.equalTo(selfWeak.baseContentView);
        }];
    }
    return _toLabel;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [UIView new];
        [self.baseContentView addSubview:_cutLineView];
        
        _cutLineView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.2);
        
        WeakObj(self);
        [_cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.baseContentView).offset(MAIN_SCREEN_WIDTH * KTaskCellCutLineOffsetYScale);
            make.size.mas_equalTo(CGSizeMake(1, 33));
            make.centerY.equalTo(selfWeak.baseContentView);
        }];
    }
    return _cutLineView;
}

@end
