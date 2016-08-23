//
//  UIImageView+SMImg.m
//  SMBuyerTool
//
//  Created by 赵春浩 on 16/7/4.
//  Copyright © 2016年 SM. All rights reserved.
//

#import "UIImageView+SMImg.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"


@implementation UIImageView (SMImg)

- (void)sm_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeHolderImage{
    
    [self sm_setImageWithUrlString:urlString placeholderImage:placeHolderImage completed:nil];
    
    
}
- (void)sm_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeHolderImage completed:(SMWebImageCompletionWithFinishedBlock)completedBlock{
    
    [self sd_cancelCurrentImageLoad];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    SDWebImageManager *imageMgr = [SDWebImageManager sharedManager];
    // 检查磁盘缓存
    NSString *storeKey = [imageMgr cacheKeyForURL:url];
    __block UIImage *roundImage = [imageMgr.imageCache imageFromDiskCacheForKey:storeKey];
    
    if (roundImage) { // 缓存有图片
        self.image = roundImage;
        if (completedBlock != nil) {
            completedBlock(roundImage);
            
        }
    } else { // 缓存没图片
        self.image = placeHolderImage;
        // 开始下载
        if (url) {
            __weak typeof(self) weakSelf = self;
            id <SDWebImageOperation> operation = [imageMgr downloadImageWithURL:url options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                // 下载中
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (!weakSelf) return;
                dispatch_main_sync_safe(^{
                    if (!weakSelf) return;
                    if (image) {
                        // 下载成功
                        // 在这里处理image
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            roundImage = image;
                            
                            dispatch_main_sync_safe(^{
                                
                                if (completedBlock != nil) {
                                    completedBlock(image);
                                    
                                }
                                
                                [UIView transitionWithView:self duration:1. options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction animations:^{
                                    weakSelf.image = roundImage;
                                } completion:^(BOOL finished) {
                                    [weakSelf setNeedsLayout];
                                }];
                            });
                        });
                        
                    } else {
                        // 下载失败
                        weakSelf.image = placeHolderImage;
                        [weakSelf setNeedsLayout];
                    }
                });
            }];
            [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
        }
    }
    
    
}


@end
