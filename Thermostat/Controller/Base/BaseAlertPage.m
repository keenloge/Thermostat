//
//  BaseAlertPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseAlertPage.h"

@interface BaseAlertPage ()

@end

@implementation BaseAlertPage

+ (instancetype)alertPageWithTitle:(NSString *)title message:(NSString *)message alignment:(NSTextAlignment)alignment {
    BaseAlertPage *alert = [BaseAlertPage alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (title) {
        //        NSMutableParagraphStyle *titleParagraph = [[NSMutableParagraphStyle alloc] init];
        //        titleParagraph.alignment = NSTextAlignmentLeft;
        NSDictionary *titleAttributes = @{
                                          //NSParagraphStyleAttributeName : titleParagraph,
                                          NSFontAttributeName : [UIFont boldSystemFontOfSize:17],
                                          };
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:titleAttributes];
        [alert setValue:attributedTitle forKey:@"attributedTitle"];
    }
    
    if (message) {
        NSMutableParagraphStyle *messageParagraph = [[NSMutableParagraphStyle alloc] init];
        messageParagraph.alignment = alignment;
        NSDictionary *messageAttributes = @{
                                            NSParagraphStyleAttributeName : messageParagraph,
                                            NSFontAttributeName : UIFontOf1XPix(14),
                                            };
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:message attributes:messageAttributes];
        [alert setValue:attributedMessage forKey:@"attributedMessage"];
    }
    
    return alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime();
    animationGroup.duration = .5;
    animationGroup.repeatCount = 1;
    animationGroup.timingFunction = defaultCurve;
    
    
    // 平移
    CABasicAnimation * translation = [CABasicAnimation animation];
    translation.keyPath = @"transform.translation.y";
    translation.fromValue = @(-MAIN_SCREEN_HEIGHT);
    translation.toValue = @0;
    
    // 旋转
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.fromValue = @(-M_PI * 1 / 6);
    rotation.toValue = @(0);
    
    
    animationGroup.animations = @[translation, rotation];
    [self.view.layer addAnimation:animationGroup forKey:@"flyIn"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime();
    animationGroup.duration = .5;
    animationGroup.repeatCount = 1;
    animationGroup.timingFunction = defaultCurve;
    
    // 平移
    CABasicAnimation * translation = [CABasicAnimation animation];
    translation.keyPath = @"transform.translation.y";
    translation.fromValue = @0;
    translation.toValue = @(MAIN_SCREEN_HEIGHT);
    
    // 旋转
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.fromValue = @(0);
    rotation.toValue = @(-M_PI * 1 / 6);
    
    
    animationGroup.animations = @[translation, rotation];
    [self.view.layer addAnimation:animationGroup forKey:@"flyOut"];
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

- (void)addActionTitle:(NSString *)title handler:(void (^)(UIAlertAction *))handler {
    [self addActionTitle:title style:UIAlertActionStyleDefault handler:handler];
}

- (void)addActionTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *))handler {
    [self addAction:[UIAlertAction actionWithTitle:title style:style handler:handler]];
}

@end
