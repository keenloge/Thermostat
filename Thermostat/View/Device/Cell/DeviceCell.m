//
//  DeviceCell.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceCell.h"
#import "ColorConfig.h"
#import "Declare.h"
#import "Globals.h"
#import "LinKonDevice.h"
#import "DeviceManager.h"
#import "InfoButton.h"

#define KInfoButtonColor   UIColorFromHex(0xb3b3b3)

const CGFloat LinKonCellCircleSize      = 52.0;
const CGFloat LinKonCellPaddingTop      = 20.0;
const CGFloat LinKonCellPaddingLeft     = 18.0;
const CGFloat LinKonCellPaddingBottom   = 19.0;
const CGFloat LinKonCellTitleHeight     = 17.0;
const CGFloat LinKonCellDetailHeight    = 14.0;
const CGFloat LinKonCellOffsetX         = 13.0;
const CGFloat LinKonCellInfoWidth       = 64.0;


@interface DeviceCell ()

@property (nonatomic, strong) UIView *contentIconView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) InfoButton *infoButton;


@end

@implementation DeviceCell

#pragma mark - 界面刷新

- (void)changeStateWithDevice:(LinKonDevice *)device {
    self.nicknameLabel.text = device.nickname;
    self.stateLabel.text = device.stateString;
    if (device.connection == DeviceConnectionStateOffLine) {
        self.stateLabel.textColor = HB_COLOR_BASE_RED;
    } else if (device.running == DeviceRunningStateTurnOFF) {
        self.stateLabel.textColor = HB_COLOR_BASE_GREEN;
    } else {
        self.stateLabel.textColor = HB_COLOR_BASE_GRAY;
    }
}


#pragma mark - 点击事件

- (void)buttonPressed:(id)sender {
    if (self.infoBlock) {
        self.infoBlock();
    }
}

#pragma mark - Setter

- (void)setSn:(NSString *)sn {
    _sn = sn;
    
    WeakObj(self);
    [[DeviceManager sharedManager] registerListener:selfWeak device:sn group:LinKonPropertyGroupBinding | LinKonPropertyGroupState | LinKonPropertyGroupSetting block:^(LinKonDevice *device, NSString *key) {
        [selfWeak changeStateWithDevice:device];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentIconView.backgroundColor = HB_COLOR_BASE_MAIN;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.contentIconView.backgroundColor = HB_COLOR_BASE_MAIN;
}

#pragma mark - 界面布局

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    
    self.contentIconView.opaque = YES;
    self.iconImageView.opaque = YES;
    self.nicknameLabel.opaque = YES;
    self.stateLabel.opaque = YES;
    self.infoButton.opaque = YES;
}

- (UIView *)contentIconView {
    if (!_contentIconView) {
        _contentIconView = [UIView new];
        [self.contentView addSubview:_contentIconView];
        _contentIconView.layer.cornerRadius = LinKonCellCircleSize / 2.0;
        _contentIconView.backgroundColor = HB_COLOR_BASE_MAIN;
        
        WeakObj(self);
        [_contentIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.contentView).offset(KHorizontalRound(LinKonCellPaddingLeft));
            make.centerY.equalTo(selfWeak.contentView);
            make.height.mas_equalTo(LinKonCellCircleSize);
            make.width.mas_equalTo(selfWeak.contentIconView.mas_height);
        }];
    }
    return _contentIconView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.contentIconView addSubview:_iconImageView];
        _iconImageView.image = [UIImage imageNamed:@"cell_device"];
        
        WeakObj(self);
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(selfWeak.contentIconView).multipliedBy(1/sqrt(2.0));
            make.height.equalTo(selfWeak.iconImageView.mas_width);
            make.center.equalTo(selfWeak.contentIconView);
        }];
    }
    return _iconImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        [self.contentView addSubview:_nicknameLabel];
        _nicknameLabel.font = UIFontOf3XPix(51);
        _nicknameLabel.textColor = UIColorFromHex(0x484848);
        
        WeakObj(self);
        [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.contentIconView.mas_right).offset(KHorizontalRound(LinKonCellOffsetX));
            make.centerY.equalTo(selfWeak.contentView.mas_top).offset(LinKonCellPaddingTop + LinKonCellTitleHeight / 2.0);
            
            make.top.equalTo(selfWeak.contentView).offset(LinKonCellPaddingTop);
        }];
    }
    return _nicknameLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        [self.contentView addSubview:_stateLabel];
        _stateLabel.font = UIFontOf3XPix(42);
        _stateLabel.textColor = UIColorFromHex(0x666666);
        
        WeakObj(self);
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.nicknameLabel);
            make.centerY.equalTo(selfWeak.contentView.mas_bottom).offset(-LinKonCellPaddingBottom - LinKonCellDetailHeight / 2.0);
        }];
        
    }
    return _stateLabel;
}

- (InfoButton *)infoButton {
    if (!_infoButton) {
        _infoButton = [InfoButton new];
        [self.contentView addSubview:_infoButton];
        [_infoButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        WeakObj(self);
        [_infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(selfWeak.contentView);
            make.width.mas_equalTo(LinKonCellInfoWidth);
        }];
    }
    return _infoButton;
}

@end
