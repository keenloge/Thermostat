//
//  UIImageAdditions.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "UIImageAdditions.h"

@implementation UIImage (Tint)

+ (UIImage *)imageNamed:(NSString *)name tintColor:(UIColor *)tintColor {
    UIImage *image = [UIImage imageNamed:name];
    //    return [image imageWithColor:tintColor];
    return [image imageWithTintColor:tintColor rect:CGRectMake(0, 0, image.size.width, image.size.height) alpha:1.0];
}

- (UIImage *)imageWithTintColor:(UIColor *)color {
    //    return [self imageWithColor:color];
    return [self imageWithTintColor:color rect:CGRectMake(0, 0, self.size.width, self.size.height) alpha:1.0];
}

- (UIImage *)imageWithTintColor:(UIColor*)color rect:(CGRect)rect alpha:(CGFloat)level {
    UIImage *image = [self imageCompress];
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [image drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return darkImage;
}

- (UIImage *)imageCompress {
    // 开始一个Image上下文
    UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
    
    //设置背景色：白色
    [[UIColor whiteColor]setFill];
    //填充背景
    UIRectFill(CGRectMake(0, 0, self.size.width, self.size.height));
    //绘制原图片
    [self drawAtPoint:CGPointZero];
    //从Image上下文获取UIImage
    UIImage *imgRet = UIGraphicsGetImageFromCurrentImageContext();
    //结束Image上下文
    UIGraphicsEndImageContext();
    //得到去透明度的图片imgRet，这里的_imgv是我自己定义的一个UIImageView用来显示结果，你可自行处理imgRet
    return imgRet;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
