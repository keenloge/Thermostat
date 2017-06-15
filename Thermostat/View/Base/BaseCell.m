//
//  BaseCell.m
//  LinKon
//
//  Created by Keen on 2017/6/13.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HB_COLOR_BASE_WHITE;
        [self baseInitialiseSubViews];
    }
    return self;
}

- (void)baseInitialiseSubViews {
    
}

@end
