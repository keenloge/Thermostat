//
//  EnumPickerPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/5.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "EnumPickerPage.h"
#import "LinKonHelper.h"

@interface EnumPickerPage () {
    
}

@property (nonatomic, assign) EnumPickerType type;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, copy) EnumPickerBlock block;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation EnumPickerPage

- (instancetype)initWithType:(EnumPickerType)aType
                       value:(NSInteger)value
                       block:(EnumPickerBlock)block {
    if (self = [super init]) {
        self.type = aType;
        self.value = value;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 界面刷新

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    
    switch (self.type) {
        case EnumPickerTypeWind:
            self.titleString = KString(@"风速");
            [self.contentArray addObject:@(LinKonWindLow)];
            [self.contentArray addObject:@(LinKonWindMedium)];
            [self.contentArray addObject:@(LinKonWindHigh)];
            break;
        case EnumPickerTypeMode:
            self.titleString = KString(@"模式");
            [self.contentArray addObject:@(LinKonModeHot)];
            [self.contentArray addObject:@(LinKonModeCool)];
            [self.contentArray addObject:@(LinKonModeAir)];
            break;
        case EnumPickerTypeScene:
            self.titleString = KString(@"情景");
            [self.contentArray addObject:@(LinKonSceneGreen)];
            [self.contentArray addObject:@(LinKonSceneConstant)];
            [self.contentArray addObject:@(LinKonSceneLeave)];
            break;
        default:
            break;
    }

    NSInteger row = [self.contentArray indexOfObject:@(self.value)];
    [self.checkPickerView selectRow:row inComponent:0 animated:NO];
    
    WeakObj(self);
    self.confirmBlock = ^{
        if (selfWeak.block) {
            NSInteger row = [selfWeak.checkPickerView selectedRowInComponent:0];
            selfWeak.block([[selfWeak.contentArray objectAtIndex:row] integerValue]);
        }
    };

}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.contentArray.count;
}

#pragma mark - UIPickerViewDelegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *rowTitle = nil;
    
    NSInteger value = [[self.contentArray objectAtIndex:row] integerValue];
    if (self.type == EnumPickerTypeWind) {
        rowTitle = [LinKonHelper windString:value];
    } else if (self.type == EnumPickerTypeMode) {
        rowTitle = [LinKonHelper modeString:value];
    } else if (self.type == EnumPickerTypeScene) {
        rowTitle = [LinKonHelper sceneString:value];
    }
    
    return rowTitle;
}

#pragma mark - Getter

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

@end
