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
    UILabel *titleLabel = self.titleLabel;
    UIView *cutLineView = self.cutLineView;
    UIView *menuContentView = self.menuContentView;
    
    DevicePopButton *nicknameButton = self.nicknameButton;
    DevicePopButton *passwordButton = self.passwordButton;
    DevicePopButton *removeButton = self.removeButton;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(titleLabel, cutLineView, menuContentView, nicknameButton, passwordButton, removeButton);
    NSDictionary *metricsDictionary = @{
                                        @"titleHeight" : @(DevicePopTitleHeight),
                                        @"cutLineHeight" : @(DevicePopCutLineHeight),
                                        @"buttonHeight" : @(DevicePopButtonHeight),
                                        @"buttonWidth" : @(DevicePopButtonWidth),
                                        @"paddingLeft" : @(DevicePopButtonPaddingLeft)
                                        };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cutLineView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuContentView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(titleHeight)][cutLineView(cutLineHeight)][menuContentView(buttonHeight)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [menuContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingLeft-[nicknameButton(buttonWidth)][passwordButton(nicknameButton)][removeButton(nicknameButton)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [menuContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nicknameButton]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [menuContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[passwordButton]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [menuContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[removeButton]|" options:0 metrics:metricsDictionary views:viewsDictionary]];

    [self.view layoutIfNeeded];
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
        _titleLabel = [Globals addedSubViewClass:[UILabel class] toView:self.view];
        _titleLabel.backgroundColor = HB_COLOR_BASE_WHITE;
        _titleLabel.font = UIFontOf3XPix(45);
        _titleLabel.textColor = HB_COLOR_POP_TITLE;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [LinKonHelper formatSN:self.device.sn];
    }
    return _titleLabel;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [Globals addedSubViewClass:[UIView class] toView:self.view];
        _cutLineView.backgroundColor = HB_COLOR_POP_LINE;
    }
    return _cutLineView;
}

- (UIView *)menuContentView {
    if (!_menuContentView) {
        _menuContentView = [Globals addedSubViewClass:[UIView class] toView:self.view];
        _menuContentView.backgroundColor = HB_COLOR_BASE_WHITE;
    }
    return _menuContentView;
}

- (DevicePopButton *)nicknameButton {
    if (!_nicknameButton) {
        _nicknameButton = [Globals addedSubViewClass:[DevicePopButton class] toView:self.menuContentView];
        _nicknameButton.tag = DevicePopActionNickname;
        [_nicknameButton setImage:[UIImage imageNamed:@"btn_pop_nickname"] forState:UIControlStateNormal];
        [_nicknameButton setTitle:KString(@"修改昵称") forState:UIControlStateNormal];
        [_nicknameButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nicknameButton;
}

- (DevicePopButton *)passwordButton {
    if (!_passwordButton) {
        _passwordButton = [Globals addedSubViewClass:[DevicePopButton class] toView:self.menuContentView];
        _passwordButton.tag = DevicePopActionPassword;
        [_passwordButton setImage:[UIImage imageNamed:@"btn_pop_password"] forState:UIControlStateNormal];
        [_passwordButton setTitle:KString(@"修改密码") forState:UIControlStateNormal];
        [_passwordButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordButton;
}

- (DevicePopButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [Globals addedSubViewClass:[DevicePopButton class] toView:self.menuContentView];
        _removeButton.tag = DevicePopActionRemove;
        [_removeButton setImage:[UIImage imageNamed:@"btn_pop_delete"] forState:UIControlStateNormal];
        [_removeButton setTitle:KString(@"删除") forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}

@end
