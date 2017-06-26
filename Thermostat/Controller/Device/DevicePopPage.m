//
//  DevicePopPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DevicePopPage.h"
#import "DevicePopButton.h"
#import "Globals.h"
#import "Declare.h"
#import "ColorConfig.h"
#import "LinKonDevice.h"
#import "LinKonHelper.h"
#import "DeviceListManager.h"

const CGFloat DevicePopTitleHeight = 38.0;
const CGFloat DevicePopCutLineHeight = 1.0;
const CGFloat DevicePopButtonHeight = 87.0;
const CGFloat DevicePopButtonWidth = 76.0;
const CGFloat DevicePopButtonPaddingLeft = 16.0;

@interface DevicePopPage ()

@property (nonatomic, strong) LinKonDevice *device;
@property (nonatomic, copy) DevicePopBlock block;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *cutLineView;
@property (nonatomic, strong) UIView *menuContentView;
@property (nonatomic, strong) DevicePopButton *nicknameButton;
@property (nonatomic, strong) DevicePopButton *passwordButton;
@property (nonatomic, strong) DevicePopButton *removeButton;

@end

@implementation DevicePopPage

- (instancetype)initWithDevice:(long long)sn
                         block:(DevicePopBlock)aBlock {
    if (self = [super init]) {
        self.device = (LinKonDevice *)[[DeviceListManager sharedManager] getDevice:sn];
        self.block = aBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 界面布局

- (void)baseInitialiseSubViews {
    self.titleLabel.opaque = YES;
    self.cutLineView.opaque = YES;
    self.menuContentView.opaque = YES;
    self.nicknameButton.opaque = YES;
    self.passwordButton.opaque = YES;
    self.removeButton.opaque = YES;
}

#pragma mark - 点击事件

- (void)buttonPressed:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
    [self baseBack];
}

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.view addSubview:_titleLabel];
        
        _titleLabel.backgroundColor = HB_COLOR_BASE_WHITE;
        _titleLabel.font = UIFontOf3XPix(45);
        _titleLabel.textColor = HB_COLOR_POP_TITLE;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [LinKonHelper formatSN:self.device.sn];
        
        WeakObj(self);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(selfWeak.cutLineView.mas_top);
            make.height.mas_equalTo(DevicePopTitleHeight);
        }];
    }
    return _titleLabel;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [UIView new];
        [self.view addSubview:_cutLineView];
        _cutLineView.backgroundColor = HB_COLOR_POP_LINE;
        
        WeakObj(self);
        [_cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(selfWeak.menuContentView.mas_top);
            make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT_2PX);
        }];
    }
    return _cutLineView;
}

- (UIView *)menuContentView {
    if (!_menuContentView) {
        _menuContentView = [UIView new];
        [self.view addSubview:_menuContentView];
        _menuContentView.backgroundColor = HB_COLOR_BASE_WHITE;
        
        [_menuContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(DevicePopButtonHeight);
        }];
    }
    return _menuContentView;
}

- (DevicePopButton *)nicknameButton {
    if (!_nicknameButton) {
        _nicknameButton = [DevicePopButton new];
        [self.menuContentView addSubview:_nicknameButton];
        
        _nicknameButton.tag = DevicePopActionNickname;
        [_nicknameButton setImage:[UIImage imageNamed:@"btn_pop_nickname"] forState:UIControlStateNormal];
        [_nicknameButton setTitle:KString(@"修改昵称") forState:UIControlStateNormal];
        [_nicknameButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        WeakObj(self);
        [_nicknameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(DevicePopButtonPaddingLeft);
            make.top.bottom.mas_equalTo(@[@(0), selfWeak.passwordButton, selfWeak.removeButton]);
            make.width.mas_equalTo(@[@(DevicePopButtonWidth), selfWeak.passwordButton, selfWeak.removeButton]);
        }];
    }
    return _nicknameButton;
}

- (DevicePopButton *)passwordButton {
    if (!_passwordButton) {
        _passwordButton = [DevicePopButton new];
        [self.menuContentView addSubview:_passwordButton];
        
        _passwordButton.tag = DevicePopActionPassword;
        [_passwordButton setImage:[UIImage imageNamed:@"btn_pop_password"] forState:UIControlStateNormal];
        [_passwordButton setTitle:KString(@"修改密码") forState:UIControlStateNormal];
        [_passwordButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        WeakObj(self);
        [_passwordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.nicknameButton.mas_right);
        }];
    }
    return _passwordButton;
}

- (DevicePopButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [DevicePopButton new];
        [self.menuContentView addSubview:_removeButton];
        
        _removeButton.tag = DevicePopActionRemove;
        [_removeButton setImage:[UIImage imageNamed:@"btn_pop_delete"] forState:UIControlStateNormal];
        [_removeButton setTitle:KString(@"删除") forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        WeakObj(self);
        [_removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.passwordButton.mas_right);
        }];
    }
    return _removeButton;
}

@end
