//
//  TTCollectionView.h
//  AutoScrollView
//
//  Created by 赵春浩 on 16/8/19.
//  Copyright © 2016年 Mr Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

@class TTCollectionView;

@protocol TTCollectionViewDelegate <NSObject>
@optional
/**
 *  轮播图的点击事件
 *
 *  @param index 被点击的轮播图的序号
 */
- (void)cellClickWithIndex:(NSInteger)index;

@end


@interface TTCollectionView : UICollectionView
/**
 *  滚动视图的count, 此属性值一定要在collectionView被添加到控制器视图中之后再设置(否则pageControl将不会出现)
 */
@property (assign, nonatomic) NSInteger imagesCount;
/**
 *  存放图片的数组
 */
@property (strong, nonatomic) NSArray *imagesArr;
/**
 *  轮播图自动播放的时间间隔
 */
@property (assign, nonatomic) NSTimeInterval timeInterval;
/**
 *  用来处理点击事件的代理
 */
@property (weak, nonatomic) id <TTCollectionViewDelegate> collectionViewDelegate;

@end
