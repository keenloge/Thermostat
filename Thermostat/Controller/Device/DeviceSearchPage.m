//
//  DeviceSearchPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceSearchPage.h"
#import "DeviceInfoPage.h"
#import "BaseLabel.h"
#import "BaseTextField.h"
#import "DeviceSearchButton.h"
#import "BaseAlertPage.h"

const CGFloat DeviceSearchInputPaddingTop = 43.0;
const CGFloat DeviceSearchInputPaddingSide = 27.0;
const CGFloat DeviceSearchInputHeight = 50.0;
const CGFloat DeviceSearchInputOffsetX = 12.0;
const CGFloat DeviceSearchInputOffsetY = 12.0;
const CGFloat DeviceSearchButtonSize = 144.0;

@interface DeviceSearchPage () {

}

@property (nonatomic, strong) UILabel *ssidLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *ssidTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIView *contentSearchView;
@property (nonatomic, strong) DeviceSearchButton *searchButton;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, weak) BaseAlertPage *alertPage;

@end

@implementation DeviceSearchPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"搜索设备");
    [self addBarButtonItemBackWithAction:@selector(barButtonItemLeftPressed:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.alertPage) {
        [self.alertPage dismissViewControllerAnimated:YES completion:nil];
    }
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

- (void)showAlertWithNullPassword {
    NSMutableString *message = [NSMutableString string];
    [message appendString:KString(@"SSID")];
    [message appendString:@" "];
    [message appendString:self.ssidTextField.text];
    [message appendString:@"\n"];
    [message appendString:KString(@"密码")];
    [message appendString:@" "];
    [message appendString:KString(@"空")];
    [message appendString:@"\n"];
    [message appendString:KString(@"Wi-Fi密码未输入，请确认Wi-Fi密码是否为空")];
    
    BaseAlertPage *alert = [BaseAlertPage alertPageWithTitle:KString(@"温馨提示") message:message];
    WeakObj(self);
    [alert addActionTitle:KString(@"重新输入") handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak.passwordTextField becomeFirstResponder];
    }];
    
    [alert addActionTitle:KString(@"开始搜索") handler:^(UIAlertAction * _Nonnull action) {
        selfWeak.searching = YES;
    }];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)showAlertWithSearching {
    BaseAlertPage *alert = [BaseAlertPage alertPageWithTitle:KString(@"搜索过程大约需要3分钟，取消并重新开始？") message:nil];
    WeakObj(self);
    [alert addActionTitle:KString(@"等待") handler:^(UIAlertAction *action) {
        
    }];
    [alert addActionTitle:KString(@"好的") handler:^(UIAlertAction *action) {
        [selfWeak popViewController];
    }];
    
    self.alertPage = alert;
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)beginSearch {
    WeakObj(self);
    [self.searchButton startAnimationWithDuration:5 finishBlock:^{
        selfWeak.searching = NO;
        id con = [[DeviceInfoPage alloc] init];
        [selfWeak pushViewController:con skipCount:1];
    }];
}

#pragma - mark - 点击事件

- (void)barButtonItemLeftPressed:(id)sender {
    [self hideKeyBoard];
    if (self.isSearching) {
        [self showAlertWithSearching];
    } else {
        [self popViewController];
    }
}

- (void)baseButtonPressed:(id)sender {
    [self hideKeyBoard];
    if (self.passwordTextField.text.length == 0) {
        [self showAlertWithNullPassword];
    } else {
        self.searching = YES;
    }
}

#pragma mark - 界面布局

- (void)baseInitialiseSubViews {
    UILabel *ssidLabel = self.ssidLabel;
    UILabel *passwordLabel = self.passwordLabel;
    UITextField *ssidTextField = self.ssidTextField;
    UITextField *passwordTextField = self.passwordTextField;
    UIView *contentSearchView = self.contentSearchView;
    DeviceSearchButton *searchButton = self.searchButton;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(ssidLabel, passwordLabel, ssidTextField, passwordTextField, contentSearchView, searchButton);
    NSDictionary *metricsDictionary = @{
                                        @"paddingTop" : @(KHorizontalRound(DeviceSearchInputPaddingTop)),
                                        @"paddingSide" : @(KHorizontalRound(DeviceSearchInputPaddingSide)),
                                        @"inputHeight" : @(KHorizontalRound(DeviceSearchInputHeight)),
                                        @"inputOffsetX" : @(KHorizontalRound(DeviceSearchInputOffsetX)),
                                        @"inputOffsetY" : @(KHorizontalRound(DeviceSearchInputOffsetY)),
                                        @"buttonSize" : @(KHorizontalRound(DeviceSearchButtonSize))
                                        };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingTop-[ssidTextField(inputHeight)]-inputOffsetY-[passwordTextField(ssidTextField)][contentSearchView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[ssidLabel]-inputOffsetX-[ssidTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-paddingSide-[passwordLabel(ssidLabel)]-inputOffsetX-[passwordTextField]-paddingSide-|" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentSearchView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [contentSearchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[searchButton(buttonSize)]-(<=1)-[contentSearchView]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDictionary views:viewsDictionary]];
    [contentSearchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchButton(buttonSize)]-(<=1)-[contentSearchView]" options:NSLayoutFormatAlignAllCenterX metrics:metricsDictionary views:viewsDictionary]];
    
    [self.view layoutIfNeeded];
    ssidTextField.text = @"TP-LINK";
    searchButton.layer.cornerRadius = searchButton.frame.size.height / 2.0;
    searchButton.clipsToBounds = YES;
}

- (void)setSearching:(BOOL)searching {
    _searching = searching;
    
    self.passwordTextField.userInteractionEnabled = !_searching;
    
    if (_searching) {
        [self beginSearch];
    } else {
        
    }
}

#pragma mark - 懒加载

- (UILabel *)ssidLabel {
    if (!_ssidLabel) {
        _ssidLabel = [Globals addedSubViewClass:[InputFrontLabel class] toView:self.view];
        _ssidLabel.text = KString(@"SSID");
    }
    return _ssidLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [Globals addedSubViewClass:[InputFrontLabel class] toView:self.view];
        _passwordLabel.text = KString(@"密码");
    }
    return _passwordLabel;
}

- (UITextField *)ssidTextField {
    if (!_ssidTextField) {
        _ssidTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
        _ssidTextField.text = @"**************************************************";
        _ssidTextField.userInteractionEnabled = NO;
    }
    return _ssidTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [Globals addedSubViewClass:[BaseTextField class] toView:self.view];
        _passwordTextField.placeholder = KString(@"路由器WI-FI密码");
    }
    return _passwordTextField;
}

- (UIView *)contentSearchView {
    if (!_contentSearchView) {
        _contentSearchView = [Globals addedSubViewClass:[UIView class] toView:self.view];
    }
    return _contentSearchView;
}

- (DeviceSearchButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [Globals addedSubViewClass:[DeviceSearchButton class] toView:self.contentSearchView];
        [_searchButton setTitle:KString(@"开始搜索") forState:UIControlStateNormal];
        
        [self baseAddTargetForButton:_searchButton];
    }
    return _searchButton;
}

@end
