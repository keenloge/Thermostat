//
//  BaseAlertPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/18.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseAlertPage.h"

const CGFloat KBaseAlertPresentDuration = 0.3;
const CGFloat KBaseAlertDismissDuration = 0.25;


@interface BaseAlertDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface BaseAlertPresentAnimator : NSObject<UIViewControllerAnimatedTransitioning>


@end

@implementation BaseAlertDismissAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return KBaseAlertDismissDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self fadeOutAnimationWithContext:transitionContext];
}

- (void)fadeOutAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end

@implementation BaseAlertPresentAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return KBaseAlertPresentDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self fadeInAnimationWithContext:transitionContext];
}

- (void)fadeInAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.alpha = 0;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         toVC.view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end

@interface BaseAlertPage () <UIViewControllerTransitioningDelegate>

@end

@implementation BaseAlertPage

//- (instancetype)init {
//    if (self = [super init]) {
//        self.transitioningDelegate = self;                          // 设置自己为转场代理
//        self.modalPresentationStyle = UIModalPresentationCustom;    // 自定义转场模式
//    }
//    return self;
//}

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
    [self showAlertView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideAlertView];
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


- (void)showAlertView {
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime();
    animationGroup.duration = KBaseAlertPresentDuration;
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

- (void)hideAlertView {
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.fillMode = kCAFillModeBackwards;
    animationGroup.beginTime = CACurrentMediaTime();
    animationGroup.duration = KBaseAlertDismissDuration;
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

#pragma mark - UIViewControllerTransitioningDelegate

/** 返回Present动画 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    BaseAlertPresentAnimator *animator = [[BaseAlertPresentAnimator alloc] init];
    return animator;
}

/** 返回Dismiss动画 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    BaseAlertDismissAnimator *animator = [[BaseAlertDismissAnimator alloc] init];
    return animator;
}

@end
