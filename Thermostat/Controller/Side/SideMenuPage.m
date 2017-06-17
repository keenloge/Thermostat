//
//  SideMenuPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/16.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideMenuPage.h"
#import "SideMenuCell.h"
#import "SideAboutPage.h"
#import "SideSettingPage.h"
#import <ViewDeck.h>

const CGFloat SideMenuContentSizeWidth      = 253.0;
const CGFloat SideMenuContentHeaderHeight   = 236.0;
const CGFloat SideMenuContentImageSize      = 60.0;
const CGFloat SideMenuContentImageBorder    = 1.0;
const CGFloat SideMenuContentLabelOffsetY   = 10.0;


@interface SideMenuPage () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UIView *contentHeaderView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *headTitleLabel;

@end

@implementation SideMenuPage

- (void)viewDidLoad {
    self.preferredContentSize = CGSizeMake(KHorizontalRound(SideMenuContentSizeWidth), MAIN_SCREEN_HEIGHT);
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

- (void)baseInitialiseSubViews {
    self.menuTableView.tableHeaderView = self.contentHeaderView;
    self.headImageView.opaque = YES;
    self.headTitleLabel.opaque = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"SideMenuCell";
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[SideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    if (indexPath.row == 0) {
        cell.mainTitle = KString(@"设置");
        cell.iconImage = [UIImage imageNamed:@"cell_setting"];
    } else if (indexPath.row == 1) {
        cell.mainTitle = KString(@"关于我们");
        cell.iconImage = [UIImage imageNamed:@"cell_about"];
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.viewDeckController closeSide:YES];
    id con = nil;
    if (indexPath.row == 0) {
        con = [SideSettingPage new];
    } else if (indexPath.row == 1) {
        con = [SideAboutPage new];
    }
    [(UINavigationController*)self.viewDeckController.centerViewController pushViewController:con animated:YES];
}

#pragma mark - 懒加载

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [UITableView new];
        [self.view addSubview:_menuTableView];
        
        _menuTableView.rowHeight = 57.0;
        _menuTableView.scrollEnabled = NO;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.tableFooterView = [UIView new];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        
        _menuTableView.backgroundColor = UIColorFromHex(0x1a1a1a);
        
        WeakObj(self);
        [_menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(selfWeak.view);
            make.width.mas_equalTo(selfWeak.preferredContentSize.width);
        }];
    }
    return _menuTableView;
}

- (UIView *)contentHeaderView {
    if (!_contentHeaderView) {
        _contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.preferredContentSize.width, KHorizontalRound(SideMenuContentHeaderHeight))];
        
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:_contentHeaderView.bounds];
        [_contentHeaderView addSubview:backgroundImageView];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        backgroundImageView.image = [UIImage imageNamed:@"bkg_banner0"];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = backgroundImageView.bounds;
        [backgroundImageView addSubview:effectView];
        effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *cutLineBottomView = [UIView new];
        [_contentHeaderView addSubview:cutLineBottomView];
        
        cutLineBottomView.backgroundColor = UIColorFromHex(0xe0e0e0);
        
        [cutLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];

    }
    return _contentHeaderView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        [self.contentHeaderView addSubview:_headImageView];
        
        CGFloat imageSize = SideMenuContentImageSize;
        _headImageView.backgroundColor = HB_COLOR_BASE_RED;
        _headImageView.layer.borderColor = HB_COLOR_BASE_WHITE.CGColor;
        _headImageView.layer.borderWidth = SideMenuContentImageBorder;
        _headImageView.layer.cornerRadius = imageSize / 2.0;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"icon_header"];
        
        WeakObj(self);
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(selfWeak.contentHeaderView);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
    }
    return _headImageView;
}

- (UILabel *)headTitleLabel {
    if (!_headTitleLabel) {
        _headTitleLabel = [UILabel new];
        [self.contentHeaderView addSubview:_headTitleLabel];
        
        _headTitleLabel.textColor = HB_COLOR_BASE_WHITE;
        _headTitleLabel.font = UIFontOf3XPix(51);
        _headTitleLabel.text = KString(@"温控器");
        
        WeakObj(self);
        [_headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak.headImageView);
            make.top.equalTo(selfWeak.headImageView.mas_bottom).offset(SideMenuContentLabelOffsetY);
        }];
    }
    return _headTitleLabel;
}

@end
