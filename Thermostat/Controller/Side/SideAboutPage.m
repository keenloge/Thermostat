//
//  SideAboutPage.m
//  Thermostat
//
//  Created by Keen on 2017/6/17.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "SideAboutPage.h"

@interface SideAboutPage ()

@property (nonatomic, strong) UIView *contentLogoView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *contentCodeView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation SideAboutPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KString(@"关于");
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

- (void)baseInitialiseSubViews {
    self.contentLogoView.opaque = YES;
    self.logoImageView.opaque = YES;
    
    self.titleLabel.opaque = YES;
    self.detailLabel.opaque = YES;
    
    self.contentCodeView.opaque = YES;
    self.codeImageView.opaque = YES;
    self.phoneLabel.opaque = YES;
    self.contactLabel.opaque = YES;
    self.versionLabel.opaque = YES;
    
    self.rightLabel.opaque = YES;
}

#pragma mark - 懒加载

- (UIView *)contentLogoView {
    if (!_contentLogoView) {
        _contentLogoView = [UIView new];
        [self.view addSubview:_contentLogoView];
        
        _contentLogoView.backgroundColor = HB_COLOR_BASE_MAIN;
        _contentLogoView.layer.cornerRadius = 8.0;

        WeakObj(self);
        [_contentLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak.view);
            make.top.mas_equalTo(36.5);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
    }
    return _contentLogoView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        [self.contentLogoView addSubview:_logoImageView];
        
        _logoImageView.image = [UIImage imageNamed:@"icon_logo"];
        _logoImageView.contentMode = UIViewContentModeScaleToFill;

        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offset = -6;
            make.edges.mas_equalTo(UIEdgeInsetsMake(offset, offset, offset, offset));
        }];
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.view addSubview:_titleLabel];
        
        _titleLabel.textColor = HB_COLOR_BASE_MAIN;
        _titleLabel.font = UIFontOf1XPix(14);
        _titleLabel.text = KString(@"悟家");
        
        WeakObj(self);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak.contentLogoView);
            make.top.equalTo(selfWeak.contentLogoView.mas_bottom).offset(4.5);
        }];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        [self.view addSubview:_detailLabel];
        
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = UIColorFromHex(0x28AAE5);
        _detailLabel.font = UIFontOf1XPix(14);
        _detailLabel.text = @"悟家系列秉承可以改变生活的理念，把小产品落地和大数据挖掘完美相结合，为千家万户提供体一系列智能舒适、节能环保、物美价廉的智能硬件。";
        
        WeakObj(self);
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.titleLabel.mas_bottom).offset(16);
            make.left.mas_equalTo(26);
            make.right.mas_equalTo(-24);
        }];
    }
    return _detailLabel;
}

- (UIView *)contentCodeView {
    if (!_contentCodeView) {
        _contentCodeView = [UIView new];
        [self.view addSubview:_contentCodeView];
        
        WeakObj(self);
        [_contentCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak.view);
            make.bottom.equalTo(selfWeak.rightLabel.mas_top).offset(-11);
        }];
    }
    return _contentCodeView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [UIImageView new];
        [self.contentCodeView addSubview:_codeImageView];
        
        _codeImageView.image = [UIImage imageNamed:@"icon_code"];
        
        WeakObj(self);
        [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selfWeak.contentCodeView).offset(4);
            make.bottom.equalTo(selfWeak.contentCodeView).offset(-2);
            make.left.equalTo(selfWeak.contentCodeView);
            make.size.mas_equalTo(CGSizeMake(49, 49));
        }];
    }
    return _codeImageView;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        [self.contentCodeView addSubview:_phoneLabel];
        
        _phoneLabel.textColor = HB_COLOR_BASE_BLACK;
        _phoneLabel.alpha = 0.85;
        _phoneLabel.font = UIFontOf1XPix(12);
        _phoneLabel.text = @"Tel:400-000-9879";

        WeakObj(self);
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(selfWeak.contentCodeView);
            make.left.equalTo(selfWeak.codeImageView.mas_right).offset(8);
        }];
    }
    return _phoneLabel;
}

- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = [UILabel new];
        [self.codeImageView addSubview:_contactLabel];
        
        _contactLabel.textColor = HB_COLOR_BASE_BLACK;
        _contactLabel.alpha = 0.85;
        _contactLabel.font = UIFontOf1XPix(12);
        _contactLabel.text = @"QQ:4000009879";

        WeakObj(self);
        [_contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.phoneLabel);
            make.right.equalTo(selfWeak.contentCodeView);
            make.centerY.equalTo(selfWeak.contentCodeView);
        }];
    }
    return _contactLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        [self.contentCodeView addSubview:_versionLabel];
        
        _versionLabel.textColor = HB_COLOR_BASE_BLACK;
        _versionLabel.alpha = 0.4;
        _versionLabel.font = UIFontOf1XPix(12);
        _versionLabel.text = @"V4.0.46138(49044)";
        
        WeakObj(self);
        [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selfWeak.phoneLabel);
            make.bottom.right.equalTo(selfWeak.contentCodeView);
        }];
    }
    return _versionLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [self.view addSubview:_rightLabel];
        
        _rightLabel.textColor = HB_COLOR_BASE_BLACK;
        _rightLabel.alpha = 0.4;
        _rightLabel.font = UIFontOf1XPix(12);
        _rightLabel.numberOfLines = 0;
        
        _rightLabel.text = @"Copyright@2017 GALAXYWIND Network Systems";
        
        WeakObj(self);
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(selfWeak.view);
            make.bottom.mas_equalTo(-18);
            make.left.mas_greaterThanOrEqualTo(18);
        }];
    }
    return _rightLabel;
}

@end
