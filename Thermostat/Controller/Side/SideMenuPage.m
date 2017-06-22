//
//  SideMenuPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/16.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideMenuPage.h"
#import "SideAboutPage.h"
#import "SideSettingPage.h"
#import "BaseTableViewCell.h"
#import <ViewDeck.h>

const CGFloat SideMenuContentSizeWidth      = 253.0;
const CGFloat SideMenuContentHeaderHeight   = 236.0;
const CGFloat SideMenuContentImageSize      = 60.0;
const CGFloat SideMenuContentImageBorder    = 1.0;
const CGFloat SideMenuContentLabelOffsetY   = 10.0;


@interface SideMenuPage () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UIView *contentHeaderView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *headTitleLabel;

@end

@implementation SideMenuPage

- (instancetype)init {
    if (self = [super init]) {
        self.preferredContentSize = CGSizeMake(KHorizontalRound(SideMenuContentSizeWidth), MAIN_SCREEN_HEIGHT);
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

- (void)baseInitialiseSubViews {
    self.backgroundImageView.opaque = YES;
    self.menuTableView.tableHeaderView = self.contentHeaderView;
    self.headImageView.opaque = YES;
    self.headTitleLabel.opaque = YES;
}

- (void)baseResetLanguage {
    [self.menuTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *baseIdentifierCell = @"BaseCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifierCell];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseIdentifierCell];
        [cell updateTitleFont:UIFontOf3XPix(46) color:HB_COLOR_BASE_WHITE paddingLeft:19];
        [cell updateIconImageSize:CGSizeMake(18, 18) paddingLeft:19];
        cell.tintColor = HB_COLOR_BASE_WHITE;
        cell.baseAccessoryType = BaseTableViewCellAccessoryTypeArrow;
        [cell updateBackgroundColors:@[UIColorFromHex(0x4b4b4b), UIColorFromHex(0x3c3c3c)] pointStart:CGPointMake(0, 0) pointEnd:CGPointMake(0, 1)];
        cell.baseCutLineInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.baseAccessoryPaddingLeft = 21;
    }

    if (indexPath.row == 0) {
        cell.baseTitleString = KString(@"设置");
        cell.baseIconImage = [UIImage imageNamed:@"cell_setting"];
    } else if (indexPath.row == 1) {
        cell.baseTitleString = KString(@"关于我们");
        cell.baseIconImage = [UIImage imageNamed:@"cell_about"];
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

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        [self.view insertSubview:_backgroundImageView atIndex:0];
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(MAIN_SCREEN_WIDTH);
        }];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bkg_side" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        _backgroundImageView.image = image;
        self.view.clipsToBounds = YES;
    }
    return _backgroundImageView;
}

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
        
        _menuTableView.backgroundColor = [UIColor clearColor];
        
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
        
        UIView *cutLineBottomView = [UIView new];
        [_contentHeaderView addSubview:cutLineBottomView];
        
        cutLineBottomView.backgroundColor = UIColorFromHex(0xe0e0e0);
        
        [cutLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(LINKON_CUT_LINE_HEIGHT);
        }];

    }
    return _contentHeaderView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        [self.contentHeaderView addSubview:_headImageView];
        
        CGFloat imageSize = SideMenuContentImageSize;
        _headImageView.backgroundColor = HB_COLOR_BASE_MAIN;
        _headImageView.layer.borderColor = HB_COLOR_BASE_WHITE.CGColor;
        _headImageView.layer.borderWidth = SideMenuContentImageBorder;
        _headImageView.layer.cornerRadius = imageSize / 2.0;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"icon_logo"];
        
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
