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

 - BaseTableCellTypeNone: 无
 - BaseTableCellTypeArrow: 箭头
 - BaseTableCellTypeSwitch: 开关
 BaseTableCellTypeCheck: 勾
 */
typedef NS_ENUM(NSInteger, BaseTableCellType) {
    BaseTableCellTypeNone      = 0,
    BaseTableCellTypeArrow,
    BaseTableCellTypeSwitch,
    BaseTableCellTypeCheck,
};

typedef void(^BaseTableCellSwitchBlock)(BOOL on);

@interface BaseTableCell : UITableViewCell


/**
 附件样式
 */
@property (nonatomic, assign) BaseTableCellType baseCellType;


/**
 图标
 */
@property (nonatomic, strong) UIImage *baseIconImage;


/**
 标题
 */
@property (nonatomic, copy) NSString *baseTitleString;


/**
 内容
 */
@property (nonatomic, copy) NSString *baseDetailString;


/**
 分割线缩进
 */
@property (nonatomic, assign) UIEdgeInsets baseCutLineInsets;



/**
 附件 View 右边距
 */
@property (nonatomic, assign) CGFloat baseAccessoryPaddingLeft;

/**
 更新图片大小与位置

 @param size 图片大小, 当为 CGSizeZero 时, 仍然为图片实际大小
 @param paddingLeft 左边距
 */
- (void)updateIconImageSize:(CGSize)size paddingLeft:(CGFloat)paddingLeft;


/**
 更新标题

 @param font 字体
 @param color 颜色
 @param paddingLeft 左边距
 */
- (void)updateTitleFont:(UIFont *)font color:(UIColor *)color paddingLeft:(CGFloat)paddingLeft;


/**
 更新内容

 @param font 字体
 @param color 颜色
 @param paddingRight 右边距
 */
- (void)updateDetailFont:(UIFont *)font color:(UIColor *)color paddingRight:(CGFloat)paddingRight;


/**
 更新开关, 仅当 BaseTableCellTypeSwitch 时, 生效

 @param on 打开
 @param block 回调
 */
- (void)updateBaseSwitchOn:(BOOL)on switchBlock:(BaseTableCellSwitchBlock)block;


/**
 更新箭头颜色, 仅当 BaseTableCellTypeArrow 时, 生效

 @param color 颜色
 */
- (void)updateArrowColor:(UIColor *)color;


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
