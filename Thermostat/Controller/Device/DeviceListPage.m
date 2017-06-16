//
//  DeviceListPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "DeviceListPage.h"
#import "BannerView.h"
#import "DeviceManager.h"
#import "DeviceBlankView.h"
#import "DeviceSearchPage.h"
#import "DeviceAddPage.h"
#import "DevicePopPage.h"
#import "DeviceControlPage.h"
#import "DeviceCell.h"
#import "Device.h"
#import "LanguageManager.h"
#import "BaseNavigationPage.h"
#import "DeviceNicknameEditPage.h"
#import "DevicePasswordEditPage.h"

const CGFloat DeviceListRowsHeight = 77.0;

@interface DeviceListPage ()


/**
 Banner 图片地址数组
 */
@property (nonatomic, strong) NSArray *bannerImageUrlArray;


/**
 Banner View
 */
@property (nonatomic, strong) BannerView *linkonBannerView;


/**
 空白提示界面
 */
@property (nonatomic, strong) DeviceBlankView *blankView;


@end

@implementation DeviceListPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addBarButtonItemLeftNormalImageName:@"nav_more" hightLited:nil];
    [self addBarButtonItemRightNormalImageName:@"nav_add_circle" hightLited:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.linkonBannerView startFlip];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.linkonBannerView stopFlip];
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
    self.baseTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.baseTableView.rowHeight = DeviceListRowsHeight;
    self.baseTableView.tableHeaderView = self.linkonBannerView;
    
    WeakObj(self);
    [[DeviceManager sharedManager] listenDeviceList:self block:^(NSArray *array) {
        [selfWeak.baseContentArr removeAllObjects];
        [selfWeak.baseContentArr addObjectsFromArray:array];
        // 重新加载设备列表
        [selfWeak.baseTableView reloadData];
        if (selfWeak.baseContentArr.count > 0) {
            // 隐藏空白页面
            [selfWeak hideBlankView];
        } else {
            // 显示空白页面
            [selfWeak showBlankView];
        }
    }];
}

- (void)baseRestLanguage {
    self.navigationItem.title = KString(@"温控器");
    [self.baseTableView reloadData];
}

- (void)showBlankView {
    self.blankView.hidden = NO;
    self.baseTableView.scrollEnabled = NO;
    WeakObj(self);
    self.blankView.block = ^{
        id con = [[DeviceSearchPage alloc] init];
        [selfWeak pushViewController:con];
    };
}

- (void)hideBlankView {
    if (_blankView) {
        self.blankView.hidden = YES;
    }
    self.baseTableView.scrollEnabled = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.baseContentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"DeviceCell";
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[DeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    Device *device = [self.baseContentArr objectAtIndex:indexPath.row];
    
    cell.sn = device.sn;
    
    WeakObj(self);
    WeakObj(device);
    cell.infoBlock = ^{
        id popPage = [[DevicePopPage alloc] initWithDevice:device block:^(DevicePopAction aTag) {
            id editPage = nil;
            switch (aTag) {
                case DevicePopActionNickname:
                    editPage = [[DeviceNicknameEditPage alloc] init];
                    break;
                case DevicePopActionPassword:
                    editPage = [[DevicePasswordEditPage alloc] init];
                    break;
                case DevicePopActionRemove:
                    [[DeviceManager sharedManager] removeDevice:deviceWeak.sn];
                    break;
                default:
                    break;
            }
            [selfWeak pushViewController:editPage];
        }];
        if (popPage) {
            [selfWeak presentViewController:popPage animated:YES completion:^{
                
            }];
        }
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Device *device = [self.baseContentArr objectAtIndex:indexPath.row];
    if (device.connection == ConnectionStateOFF) {
        [[DeviceManager sharedManager] editDevice:device.sn key:KDeviceConnection value:@(ConnectionStateON)];
    } else {
        id con = [[DeviceControlPage alloc] initWithDevice:device.sn];
        BaseNavigationPage *navCon = [[BaseNavigationPage alloc] initWithRootViewController:con];
        [self presentViewController:navCon animated:YES completion:^{
            
        }];
    }
}

#pragma mark - 点击事件

- (void)barButtonItemRightPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakObj(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:KString(@"新设备") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id con = [[DeviceSearchPage alloc] init];
        [selfWeak pushViewController:con];
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:KString(@"已配置过的设备") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id con = [[DeviceAddPage alloc] init];
        [selfWeak pushViewController:con];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:searchAction];
    [alert addAction:addAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)barButtonItemLeftPressed:(id)sender {
    // 切换语言
    [[LanguageManager sharedManager] switchLanguage];
}

#pragma mark - Getter

- (NSArray *)bannerImageUrlArray {
    if (!_bannerImageUrlArray) {
        NSMutableArray *imageUrlArray = [NSMutableArray array];
        NSString *filePath = nil;
        for (int i = 0; i < 3; i++) {
            filePath = [NSString stringWithFormat:@"%@/bkg_banner%d.png", [[NSBundle mainBundle] resourcePath], i];
            [imageUrlArray addObject:filePath];
        }
        _bannerImageUrlArray = [imageUrlArray copy];
    }
    return _bannerImageUrlArray;
}

#pragma mark - 懒加载

- (BannerView *)linkonBannerView {
    if (!_linkonBannerView) {
        _linkonBannerView = [[BannerView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         MAIN_SCREEN_WIDTH,
                                                                         MAIN_SCREEN_WIDTH / 2.0)];
        [_linkonBannerView updateBannerViewWithImageUrlArr:self.bannerImageUrlArray];
    }
    return _linkonBannerView;
}

- (DeviceBlankView *)blankView {
    if (!_blankView) {
        _blankView = [DeviceBlankView new];
        [self.view addSubview:_blankView];
        
        WeakObj(self);
        _blankView.block = ^{
            id con = [DeviceSearchPage new];
            [selfWeak pushViewController:con];
        };
        
        [_blankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.linkonBannerView.mas_bottom);
            make.left.bottom.right.equalTo(selfWeak.view);
        }];
    }
    return _blankView;
}

@end
