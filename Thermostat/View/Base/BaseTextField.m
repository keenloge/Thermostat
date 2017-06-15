//
//  BaseTextField.m
//  Thermostat
//
//  Created by Keen on 2017/6/1.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseTextField.h"
#import "ColorConfig.h"

// 背景色
#define KColorInputBkg          HB_COLOR_BASE_WHITE

// 边框颜色
#define KColorInputBorder       HB_COLOR_INPUT_BOARD

// 文本颜色
#define KColorInputText         HB_COLOR_BASE_DEEP

// Placeholder 颜色
#define KColorInputPlaceholder  HB_COLOR_INPUT_HOLDER

// 文本相距左边界距离
const CGFloat KTextInputOffSet          = 12.0;

// 边框宽度
const CGFloat KTextInputBorderWidth     = 1.0;

// 圆角大小
const CGFloat KTextInputCornerRadius    = 3.0;

@implementation BaseTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = KColorInputBkg;
    self.layer.cornerRadius = KTextInputCornerRadius;
    self.layer.borderWidth = KTextInputBorderWidth;
    self.layer.borderColor = KColorInputBorder.CGColor;
    self.clipsToBounds = YES;
    self.textColor = KColorInputText;
    self.font = UIFontOf3XPix(45);
    
    [self baseInitialiseSubViews];
}

- (void)baseInitialiseSubViews {
    
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect frameResult = CGRectInset(bounds, KTextInputOffSet, 0);
    
    if (self.leftViewMode == UITextFieldViewModeAlways ||
        self.leftViewMode == UITextFieldViewModeUnlessEditing) {
        frameResult.origin.x += self.leftView.frame.origin.x + self.leftView.frame.size.width;
        frameResult.size.width -= self.leftView.frame.origin.x + self.leftView.frame.size.width;
    }
    
    if (self.rightViewMode == UITextFieldViewModeAlways ||
        self.rightViewMode == UITextFieldViewModeUnlessEditing ||
        self.clearButtonMode == UITextFieldViewModeAlways ||
        self.clearButtonMode == UITextFieldViewModeUnlessEditing) {
        frameResult.size.width -= self.rightView.frame.size.width + 16;
    }
    
    return frameResult;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect frameResult = CGRectInset(bounds, KTextInputOffSet, 0);
    
    if (self.leftViewMode == UITextFieldViewModeAlways) {
        frameResult.origin.x += self.leftView.frame.origin.x + self.leftView.frame.size.width;
        frameResult.size.width -= self.leftView.frame.origin.x + self.leftView.frame.size.width;
    }
    
    if (self.rightViewMode == UITextFieldViewModeAlways ||
        self.clearButtonMode == UITextFieldViewModeAlways) {
        frameResult.size.width -= self.rightView.frame.size.width + 16;
    }
    
    return frameResult;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect frameResult = CGRectInset(bounds, KTextInputOffSet, 0);
    
    if (self.leftViewMode == UITextFieldViewModeAlways ||
        self.leftViewMode == UITextFieldViewModeWhileEditing) {
        frameResult.origin.x += self.leftView.frame.origin.x + self.leftView.frame.size.width;
        frameResult.size.width -= self.leftView.frame.origin.x + self.leftView.frame.size.width;
    }
    
    if (self.rightViewMode == UITextFieldViewModeAlways ||
        self.rightViewMode == UITextFieldViewModeWhileEditing ||
        self.clearButtonMode == UITextFieldViewModeAlways ||
        self.clearButtonMode == UITextFieldViewModeWhileEditing) {
        frameResult.size.width -= self.rightView.frame.size.width + 16;
    }
    
    return frameResult;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    rect.origin.y += (rect.size.height - self.font.lineHeight)/2;
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:KColorInputPlaceholder}];
}

@end
