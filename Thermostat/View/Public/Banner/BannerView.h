//
//  BannerView.h
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerDelegate <NSObject>

- (void)bannerDidPressAtIndex:(NSInteger)index;

@end

@interface BannerView : UIView {
    
}

@property (nonatomic, assign) id <BannerDelegate> bannerDelegate;

// 根据图片url更新
- (void)updateBannerViewWithImageUrlArr:(NSArray*)arr;

// 启动自动滚动
- (void)startFlip;

// 停止自动滚动(不停止的话,无法释放内存)
- (void)stopFlip;

@end
