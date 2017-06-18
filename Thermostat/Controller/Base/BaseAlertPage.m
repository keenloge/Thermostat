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

+ (instancetype)alertPageWithTitle:(NSString *)title message:(NSString *)message {
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
        messageParagraph.alignment = NSTextAlignmentLeft;
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
