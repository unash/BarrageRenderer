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

#import "BarrageCanvas.h"
#import "BarrageSpirit.h"

@interface BarrageCanvas()
{
    NSArray * _spirits;
}
@end

@implementation BarrageCanvas

- (instancetype)init
{
    if (self = [super init]) {
        _zIndex = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = self.superview.bounds;
    self.userInteractionEnabled = NO;
    [self.superview bringSubviewToFront:self];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawSpirits:(NSArray *)spirits
{
    _spirits = spirits;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    /// 添加根据z-index 增序排列
    if (self.zIndex) {
        _spirits = [_spirits sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [@(((BarrageSpirit *)obj1).z_index) compare:@(((BarrageSpirit *)obj2).z_index)];
        }];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect); // 不加不行
    [super drawRect:rect];
    for (BarrageSpirit * spirit in _spirits) {
        [spirit drawInContext:context];
    }
}

@end
