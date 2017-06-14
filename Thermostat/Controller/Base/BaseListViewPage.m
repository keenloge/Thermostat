//
//  BaseListViewPage.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseListViewPage.h"

@interface BaseListViewPage ()

@end

@implementation BaseListViewPage

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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tmpIdentifierCell = @"BaseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tmpIdentifierCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tmpIdentifierCell];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 懒加载

- (UITableView *)baseTableView {
    if (!_baseTableView) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       MAIN_SCREEN_WIDTH,
                                                                       NAVIGATION_VIEW_HEIGHT)
                                                      style:UITableViewStylePlain];
        [self.view addSubview:_baseTableView];
        _baseTableView.dataSource = self;
        _baseTableView.delegate = self;
        _baseTableView.tableFooterView = [UIView new];
    }
    return _baseTableView;
}

- (NSMutableArray *)baseContentArr {
    if (!_baseContentArr) {
        _baseContentArr = [NSMutableArray array];
    }
    return _baseContentArr;
}

@end
