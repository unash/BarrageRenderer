// Part of BarrageRenderer. Created by UnAsh.
// Blog: http://blog.exbye.com
// Github: https://github.com/unash/BarrageRenderer

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015年 UnAsh.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIView+BarrageView.h"

@implementation UIView (BarrageView)

- (void)prepareForReuse
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = 0;
    self.clipsToBounds = NO;
}

- (void)configureWithParams:(NSDictionary *)params
{
    UIColor *backgroundColor = params[@"backgroundColor"];
    if (backgroundColor) self.backgroundColor = backgroundColor;
    
    
    id borderWidthObj = params[@"borderWidth"];
    if (borderWidthObj) self.layer.borderWidth = [borderWidthObj doubleValue];
    
    UIColor *borderColor = params[@"borderColor"];
    if (borderColor) self.layer.borderColor = borderColor.CGColor;
    
    /// 圆角,此属性十分影响绘制性能,谨慎使用
    id cornerRadiusObj = params[@"cornerRadius"];
    if (cornerRadiusObj)
    {
        CGFloat cornerRadius = [cornerRadiusObj doubleValue];
        if (cornerRadius > 0) {
            self.layer.cornerRadius = cornerRadius;
            self.clipsToBounds = YES;
        }
    }
}

@end
