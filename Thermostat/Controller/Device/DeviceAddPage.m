//
//  DeviceAddPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceAddPage.h"
#import "BaseLabel.h"
#import "BaseTextField.h"
#import "BaseButton.h"
#import "DeviceListManager.h"
#import "LinKonDevice.h"

const CGFloat DeviceAddInputPaddingTop = 43.0;
const CGFloat DeviceAddInputPaddingSide = 27.0;
const CGFloat DeviceAddInputHeight = 50.0;
const CGFloat DeviceAddInputOffsetX = 12.0;
const CGFloat DeviceAddInputOffsetY = 12.0;
const CGFloat DeviceAddButtonHeight = 55.0;
const CGFloat DeviceAddButtonOffsetY = 38.0;

@interface DeviceAddPage () <UITextFieldDelegate> {

}

@property (nonatomic, strong) InputFrontLabel *numberLabel;
@property (nonatomic, strong) InputFrontLabel *passwordLabel;
@property (nonatomic, strong) BaseTextField *numberTextField;
@property (nonatomic, strong) BaseTextField *passwordTextField;
@property (nonatomic, strong) ColorMainButton *confirmButton;

@end

@implementation DeviceAddPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"添加设备");
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
    UILabel *passwordLabel = self.passwordLabel;
    UITextField *numberTextField = self.numberTextField;
    UITextField *passwordTextField = self.passwordTextField;
    UIButton *confirmButton = self.confirmButton;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(numberLabel, passwordLabel, numberTextField, passwordTextField, confirmButton);
    NSDictionary *metricsDictionary = @{
                                        @"paddingTop" : @(KHorizontalRound(DeviceAddInputPaddingTop)),
                                        @"paddingSide" : @(KHorizontalRound(DeviceAddInputPaddingSide)),
                                        @"inputHeight" : @(KHorizontalRound(DeviceAddInputHeight)),
                                        @"inputOffsetX" : @(KHorizontalRound(DeviceAddInputOffsetX)),
                                        @"inputOffsetY" : @(KHorizontalRound(DeviceAddInputOffsetY)),
                                        @"buttonHeight" : @(KHorizontalRound(DeviceAddButtonHeight)),
                                        @"buttonOffsetY" : @(KHorizontalRound(DeviceAddButtonOffsetY))
                                        };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[numberTextField(inputHeight)]-inputOffsetY-[passwordTextField(numberTextField)]-buttonOffsetY-[confirmButton(buttonHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[numberLabel]-inputOffsetX-[numberTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[passwordLabel(numberLabel)]-inputOffsetX-[passwordTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[confirmButton]-paddingSide-|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [self.view layoutIfNeeded];
    numberTextField.text = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.numberTextField) {
        // 四位加一个空格
        if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length - 2) % 5 == 0) {//1234 5
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length >= 20) {
                return NO;
            }
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    } else if (textField == self.passwordTextField) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length >= 20) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - 点击事件

- (void)baseButtonPressed:(id)sender {
    if (self.numberTextField.text.length < 1) {
        self.baseMessageNotify = KString(@"请输入设备序列号");
        [self.numberTextField becomeFirstResponder];
    } else if (self.numberTextField.text.length < 20) {
        self.baseMessageNotify = KString(@"请输入正确的设备序列号");
        [self.numberTextField becomeFirstResponder];
    } else if (self.passwordTextField.text.length < 1) {
        self.baseMessageNotify = KString(@"请输入密码");
        [self.passwordTextField becomeFirstResponder];
    } else {
        long long sn = [[self.numberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] longLongValue];
        LinKonDevice *device = [LinKonDevice deviceWithSN:sn password:self.passwordTextField.text];
        [[DeviceListManager sharedManager] addDevice:device];
        [self popViewController];
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
        _numberTextField.placeholder = KString(@"请输入产品序列号");
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.delegate = self;
    }
    return _numberTextField;
}

- (BaseTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
        _passwordTextField.placeholder = KString(@"请输入产品密码");
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (ColorMainButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [Globals addedSubViewClass:[ColorMainButton class] toView:self.view];
        [self baseAddTargetForButton:_confirmButton];
        [_confirmButton setTitle:KString(@"添加") forState:UIControlStateNormal];
    }
    return _confirmButton;
}

@end
