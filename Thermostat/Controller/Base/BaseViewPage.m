//
//  BaseViewPage.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseViewPage.h"
#import "NSDictionaryAdditions.h"
#import "LanguageManager.h"
#import "TemperatureUnitManager.h"

@interface BaseViewPage () {
    BOOL isDidAppear;
    BOOL hasPushView;
}

@property (nonatomic, strong) UIView *notifyView;
@property (nonatomic, strong) UILabel *notifyLabel;

@end

@implementation BaseViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = HB_COLOR_BASE_WHITE;
    if (self.navigationController.viewControllers.count > 1) {
        [self addBarButtonItemBack];
    }
    self.navigationController.navigationBar.translucent = NO;
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    WeakObj(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotificationNameSwitchLanguage object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [selfWeak baseResetLanguage];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:KNotificationNameSwitchUnit object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [selfWeak baseResetUnit];
    }];

    [self baseInitialiseSubViews];
    [self baseResetLanguage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if (!isDidAppear) {
    //    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    hasPushView = NO;
    isDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isDidAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMessageNotify:(NSString *)messageNotify {
    _messageNotify = messageNotify;
    
    if (_messageNotify.length > 0) {
        self.notifyLabel.text = _messageNotify;
        self.notifyView.hidden = NO;
        [self performSelector:@selector(hideMessageNotifyView) withObject:nil afterDelay:1.5];
    } else {
        self.notifyView.hidden = YES;
    }
}

#pragma mark - 数据更新

#pragma mark - 界面刷新
- (void)baseResetLanguage {
    
}

- (void)baseResetUnit {
    
}

- (void)baseInitialiseSubViews {
    
}

#pragma mark – 系统控件相关协议方法：UITextField、UITableView、UIAlertView

#pragma mark - 自定义协议方法

#pragma mark - UIButton点击响应方法

- (void)baseAddTargetForButton:(UIButton *)sender {
    [sender addTarget:self action:@selector(baseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)baseButtonPressed:(id)sender {
    
}

#pragma mark - 定时器

#pragma mark - 其他内部函数（以上某一类特有的功能接口，可以放在分类里面）

- (void)hideMessageNotifyView {
    self.notifyView.alpha = 0.9;
    [UIView animateWithDuration:0.25 animations:^{
        self.notifyView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.notifyView.alpha = 0.9;
        self.notifyView.hidden = YES;
    }];
}

#pragma mark - 懒加载 view初始化实现

- (UIView *)notifyView {
    if (!_notifyView) {
        _notifyView = [UIView new];
        [self.view addSubview:_notifyView];
        
        _notifyView.layer.cornerRadius = 10.0;
        _notifyView.backgroundColor = HB_COLOR_BASE_BLACK;
        _notifyView.alpha = 0.9;
        
        WeakObj(self);
        [_notifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(55);
            make.width.mas_lessThanOrEqualTo(180);
            make.center.equalTo(selfWeak.view);
        }];
    }
    [self.view bringSubviewToFront:_notifyView];
    return _notifyView;
}

- (UILabel *)notifyLabel {
    if (!_notifyLabel) {
        _notifyLabel = [UILabel new];
        [self.notifyView addSubview:_notifyLabel];
        
        _notifyLabel.font = UIFontOf2XPix(24);
        _notifyLabel.textColor = HB_COLOR_BASE_WHITE;
        _notifyLabel.numberOfLines = 0;
        _notifyLabel.textAlignment = NSTextAlignmentCenter;
        
        WeakObj(self);
        [_notifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offsetInsets = 20.0;
            make.edges.equalTo(selfWeak.notifyView).insets(UIEdgeInsetsMake(offsetInsets, offsetInsets, offsetInsets, offsetInsets));
        }];
    }
    return _notifyLabel;
}

@end


@implementation BaseViewPage (NavigationControl)

- (void)popViewController {
    if (isDidAppear) {
        [self doPopViewController];
    } else {
        [self performSelector:@selector(doPopViewController) withObject:nil afterDelay:0.5];
    }
}

- (void)doPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popViewControllerSkipCount:(int)countSkip {
    if (countSkip <= 0) {
        [self popViewController];
    } else {
        if (isDidAppear) {
            [self doPopViewControllerSkipCount:[NSNumber numberWithInt:countSkip]];
        } else {
            [self performSelector:@selector(doPopViewControllerSkipCount:) withObject:[NSNumber numberWithInt:countSkip] afterDelay:0.5];
        }
    }
}

- (void)doPopViewControllerSkipCount:(NSNumber *)numberCount {
    if (hasPushView) {
        return;
    }
    NSArray *navConArr = self.navigationController.viewControllers;
    NSMutableArray *conArr = [[NSMutableArray alloc] initWithArray:[navConArr subarrayWithRange:NSMakeRange(0, navConArr.count - numberCount.intValue - 1)]];
    [self.navigationController setViewControllers:conArr animated:YES];
}

- (void)pushViewController:(id)con {
    if (con == nil) {
        return;
    }
    if (isDidAppear) {
        [self doPushViewController:con];
    } else {
        [self performSelector:@selector(doPushViewController:) withObject:con afterDelay:0.5];
    }
}

- (void)doPushViewController:(id)con {
    if (hasPushView) {
        return;
    }
    hasPushView = YES;
    ((UIViewController *)con).hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)pushViewController:(id)con skipCount:(int)countSkip {
    if (con == nil) {
        return;
    }
    if (countSkip <= 0) {
        [self pushViewController:con];
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:con forKey:@"con"];
        [dic setNumberInt:countSkip forKey:@"skipCount"];
        if (isDidAppear) {
            [self doPushViewControllerSkipCount:dic];
        } else {
            [self performSelector:@selector(doPushViewControllerSkipCount:) withObject:dic afterDelay:0.5];
        }
    }
    
}

- (void)doPushViewControllerSkipCount:(NSDictionary *)dic {
    if (hasPushView) {
        return;
    }
    hasPushView = YES;
    id con = [dic objectForKey:@"con"];
    int countSkip = [dic getIntValueForKey:@"skipCount" defaultValue:1];
    ((UIViewController *)con).hidesBottomBarWhenPushed = YES;
    NSArray *navConArr = self.navigationController.viewControllers;
    NSMutableArray *conArr = [[NSMutableArray alloc] initWithArray:[navConArr subarrayWithRange:NSMakeRange(0, navConArr.count - countSkip)]];
    [conArr addObject:con];
    [self.navigationController setViewControllers:conArr animated:YES];
}

#pragma mark - Navigation BarButtonItem

- (void)addBarButtonItemBack {
    [self addBarButtonItemBackWithAction:@selector(popViewController)];
}

- (void)addBarButtonItemBackWithAction:(SEL)action {
    [self addBarButtonItemNormalImageName:@"nav_back" hightLited:nil action:action isRight:NO];
}

- (void)addBarButtonItemLeftNormalImageName:(NSString *)imgNameN hightLited:(NSString *)imgNameD {
    [self addBarButtonItemNormalImageName:imgNameN hightLited:imgNameD action:@selector(barButtonItemLeftPressed:) isRight:NO];
}

- (void)addBarButtonItemRightNormalImageName:(NSString *)imgNameN hightLited:(NSString *)imgNameD {
    [self addBarButtonItemNormalImageName:imgNameN hightLited:imgNameD action:@selector(barButtonItemRightPressed:) isRight:YES];
}

- (void)addBarButtonItemNormalImageName:(NSString *)strNameN hightLited:(NSString *)strNameD action:(SEL)action isRight:(BOOL)isRight {
    UIImage *imgN = [UIImage imageNamed:strNameN];
    UIImage *imgD = nil;
    if (strNameD) {
        imgD = [UIImage imageNamed:strNameD];
    }
    
    CGFloat navigationBarSize = 44.0;
    CGFloat navigationBarOffsetX = 13.0;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(isRight ? navigationBarOffsetX : -navigationBarOffsetX,
                                                                  0,
                                                                  navigationBarSize,
                                                                  navigationBarSize)];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:imgN forState:UIControlStateNormal];
    if (imgD) {
        [button setImage:imgD forState:UIControlStateHighlighted];
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBarSize, navigationBarSize)];
    [contentView addSubview:button];

    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    if (isRight) {
        self.navigationItem.rightBarButtonItem = bbItem;
    } else {
        self.navigationItem.leftBarButtonItem = bbItem;
    }
}

