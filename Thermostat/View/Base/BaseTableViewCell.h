//
//  BaseTableViewCell.h
//  Thermostat
//
//  Created by Keen on 2017/6/22.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 附件样式

 - BaseTableViewCellAccessoryTypeNone: 无
 - BaseTableViewCellAccessoryTypeArrow: 箭头
 - BaseTableViewCellAccessoryTypeSwitch: 开关
 BaseTableViewCellAccessoryTypeCheck: 勾
 */
typedef NS_ENUM(NSInteger, BaseTableViewCellAccessoryType) {
    BaseTableViewCellAccessoryTypeNone      = 0,
    BaseTableViewCellAccessoryTypeArrow,
    BaseTableViewCellAccessoryTypeSwitch,
    BaseTableViewCellAccessoryTypeCheck,
};

typedef void(^BaseCellSwitchBlock)(BOOL on);

@interface BaseTableViewCell : UITableViewCell


/**
 附件样式
 */
@property (nonatomic, assign) BaseTableViewCellAccessoryType baseAccessoryType;


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
 更新开关, 仅当 BaseTableViewCellAccessoryTypeSwitch 时, 生效

 @param on 打开
 @param block 回调
 */
- (void)updateBaseSwitchOn:(BOOL)on switchBlock:(BaseCellSwitchBlock)block;


/**
 更新箭头颜色, 仅当 BaseTableViewCellAccessoryTypeArrow 时, 生效

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
