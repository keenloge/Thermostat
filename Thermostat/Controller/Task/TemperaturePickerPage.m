//
//  TemperaturePickerPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TemperaturePickerPage.h"
#import "Globals.h"

@interface TemperaturePickerPage () {
    CGFloat startNumber;
    CGFloat endNumber;
    CGFloat offsetNumber;
}

@property (nonatomic, assign) float setting;
@property (nonatomic, copy) TemperaturePickerBlock block;

@end

@implementation TemperaturePickerPage

- (instancetype)initWithSetting:(float)setting
                          block:(TemperaturePickerBlock)block {
    if (self = [super init]) {
        self.setting = setting;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    startNumber = LINKON_TEMPERATURE_MIN;
    endNumber = LINKON_TEMPERATURE_MAX;
    offsetNumber = LINKON_TEMPERATURE_OFFSET;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    
    self.titleString = KString(@"温度");

    [self.checkPickerView selectRow:round((self.setting - startNumber) * 2) inComponent:0 animated:NO];
    
    WeakObj(self);
    self.confirmBlock = ^{
        if (selfWeak.block) {
            NSInteger row = [selfWeak.checkPickerView selectedRowInComponent:0];
            selfWeak.block((row * offsetNumber) + startNumber);
        }
    };

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return ((endNumber - startNumber) / offsetNumber) + 1;
}

#pragma mark - UIPickerViewDelegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [Globals settingString:startNumber + offsetNumber * row];
}

@end
