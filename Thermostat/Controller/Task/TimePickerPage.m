//
//  TimePickerPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TimePickerPage.h"
#import "Declare.h"
#import "ColorConfig.h"

@interface TimePickerPage () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) TimePickerBlock block;

@end

@implementation TimePickerPage

- (instancetype)initWithTitle:(NSString *)title
                         time:(NSInteger)time
                        block:(TimePickerBlock)block {
    if (self = [super init]) {
        self.titleString = title;
        self.time = time;
        self.block = block;
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

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];

    NSInteger hour = self.time / 60;
    NSInteger minute = self.time % 60;
    [self.checkPickerView selectRow:hour inComponent:0 animated:NO];
    [self.checkPickerView selectRow:minute inComponent:1 animated:NO];
    
    WeakObj(self);
    self.confirmBlock = ^{
        if (selfWeak.block) {
            NSInteger hour = [selfWeak.checkPickerView selectedRowInComponent:0];
            NSInteger minute = [selfWeak.checkPickerView selectedRowInComponent:1];
            selfWeak.block(hour * 60 + minute);
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    } else if (component == 1) {
        return 60;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%zd", row];
}

@end

