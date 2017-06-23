//
//  BaseHeaderFooterView.h
//  Thermostat
//
//  Created by Keen on 2017/6/23.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseHeaderFooterView : UITableViewHeaderFooterView

/**
 标题
 */
@property (nonatomic, readonly) UILabel *baseTitleLabel;


/**
 内容
 */
@property (nonatomic, readonly) UILabel *baseDetailLabel;

/**
 分割线缩进
 */
@property (nonatomic, assign) UIEdgeInsets baseCutLineInsets;

/**
 更新标题左边距
 
 @param paddingLeft 左边距
 */
- (void)updateTitlePaddingLeft:(CGFloat)paddingLeft;


/**
 更新内容
 
 @param paddingRight 右边距
 */
- (void)updateDetailPaddingRight:(CGFloat)paddingRight;

@end
