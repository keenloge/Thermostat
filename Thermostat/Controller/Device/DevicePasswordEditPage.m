//
//  DevicePasswordEditPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/16.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DevicePasswordEditPage.h"
#import "BaseTextField.h"
#import "BaseButton.h"
#import "NSStringAdditions.h"


@interface DevicePasswordEditPage () <UITextFieldDelegate>

@property (nonatomic, strong) BaseTextField *passwordOldTextField;
@property (nonatomic, strong) BaseTextField *passwordNewTextField;
@property (nonatomic, strong) BaseTextField *passwordConfirmTextField;
@property (nonatomic, strong) ColorMainButton *confirmButton;

@end

@implementation DevicePasswordEditPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"修改登录密码");
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

- (void)baseInitialiseSubViews {
    self.passwordOldTextField.opaque = YES;
    self.passwordNewTextField.opaque = YES;
    self.passwordConfirmTextField.opaque = YES;
    self.confirmButton.opaque = YES;

    [self updateConfirmButton];
    
    [self.passwordOldTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordNewTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordConfirmTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)updateConfirmButton {
    self.confirmButton.enabled =   self.passwordOldTextField.text.length > 0
                                && self.passwordNewTextField.text.length > 0
                                && self.passwordConfirmTextField.text.length > 0;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChanged:(UITextField *)sender {
    if (sender.markedTextRange == nil) {
        [self updateConfirmButton];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *preString = textField.text;
    NSString *resultString = [preString stringByReplacingCharactersInRange:range withString:string];
    if (resultString.mixedLenght > 32) {
        return NO;
    }
    return YES;
}

#pragma mark - 点击事件

- (void)baseButtonPressed:(id)sender {
    [self popViewController];
}

#pragma mark - 懒加载

- (BaseTextField *)passwordOldTextField {
    if (!_passwordOldTextField) {
        _passwordOldTextField = [BaseTextField new];
        [self.view addSubview:_passwordOldTextField];
        
        _passwordOldTextField.secureTextEntry = YES;
        _passwordOldTextField.delegate = self;
        _passwordOldTextField.placeholder = KString(@"旧密码");
        
        [_passwordOldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KHorizontalRound(DeviceInputPaddingTop));
            make.left.mas_equalTo(KHorizontalRound(DeviceInputPaddingSide));
            make.right.mas_equalTo(-KHorizontalRound(DeviceInputPaddingSide));
            make.height.mas_equalTo(KHorizontalRound(DeviceInputFieldHeight));
        }];
    }
    return _passwordOldTextField;
}

- (BaseTextField *)passwordNewTextField {
    if (!_passwordNewTextField) {
        _passwordNewTextField = [BaseTextField new];
        [self.view addSubview:_passwordNewTextField];
        
        _passwordNewTextField.secureTextEntry = YES;
        _passwordNewTextField.delegate = self;
        _passwordNewTextField.placeholder = KString(@"新密码");
        
        WeakObj(self);
        [_passwordNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.passwordOldTextField.mas_bottom).offset(KHorizontalRound(DeviceInputFieldOffsetY));
            make.left.right.height.equalTo(selfWeak.passwordOldTextField);
        }];
    }
    return _passwordNewTextField;
}

- (BaseTextField *)passwordConfirmTextField {
    if (!_passwordConfirmTextField) {
        _passwordConfirmTextField = [BaseTextField new];
        [self.view addSubview:_passwordConfirmTextField];
        
        _passwordConfirmTextField.secureTextEntry = YES;
        _passwordConfirmTextField.delegate = self;
        _passwordConfirmTextField.placeholder = KString(@"再次输入新密码");
        
        WeakObj(self);
        [_passwordConfirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.passwordNewTextField.mas_bottom).offset(KHorizontalRound(DeviceInputFieldOffsetY));
            make.left.right.height.equalTo(selfWeak.passwordOldTextField);
        }];
    }
    return _passwordConfirmTextField;
}

- (ColorMainButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [ColorMainButton new];
        [self.view addSubview:_confirmButton];
        [_confirmButton setTitle:KString(@"确定") forState:UIControlStateNormal];
        [self baseAddTargetForButton:_confirmButton];
        
        WeakObj(self);
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.passwordConfirmTextField.mas_bottom).offset(KHorizontalRound(DeviceInputButtonOffsetY));
            make.left.right.equalTo(selfWeak.passwordOldTextField);
            make.height.mas_equalTo(KHorizontalRound(DeviceInputButtonHeight));
        }];
    }
    return _confirmButton;
}

@end
