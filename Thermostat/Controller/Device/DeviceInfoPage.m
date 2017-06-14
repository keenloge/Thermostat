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
#import "DeviceManager.h"
#import "Device.h"

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


@end

@implementation DeviceInfoPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"设备信息");
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
    UILabel *numberLabel = self.numberLabel;
    UILabel *nicknameLabel = self.nicknameLabel;
    UILabel *passwordLabel = self.passwordLabel;
    UITextField *numberTextField = self.numberTextField;
    UITextField *nicknameTextField = self.nicknameTextField;
    UITextField *passwordTextField = self.passwordTextField;
    UIButton *confirmButton = self.confirmButton;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(numberLabel, nicknameLabel, passwordLabel, numberTextField, nicknameTextField, passwordTextField, confirmButton);
    NSDictionary *metricsDictionary = @{
                                        @"paddingTop" : @(KHorizontalCeil(DeviceInfoInputPaddingTop)),
                                        @"paddingSide" : @(KHorizontalCeil(DeviceInfoInputPaddingSide)),
                                        @"inputHeight" : @(KHorizontalCeil(DeviceInfoInputHeight)),
                                        @"inputOffsetX" : @(KHorizontalCeil(DeviceInfoInputOffsetX)),
                                        @"inputOffsetY" : @(KHorizontalCeil(DeviceInfoInputOffsetY)),
                                        @"buttonHeight" : @(KHorizontalCeil(DeviceInfoButtonHeight)),
                                        @"buttonOffsetY" : @(KHorizontalCeil(DeviceInfoButtonOffsetY))
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
    if (self.numberTextField.text.length < 1) {
        self.messageNotify = KString(@"请输入设备序列号");
        [self.numberTextField becomeFirstResponder];
    } else if (self.nicknameTextField.text.length < 1) {
        self.messageNotify = KString(@"请输入设备昵称");
        [self.nicknameTextField becomeFirstResponder];
    } else if (self.passwordTextField.text.length < 1) {
        self.messageNotify = KString(@"请输入密码");
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self popViewController];
        
        Device *device = [[Device alloc] init];
        device.sn = self.numberTextField.text;
        device.nickname = self.nicknameTextField.text;
        device.password = self.passwordTextField.text;
        [[DeviceManager sharedManager] addDevice:device];
    }
}

#pragma mark - 懒加载

- (InputFrontLabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [Globals addedSubViewClass:[InputFrontLabel class] toView:self.view];
        _numberLabel.text = KString(@"序列号");
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
        _numberTextField.text = @"**********************************************************";
    }
    return _numberTextField;
}

- (BaseTextField *)nicknameTextField {
    if (!_nicknameTextField) {
        _nicknameTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
        _nicknameTextField.text = KString(@"温控器");
    }
    return _nicknameTextField;
}

- (BaseTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
        _passwordTextField.text = @"123456";
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
