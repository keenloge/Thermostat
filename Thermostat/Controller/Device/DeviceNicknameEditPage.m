//
//  DeviceNicknameEditPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/16.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceNicknameEditPage.h"
#import "NSStringAdditions.h"
#import "BaseTextField.h"
#import "BaseButton.h"
#import "LinKonDevice.h"

@interface DeviceNicknameEditPage () <UITextFieldDelegate>

@property (nonatomic, strong) BaseTextField *nicknameTextField;
@property (nonatomic, strong) ColorMainButton *confirmButton;
@property (nonatomic, strong) LinKonDevice *device;

@end

@implementation DeviceNicknameEditPage

- (instancetype)initWithDevice:(long long)sn {
    if (self = [super init]) {
        self.device = [[DeviceListManager sharedManager] getDevice:sn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"修改设备名称");
    self.nicknameTextField.text = self.device.nickname;
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
    self.nicknameTextField.opaque = YES;
    self.confirmButton.opaque = YES;
    self.confirmButton.enabled = self.nicknameTextField.text.length > 0;

    [self.nicknameTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChanged:(UITextField *)sender {
    if (sender.markedTextRange == nil) {
        self.confirmButton.enabled = sender.text.length > 0 && ![sender.text isEqualToString:self.device.nickname];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *preString = textField.text;
    NSString *resultString = [preString stringByReplacingCharactersInRange:range withString:string];
    if (resultString.mixedLenght > 20) {
        return NO;
    }
    return YES;
}

#pragma mark - 点击事件

- (void)baseButtonPressed:(id)sender {
    [self popViewController];
    [self.device updateValue:self.nicknameTextField.text forKey:KDeviceNickname];
}

#pragma mark - 懒加载

- (BaseTextField *)nicknameTextField {
    if (!_nicknameTextField) {
        _nicknameTextField = [BaseTextField new];
        [self.view addSubview:_nicknameTextField];
        
        _nicknameTextField.delegate = self;
        _nicknameTextField.placeholder = KString(@"设备名称");

        [_nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KHorizontalRound(DeviceInputPaddingTop));
            make.left.mas_equalTo(KHorizontalRound(DeviceInputPaddingSide));
            make.right.mas_equalTo(-KHorizontalRound(DeviceInputPaddingSide));
            make.height.mas_equalTo(KHorizontalRound(DeviceInputFieldHeight));
        }];
    }
    return _nicknameTextField;
}

- (ColorMainButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [ColorMainButton new];
        [self.view addSubview:_confirmButton];
        [_confirmButton setTitle:KString(@"完成") forState:UIControlStateNormal];
        [self baseAddTargetForButton:_confirmButton];
        
        WeakObj(self);
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.nicknameTextField.mas_bottom).offset(KHorizontalRound(DeviceInputButtonOffsetY));
            make.left.equalTo(selfWeak.nicknameTextField);
            make.right.equalTo(selfWeak.nicknameTextField);
            make.height.mas_equalTo(KHorizontalRound(DeviceInputButtonHeight));
        }];
    }
    return _confirmButton;
}

@end
