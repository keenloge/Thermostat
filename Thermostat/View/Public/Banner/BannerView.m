//
//  BannerView.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "BannerView.h"
#import "Declare.h"
#import "ColorConfig.h"
#import "NSTimerAdditions.h"

#define BannerBeishu 100

@interface BannerButton : UIButton {
    
}

@end

@implementation BannerButton

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = HB_COLOR_BASE_GRAY;
    }
    return self;
}

- (void)setImageWithUrl:(NSString*)url {
    [self setImage:[UIImage imageWithContentsOfFile:url] forState:UIControlStateNormal];
}

@end

@interface BannerCell : UICollectionViewCell

@property (nonatomic, strong) BannerButton* contentButton;

@end

@implementation BannerCell

@synthesize contentButton;

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    self.contentButton = [[BannerButton alloc] init];
    [contentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:contentButton];
    
    NSDictionary* dicViews = NSDictionaryOfVariableBindings(contentButton);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentButton]|" options:0 metrics:nil views:dicViews]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentButton]|" options:0 metrics:nil views:dicViews]];
}

@end

@interface BannerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate> {
    UICollectionView*   listCollectionView;
    NSMutableArray*     imageUrlArray;
    NSTimer*            flipTimer;
}

@end

@implementation BannerView

@synthesize bannerDelegate;

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _init];
}

- (void)_init {
    imageUrlArray = [[NSMutableArray alloc] init];
    
    self.backgroundColor = HB_COLOR_BASE_WHITE;
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    listCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [listCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:listCollectionView];
    listCollectionView.delegate = self;
    listCollectionView.dataSource = self;
    listCollectionView.backgroundColor = HB_COLOR_BASE_WHITE;
    listCollectionView.pagingEnabled = YES;
    listCollectionView.showsHorizontalScrollIndicator = NO;
    listCollectionView.showsVerticalScrollIndicator = NO;
    
    [listCollectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:@"Cell"];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(listCollectionView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[listCollectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[listCollectionView]|" options:0 metrics:nil views:views]];
}

- (void)dealloc {
    if ([flipTimer isValid]) {
        [flipTimer invalidate];
        flipTimer = nil;
    }
}

- (void)updateBannerViewWithImageUrlArr:(NSArray *)arr {
    [imageUrlArray removeAllObjects];
    [imageUrlArray addObjectsFromArray:arr];
    
    [listCollectionView reloadData];
    [self startFlip];
    //    [listCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:BannerBeishu] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)startFlip {
    [self restartTimer];
}

- (void)stopFlip {
    if ([flipTimer isValid]) {
        [flipTimer invalidate];
        flipTimer = nil;
    }
}


#pragma mark - 定时器

- (void)restartTimer {
    if (imageUrlArray.count <= 1) {
        return;
    }
    if (flipTimer) {
        [flipTimer invalidate];
        flipTimer = nil;
    }
    
    if (listCollectionView.contentOffset.x == 0) {
        [listCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:BannerBeishu] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (listCollectionView.contentOffset.x >= listCollectionView.contentSize.width - listCollectionView.frame.size.width) {
        [listCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:imageUrlArray.count - 1 inSection:BannerBeishu - 1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    WeakObj(self);
    flipTimer = [NSTimer hb_scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer *timer) {
        [selfWeak flipPage];
    }];
    [[NSRunLoop currentRunLoop] addTimer:flipTimer forMode:NSRunLoopCommonModes];
}

- (void)flipPage {
    if (listCollectionView.contentOffset.x == 0) {
        [listCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:BannerBeishu] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (listCollectionView.contentOffset.x >= listCollectionView.contentSize.width - listCollectionView.frame.size.width) {
        [listCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:imageUrlArray.count - 1 inSection:BannerBeishu - 1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGFloat pointX = listCollectionView.contentOffset.x + listCollectionView.frame.size.width;
    pointX = ceil(pointX / listCollectionView.frame.size.width) * listCollectionView.frame.size.width;
    if (pointX >= listCollectionView.contentSize.width) {
        pointX = 0;
    }
    [listCollectionView setContentOffset:CGPointMake(pointX, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    if (sender == listCollectionView) {
        [self restartTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate {
    if (sender == listCollectionView) {
        if (!decelerate) {
            [self restartTimer];
        } else {
            if (flipTimer) {
                [flipTimer invalidate];
                flipTimer = nil;
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (imageUrlArray.count > 1) {
        return BannerBeishu * 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    
    BannerCell* cell = [listCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    BannerButton* contentButton = cell.contentButton;
    [contentButton addTarget:self action:@selector(baseButtonBePressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentButton setImageWithUrl:[imageUrlArray objectAtIndex:indexPath.row]];
    contentButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return listCollectionView.bounds.size;
}

#pragma mark - 点击事件

- (void)baseButtonBePressed:(UIButton*)sender {
    if ([bannerDelegate respondsToSelector:@selector(bannerDidPressAtIndex:)]) {
        [bannerDelegate bannerDidPressAtIndex:sender.tag];
    }
}

@end
