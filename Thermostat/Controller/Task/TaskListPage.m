//
//  TaskListPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/4.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "TaskListPage.h"
#import "TaskManager.h"
#import "TaskBlankView.h"
#import "TaskEditPage.h"
#import "TaskCell.h"
#import "Task.h"

const CGFloat TaskListRowsHeight = 80.0;

@interface TaskListPage ()

@property (nonatomic, copy) NSString *sn;

@property (nonatomic, strong) TaskBlankView *blankView;

@end

@implementation TaskListPage

- (instancetype)initWithDevice:(NSString *)sn {
    if (self = [super init]) {
        self.sn = sn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"定时");
    [self addBarButtonItemRightNormalImageName:@"nav_add_circle" hightLited:nil];
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
    WeakObj(self);
    [[TaskManager sharedManager] listenTaskList:self device:self.sn block:^(NSArray *array) {
        [selfWeak.baseContentArr removeAllObjects];
        [selfWeak.baseContentArr addObjectsFromArray:array];
        [selfWeak.baseTableView reloadData];
        if (selfWeak.baseContentArr.count > 0) {
            [selfWeak hideBlankView];
        } else {
            [selfWeak showBlankView];
        }
    }];
}

- (void)showBlankView {
    self.blankView.hidden = NO;
    self.baseTableView.hidden = YES;
    WeakObj(self);
    self.blankView.block = ^(TaskType type) {
        id con = [[TaskEditPage alloc] initWithType:type device:selfWeak.sn];
        [selfWeak pushViewController:con];
    };
}

- (void)hideBlankView {
    if (_blankView) {
        self.blankView.hidden = YES;
    }
    self.baseTableView.separatorInset = UIEdgeInsetsMake(0, KHorizontalRound(57), 0, 0);
    self.baseTableView.hidden = NO;
    self.baseTableView.rowHeight = TaskListRowsHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.baseContentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"TaskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    
    Task *item = [self.baseContentArr objectAtIndex:indexPath.row];
    cell.task = item;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Task *item = [self.baseContentArr objectAtIndex:indexPath.row];
    id con = [[TaskEditPage alloc] initWithTask:item.number device:self.sn];
    [self pushViewController:con];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 该函数存在的意义在于, 没它的话, iOS 8 侧滑不出菜单
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self);
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:KString(@"编辑") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        action.backgroundColor = UIColorFromHex(0xcccccc);
        Task *item = [selfWeak.baseContentArr objectAtIndex:indexPath.row];
        id con = [[TaskEditPage alloc] initWithTask:item.number device:selfWeak.sn];
        [selfWeak pushViewController:con];
        [selfWeak.baseTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:KString(@"删除") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        action.backgroundColor = UIColorFromHex(0xff0021);
        Task *item = [selfWeak.baseContentArr objectAtIndex:indexPath.row];
        [[TaskManager sharedManager] removeTask:item.number device:selfWeak.sn];
    }];
    return @[removeAction, editAction];
}

#pragma mark - 点击事件

- (void)barButtonItemRightPressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakObj(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:KString(@"开关定时") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id con = [[TaskEditPage alloc] initWithType:TaskTypeSwitch device:selfWeak.sn];
        [selfWeak pushViewController:con];
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:KString(@"阶段定时") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        id con = [[TaskEditPage alloc] initWithType:TaskTypeStage device:selfWeak.sn];
        [selfWeak pushViewController:con];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:searchAction];
    [alert addAction:addAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


#pragma mark - 懒加载

- (TaskBlankView *)blankView {
    if (!_blankView) {
        _blankView = [[TaskBlankView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     MAIN_SCREEN_WIDTH,
                                                                     NAVIGATION_VIEW_HEIGHT)];
        [self.view addSubview:_blankView];
    }
    return _blankView;
}

@end
