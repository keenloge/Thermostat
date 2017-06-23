//
//  BaseTableCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/22.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 附件样式

 - BaseTableCellAttachTypeNone: 无
 - BaseTableCellAttachTypeArrow: 箭头
 - BaseTableCellAttachTypeSwitch: 开关
 BaseTableCellAttachTypeCheck: 勾
 */
typedef NS_ENUM(NSInteger, BaseTableCellAttachType) {
    BaseTableCellAttachTypeNone      = 0,
    BaseTableCellAttachTypeArrow,
    BaseTableCellAttachTypeSwitch,
    BaseTableCellAttachTypeCheck,
};

typedef void(^BaseTableCellSwitchBlock)(BOOL on);

@interface BaseTableCell : UITableViewCell


/**
 图标
 */
@property (nonatomic, readonly) UIImageView *baseImageView;


/**
 标题
 */
@property (nonatomic, readonly) UILabel *baseTitleLabel;


/**
 内容
 */
@property (nonatomic, readonly) UILabel *baseDetailLabel;

/**
 附件样式
 */
@property (nonatomic, assign) BaseTableCellAttachType baseAttachType;


/**
 分割线缩进
 */
@property (nonatomic, assign) UIEdgeInsets baseCutLineInsets;



/**
 附件 View 右边距
 */
@property (nonatomic, assign) CGFloat baseAttachPaddingLeft;

/**
 布局子View
 */
- (void)baseInitialiseSubViews;


/**
 更新图片大小与位置

 @param size 图片大小, 当为 CGSizeZero 时, 仍然为图片实际大小
 @param paddingLeft 左边距
 */
- (void)updateIconImageSize:(CGSize)size paddingLeft:(CGFloat)paddingLeft;


/**
 更新标题

 @param paddingLeft 左边距
 */
- (void)updateTitlePaddingLeft:(CGFloat)paddingLeft;


/**
 更新内容

 @param paddingRight 右边距
 */
- (void)updateDetailPaddingRight:(CGFloat)paddingRight;


/**
 更新开关, 仅当 BaseTableCellAttachTypeSwitch 时, 生效

 @param on 打开
 @param block 回调
 */
- (void)updateBaseSwitchOn:(BOOL)on switchBlock:(BaseTableCellSwitchBlock)block;


/**
 更新渐变背景颜色

 @param colors 颜色组
 @param start 起始点
 @param end 结束点
 */
- (void)updateBackgroundColors:(NSArray <UIColor *>*)colors
                    pointStart:(CGPoint)start
                      pointEnd:(CGPoint)end;

@end
