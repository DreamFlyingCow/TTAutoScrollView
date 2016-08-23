//
//  ViewController.m
//  AutoScrollView
//
//  Created by 赵春浩 on 16/8/19.
//  Copyright © 2016年 Mr Zhao. All rights reserved.
//

#import "ViewController.h"
#import "TTCollectionView.h"

@interface ViewController ()<UICollectionViewDelegate, TTCollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

//com.cn.sm.AutoScrollView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    TTCollectionView *collection = [[TTCollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 200)];
    collection.timeInterval = 3.0;
    // 这里直接传图片的URL字符串(切记是字符串), 要不你还要改里面的图片赋值语句
    collection.imagesArr = [NSArray arrayWithObjects:@"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/903/847d2925-7d03-40dd-90d9-429d13aabab8_100x100.jpg", @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/888/4f564995-a919-4c7f-ae8f-d8d0bda1d7f4_100x100.jpg", @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/869/2ebc752a-5176-4f16-b7b5-2233d4ddcc87_100x100.jpg", @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/888/4f564995-a919-4c7f-ae8f-d8d0bda1d7f4_100x100.jpg", @"http://d-smrss.oss-cn-beijing.aliyuncs.com/customerportrait/004/903/847d2925-7d03-40dd-90d9-429d13aabab8_100x100.jpg", nil];
    [self.view addSubview:collection];
    // 此属性一定要在collectionView添加到俯视图之后再设置
    collection.imagesCount = 5;
    collection.collectionViewDelegate = self;
    
}


#pragma mark - 这里实现cell的点击事件(根据index(也就是indexPath.item))
- (void)cellClickWithIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
