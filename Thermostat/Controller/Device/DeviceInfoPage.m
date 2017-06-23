//
//  DeviceInfoPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceInfoPage.h"
#import "BaseLabel.h"
#import "BaseTextField.h"
#import "BaseButton.h"
#import "DeviceListManager.h"
#import "LinKonDevice.h"
#import "BaseAlertPage.h"

const CGFloat DeviceInfoInputPaddingTop = 43.0;
const CGFloat DeviceInfoInputPaddingSide = 27.0;
const CGFloat DeviceInfoInputHeight = 50.0;
const CGFloat DeviceInfoInputOffsetX = 12.0;
const CGFloat DeviceInfoInputOffsetY = 12.0;
const CGFloat DeviceInfoButtonHeight = 55.0;
const CGFloat DeviceInfoButtonOffsetY = 38.0;

@interface DeviceInfoPage () {

}

@property (nonatomic, strong) InputFrontLabel *numberLabel;
@property (nonatomic, strong) InputFrontLabel *nicknameLabel;
@property (nonatomic, strong) InputFrontLabel *passwordLabel;
@property (nonatomic, strong) BaseTextField *numberTextField;
@property (nonatomic, strong) BaseTextField *nicknameTextField;
@property (nonatomic, strong) BaseTextField *passwordTextField;
@property (nonatomic, strong) ColorMainButton *confirmButton;
@property (nonatomic, strong) LinKonDevice *device;

@end

@implementation DeviceInfoPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"设备信息");
    [self addBarButtonItemBackWithAction:@selector(barButtonItemLeftPressed:)];
    
    self.device = [LinKonDevice randomDevice];
    self.numberTextField.text = [LinKonHelper formatSN:self.device.sn];
    self.nicknameTextField.text = self.device.nickname;
    self.passwordTextField.text = self.device.password;
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

- (void)addDeviceWithInput {
    [self popViewController];
    [self.device setValue:self.nicknameTextField.text forKey:KDeviceNickname];
    [self.device setValue:self.passwordTextField.text forKey:KDevicePassword];
    [[DeviceListManager sharedManager] addDevice:self.device];
}

#pragma mark - 界面布局

- (void)baseInitialiseSubViews {
    UILabel *numberLabel = self.numberLabel;
    UILabel *nicknameLabel = self.nicknameLabel;
    UILabel *passwordLabel = self.passwordLabel;
    UITextField *numberTextField = self.numberTextField;
    UITextField *nicknameTextField = self.nicknameTextField;
    UITextField *passwordTextField = self.passwordTextField;
    UIButton *confirmButton = self.confirmButton;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(numberLabel, nicknameLabel, passwordLabel, numberTextField, nicknameTextField, passwordTextField, confirmButton);
    NSDictionary *metricsDictionary = @{
                                        @"paddingTop" : @(KHorizontalRound(DeviceInfoInputPaddingTop)),
                                        @"paddingSide" : @(KHorizontalRound(DeviceInfoInputPaddingSide)),
                                        @"inputHeight" : @(KHorizontalRound(DeviceInfoInputHeight)),
                                        @"inputOffsetX" : @(KHorizontalRound(DeviceInfoInputOffsetX)),
                                        @"inputOffsetY" : @(KHorizontalRound(DeviceInfoInputOffsetY)),
                                        @"buttonHeight" : @(KHorizontalRound(DeviceInfoButtonHeight)),
                                        @"buttonOffsetY" : @(KHorizontalRound(DeviceInfoButtonOffsetY))
                                        };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[numberTextField(inputHeight)]-inputOffsetY-[nicknameTextField(numberTextField)]-inputOffsetY-[passwordTextField(numberTextField)]-buttonOffsetY-[confirmButton(buttonHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[numberLabel]-inputOffsetX-[numberTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[nicknameLabel(numberLabel)]-inputOffsetX-[nicknameTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[passwordLabel(numberLabel)]-inputOffsetX-[passwordTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[confirmButton]-paddingSide-|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [self.view layoutIfNeeded];
    numberTextField.text = @"LinKon";
}

#pragma mark - 点击事件

- (void)baseButtonPressed:(id)sender {
    [self hideKeyBoard];
   if (self.nicknameTextField.text.length < 1) {
        self.baseMessageNotify = KString(@"请输入设备昵称");
        [self.nicknameTextField becomeFirstResponder];
    } else if (self.passwordTextField.text.length < 1) {
        self.baseMessageNotify = KString(@"请输入密码");
        [self.passwordTextField becomeFirstResponder];
    } else {
        if ([self.device.password isEqualToString:self.passwordTextField.text]) {
            // 原始密码未改动
            WeakObj(self);
            BaseAlertPage *alert = [BaseAlertPage alertPageWithTitle:KString(@"温馨提示") message:@"你的设备管理密码为出厂密码，为了安全考虑，建议重新设置密码" alignment:NSTextAlignmentCenter];
            [alert addActionTitle:KString(@"设置密码") handler:^(UIAlertAction *action) {
                [selfWeak.passwordTextField becomeFirstResponder];
            }];
            [alert addActionTitle:KString(@"忽略") handler:^(UIAlertAction *action) {
                [selfWeak addDeviceWithInput];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self addDeviceWithInput];
        }
    }
}

- (void)barButtonItemLeftPressed:(id)sender {
    [self hideKeyBoard];
    [self popViewController];
    [[DeviceListManager sharedManager] addDevice:self.device];
}

#pragma mark - 懒加载

- (InputFrontLabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [Globals addedSubViewClass:[InputFrontLabel class] toView:self.view];
        [_numberLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _numberLabel.text = KString(@"序列号");
        _numberLabel.userInteractionEnabled = NO;
    }
    return _numberLabel;
}

- (InputFrontLabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [Globals addedSubViewClass:[InputFrontLabel class] toView:self.view];
        _nicknameLabel.text = KString(@"昵称");
    }
    return _nicknameLabel;
}

- (InputFrontLabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [Globals addedSubViewClass:[InputFrontLabel class] toView:self.view];
        _passwordLabel.text = KString(@"密码");
    }
    return _passwordLabel;
}

- (BaseTextField *)numberTextField {
    if (!_numberTextField) {
        _numberTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
        _numberTextField.userInteractionEnabled = NO;
    }
    return _numberTextField;
}

- (BaseTextField *)nicknameTextField {
    if (!_nicknameTextField) {
        _nicknameTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
    }
    return _nicknameTextField;
}

- (BaseTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
    }
    return _passwordTextField;
}

- (ColorMainButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [Globals addedSubViewClass:[ColorMainButton class] toView:self.view];
        [self baseAddTargetForButton:_confirmButton];
        [_confirmButton setTitle:KString(@"确认") forState:UIControlStateNormal];
    }
    return _confirmButton;
}

@end
