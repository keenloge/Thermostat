//
//  LinKonPopView.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonPopView.h"
#import "LinKonPopCell.h"

@interface LinKonPopView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) LinKonPopCell *popCell;

@property (nonatomic, strong) NSArray *iconNameArray;
@property (nonatomic, strong) NSArray *titleNameArray;

@end

@implementation LinKonPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInitialiseSubViews {
    [super baseInitialiseSubViews];
    
    self.arrowImageView.opaque = YES;
    self.popTableView.opaque = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}

- (void)hideView {
    self.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        self.hidden = YES;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.iconNameArray.count, self.titleNameArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.popCell.nameString = [self.titleNameArray objectAtIndex:indexPath.row];
    CGSize size = [self.popCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return MAX(60, size.height) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tmpIdentifierCell = @"PopCell";
    LinKonPopCell *cell = [tableView dequeueReusableCellWithIdentifier:tmpIdentifierCell];
    if (cell == nil) {
        cell = [[LinKonPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tmpIdentifierCell];
    }
    
    cell.iconImage = [UIImage imageNamed:[self.iconNameArray objectAtIndex:indexPath.row]];
    cell.nameString = [self.titleNameArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self hideView];
    if (self.popBlock) {
        self.popBlock(indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 已经显示最后一行了
        WeakObj(tableView);
        [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableViewWeak.contentSize.height);
        }];
    }
}

#pragma mark - 懒加载

- (NSArray *)iconNameArray {
    if (!_iconNameArray) {
        _iconNameArray = @[
                           @"cell_pop_curve",
                           ];
    }
    return _iconNameArray;
}

- (NSArray *)titleNameArray {
    if (!_titleNameArray) {
        _titleNameArray = @[
                            KString(@"24小时曲线"),
                            ];
    }
    return _titleNameArray;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        [self addSubview:_arrowImageView];
        
        _arrowImageView.alpha = 0.85;
        _arrowImageView.image = [UIImage imageNamed:@"bkg_arrow"];
        
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(12, 15));
        }];
    }
    return _arrowImageView;
}

- (UITableView *)popTableView {
    if (!_popTableView) {
        _popTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 178, 500) style:UITableViewStylePlain];
        [self addSubview:_popTableView];
        
        _popTableView.scrollEnabled = NO;
        _popTableView.separatorColor = UIColorFromRGBA(0, 0, 0, 0.7);
        _popTableView.separatorInset = UIEdgeInsetsZero;
        _popTableView.layer.cornerRadius = 4.0;
        _popTableView.clipsToBounds = YES;
        _popTableView.dataSource = self;
        _popTableView.delegate = self;
        
        WeakObj(self);
        [_popTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak).offset(7);
            make.right.equalTo(selfWeak.arrowImageView);
            make.size.mas_equalTo(CGSizeMake(178, 500));
        }];
    }
    return _popTableView;
}

- (LinKonPopCell *)popCell {
    if (!_popCell) {
        _popCell = [[LinKonPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PopCell"];
    }
    return _popCell;
}

@end