- (void)addBarButtonItemRightTitle:(NSString *)strTitle {
    [self addBarButtonItemTitle:strTitle action:@selector(barButtonItemRightPressed:) isRight:YES];
}

- (void)addBarButtonItemLeftTitle:(NSString *)strTitle {
    [self addBarButtonItemTitle:strTitle action:@selector(barButtonItemLeftPressed:) isRight:NO];
}

- (void)addBarButtonItemTitle:(NSString *)title action:(SEL)action isRight:(BOOL)isR {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect frameGet = [title boundingRectWithSize:CGSizeMake(200, 50) options:0 attributes:dic context:nil];
    CGSize size = frameGet.size;
    [btn setFrame:CGRectMake(0, 0, size.width + 20, 32)];
    [btn.titleLabel setFont:font];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HB_COLOR_BASE_WHITE forState:UIControlStateNormal];
    [btn setTitleColor:HB_COLOR_BASE_DARK forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isR) {
        self.navigationItem.rightBarButtonItem = bbItem;
    } else {
        self.navigationItem.leftBarButtonItem = bbItem;
    }
}

- (void)barButtonItemLeftPressed:(id)sender {
    
}

- (void)barButtonItemRightPressed:(id)sender {
    
}

@end

@implementation BaseViewPage (KeyBoardControl)

- (void)resignAllKeyboard:(UIView *)aView {
    if ([aView isKindOfClass:[UITextField class]] ||
        [aView isKindOfClass:[UITextView class]]) {
        UITextField *tf = (UITextField *)aView;
        if ([tf canResignFirstResponder])
            [tf resignFirstResponder];
    }
    
    for (UIView *pView in aView.subviews) {
        [self resignAllKeyboard:pView];
    }
}

+ (void)resignAllKeyboard:(UIView *)aView {
    if ([aView isKindOfClass:[UITextField class]] ||
        [aView isKindOfClass:[UITextView class]]) {
        UITextField *tf = (UITextField *)aView;
        if ([tf canResignFirstResponder])
            [tf resignFirstResponder];
    }
    
    for (UIView *pView in aView.subviews) {
        [self resignAllKeyboard:pView];
    }
}

- (void)hideKeyBoard {
    [self resignAllKeyboard:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resignAllKeyboard:self.view];
}

@end
