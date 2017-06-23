//
//  LinKonPopView.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "LinKonPopView.h"
#import "BaseTableCell.h"

@interface LinKonPopView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UITableView *popTableView;

@property (nonatomic, strong) NSArray *popImageArray;
@property (nonatomic, strong) NSArray *popTitleArray;

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

- (void)updatePopImageArray:(NSArray<UIImage *> *)imageArray titleArray:(NSArray<NSString *> *)titleArray {
    self.popImageArray = [imageArray copy];
    self.popTitleArray = [titleArray copy];
    [self.popTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.popImageArray.count, self.popTitleArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tmpIdentifierCell = @"PopCell";
    BaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tmpIdentifierCell];
    if (cell == nil) {
        cell = [[BaseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tmpIdentifierCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor = UIColorFromRGBA(0, 0, 0, 0.85);
        
        [cell updateIconImageSize:CGSizeMake(32, 32) paddingLeft:14];
        [cell updateTitleInsets:UIEdgeInsetsMake(14, 12, 14, 12)];
        cell.baseTitleLabel.textColor = HB_COLOR_BASE_WHITE;
        cell.baseTitleLabel.font = UIFontOf3XPix(54);
        cell.baseTitleLabel.numberOfLines = 0;
        
        [cell updateMinHeight:60.0];
    }
    
    cell.baseImageView.image = [self.popImageArray objectAtIndex:indexPath.row];
    cell.baseTitleLabel.text = [self.popTitleArray objectAtIndex:indexPath.row];

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
        
        _popTableView.estimatedRowHeight = 60.0;
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

@end
