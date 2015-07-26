//
//  UIImage+Barrage.h
//
//  Created by UnAsh on 15/7/8.
//  Copyright (c) 2015年 UnAsh. All rights reserved.
//

#import "UIImage+Barrage.h"

@implementation UIImage (Barrage)
- (UIImage *)barrageImageScaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
