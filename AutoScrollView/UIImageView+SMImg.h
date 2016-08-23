//
//  UIImageView+SMImg.h
//  SMBuyerTool
//
//  Created by 赵春浩 on 16/7/4.
//  Copyright © 2016年 SM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SMWebImageCompletionWithFinishedBlock)(UIImage *image);

@interface UIImageView (SMImg)

- (void)sm_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeHolderImage;

@end
