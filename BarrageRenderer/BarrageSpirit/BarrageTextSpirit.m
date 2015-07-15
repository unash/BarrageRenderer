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

#import "BarrageTextSpirit.h"

@implementation BarrageTextSpirit

- (instancetype)init
{
    if (self = [super init]) {
        _bgColor = [UIColor clearColor];
        _textColor = [UIColor blackColor];
        _borderWidth = 0.0f;
        _borderColor = [UIColor clearColor];
        _fontSize = 16.0f;
        _cornerRadius = 0.0f;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];
    CGRect rect = CGRectMake(self.position.x, self.position.y, self.size.width, self.size.height);
    [self drawRoundRectangle:rect inContext:context withText:self.text cornerRadius:self.cornerRadius textFontSize:self.fontSize textColor:self.textColor borderWidth:self.borderWidth borderColor:self.borderColor bgColor:self.bgColor];
}

/// 将文字绘制到矩形中
- (void)drawRoundRectangle:(CGRect)rect inContext:(CGContextRef)context withText:(NSString *)text cornerRadius:(CGFloat)cornerRadius  textFontSize:(NSInteger)fontSize textColor:(UIColor*)fontColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor bgColor:(UIColor *)bgColor
{
//    TODO: 临时测试的代码
//    CGContextSetFillColorWithColor(context, bgColor.CGColor); // 填充色
//    [text drawInRect:rect withFont:[UIFont systemFontOfSize:fontSize]];
//    return;
    
    size_t numComponents = CGColorGetNumberOfComponents(borderColor.CGColor);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(borderColor.CGColor);
        CGContextSetRGBStrokeColor(context,components[0],components[1],components[2],components[3]);//画笔线的颜色
    }
    // 绘制边框 与 背景
    CGContextSetLineWidth(context, borderWidth); // 画笔的宽度
    CGContextSetFillColorWithColor(context, bgColor.CGColor); // 填充色
    CGContextMoveToPoint(context, CGRectGetMidX(rect),CGRectGetMinY(rect));  // 上边中间点
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), cornerRadius);  // 右上角
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), cornerRadius);  // 右下角
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), cornerRadius);  // 左下角
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), cornerRadius);  // 左上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    // 绘制文本
    if (text.length > 0) {
        size_t numOfComponents = CGColorGetNumberOfComponents(fontColor.CGColor);
        if (numOfComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(fontColor.CGColor);
            CGContextSetRGBFillColor(context,components[0],components[1],components[2],components[3]);//画笔线的颜色
        }
        UIFont * textFont = [UIFont systemFontOfSize:fontSize];
        NSArray * lines = [text componentsSeparatedByString:@"\n"];
        CGFloat lineHeight = [@"" sizeWithFont:textFont].height;
        NSInteger lineNum = lines.count;
        CGFloat lineOffsetY = (rect.size.height-lineHeight * lineNum)/2;
        for (int i = 0; i < lineNum; i++) {
            NSString * line = [lines objectAtIndex:i];
            CGSize textSize = [line sizeWithFont:textFont];
            CGRect textRect = CGRectMake((rect.size.width-textSize.width)/2+rect.origin.x, lineOffsetY + i * lineHeight +rect.origin.y, textSize.width, textSize.height); // 需要换算成content坐标
            [line drawInRect:textRect withFont:textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }
    }
}

- (CGSize)sizeInBounds:(CGRect)rect
{
    return [_text sizeWithFont:[UIFont systemFontOfSize:_fontSize]];
}

@end
