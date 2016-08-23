# TTAutoScrollView
This is a demo about auto ScrollView. It is very simple and you just add several lines to your project if you want to add a Ad ScrollView.

<center>
<img src="https://raw.githubusercontent.com/DreamFlyingCow/TTAutoScrollView/master/演示.gif" />
</center>

<center>
演示.gif
</center>

### 此工程主要以一个collectionView为基础制作的AD轮播图

##### 1. 首先需要初始化collectionView, 并且设置代理
```
TTCollectionView *collection = [[TTCollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 200)];
	// 这里设置轮播图的自动播放时间间隔
    collection.timeInterval = 3.0;
    // 这里直接传图片的URL字符串(切记是字符串), 要不你还要改里面的图片赋值语句
    collection.imagesArr = [NSArray arrayWithObjects:@"此处是图片字符串的数组", nil];
    [self.view addSubview:collection];
    // 此属性一定要在collectionView添加到俯视图之后再设置, 这里是图片的数量
    collection.imagesCount = 5;
    // 设置代理(主要用来解决点击图片的事件)
    collection.collectionViewDelegate = self;


```

##### 2. 然后实现代理方法, 这里是用来处理图片的点击事件
```
#pragma mark - 这里实现cell的点击事件(根据index(也就是indexPath.item))
- (void)cellClickWithIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
}


```




