//
//  TTCollectionView.m
//  AutoScrollView
//
//  Created by 赵春浩 on 16/8/19.
//  Copyright © 2016年 Mr Zhao. All rights reserved.
//

#import "TTCollectionView.h"
#import "UIImageView+SMImg.h"
#import "UIViewExt.h"

static NSString *reuseIdentifier = @"UICollectionViewCell";
@interface TTCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>
/**
 *  计时器
 */
@property (strong, nonatomic) NSTimer *timer;
/**
 *  分页控制视图
 */
@property (strong, nonatomic) UIPageControl *page;

@end


@implementation TTCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    // layout 设置
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        [self setting];
    }
    return self;
}




#pragma mark - 初始化设置
- (void)setting {
    
    self.dataSource = self;
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {// 这里设置成3组, 让界面上显示的永远都停留在中间的那一组
    
    return 3;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesCount;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
    if ([self.imagesArr[indexPath.item] isKindOfClass:[UIImage class]]) {
        
        imageView.image = self.imagesArr[indexPath.item];
    } else if ([self.imagesArr[indexPath.item] isKindOfClass:[NSString class]]) {
        
        // 这里需要你自己设置占位图 (这里替换图片的时候默认使用溶解动画)
        [imageView sm_setImageWithUrlString:self.imagesArr[indexPath.item] placeholderImage:[UIImage imageNamed:@"button_keyboard_emotions"]];
    }
    
    [cell.contentView addSubview:imageView];
    
    return cell;
    
}

#pragma mark - cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.collectionViewDelegate respondsToSelector:@selector(cellClickWithIndex:)]) {
        [self.collectionViewDelegate cellClickWithIndex:indexPath.item];
    }
    
}


#pragma mark - 这里是在手动滑动将要开始的时候将计时器停止(移除), 防止其在后台还在计时, 造成滚动多页的情况
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];
    [self keepInMiddleGroupWithScrollView:self];
    
}

#pragma mark - 这里是处理手动滑动之后视图的位置调整
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.timer.valid) {
        [self.timer invalidate];
    }
    [self keepInMiddleGroupWithScrollView:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat temp = scrollView.contentOffset.x / kScreenWidth;
    int i = 0;
    if (temp - (CGFloat)((int)temp) > 0.0) {
        i = (int)temp + 1;
    } else {
        i = (int)temp;
    }
    self.page.currentPage = i % self.imagesCount;
    
}

#pragma mark - 这里是处理定时器滚动完之后视图位置调整
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self keepInMiddleGroupWithScrollView:scrollView];
    
}

#pragma mark - 这里是计时器带动视图滚动的处理
- (void)autoScroll {
    
    CGPoint offset = self.contentOffset;
    offset.x = offset.x + kScreenWidth;
    if (offset.x - (CGFloat)((int)offset.x) != 0) {
        offset.x = (int)offset.x + 1;
    }
    
    [self scrollRectToVisible:CGRectMake(offset.x, 0, kScreenWidth, self.frame.size.height) animated:YES];
    
}

#pragma mark - 这个方法是为了保证视图永远处在最中间的那一组, 不会滚动到头
- (void)keepInMiddleGroupWithScrollView:(UIScrollView *)scrollView {
    
    CGFloat temp = scrollView.contentOffset.x / kScreenWidth;
    int i = 0;
    if (temp - (CGFloat)((int)temp) > 0.0) {
        i = (int)temp + 1;
    } else {
        i = (int)temp;
    }
    self.page.currentPage = i % self.imagesCount;
    
    if (scrollView.contentOffset.x < kScreenWidth * self.imagesCount || scrollView.contentOffset.x >  kScreenWidth * (self.imagesCount * 2 - 1)) {
        
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:i % self.imagesCount inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
    }
    else {

        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:i % self.imagesCount inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
}

#pragma mark - setter方法
// 主要是为了将pageControl添加到collectionView的上方, 不会被遮挡住
- (void)setImagesCount:(NSInteger)imagesCount {
    
    if (_imagesCount != imagesCount) {
        _imagesCount = imagesCount;
    }
    // page控制
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth * 0.5 - 50, CGRectGetMaxY(self.frame) - 30, 100, 20)];
    self.page.tintColor = kRandomColor;
    self.page.currentPageIndicatorTintColor = kRandomColor;
    self.page.numberOfPages = self.imagesCount;
    [self.superview addSubview:self.page];
}
// 这里是添加计时器的
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    
    if (_timeInterval != timeInterval) {
        _timeInterval = timeInterval;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

@end
