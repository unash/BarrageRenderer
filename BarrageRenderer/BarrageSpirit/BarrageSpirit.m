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

#import "BarrageSpirit.h"

@interface BarrageSpirit()

@end

@implementation BarrageSpirit

@synthesize origin = _origin;
@synthesize valid = _valid;
@synthesize view = _view;

- (instancetype)init
{
    if (self = [super init]) {
        _delay = 0.0f;
        _birth = [NSDate date];
        _valid = YES;
        _origin.x = _origin.y = MAXFLOAT;
        _z_index = 0;
    }
    return self;
}

#pragma mark - update

- (void)updateWithTime:(NSTimeInterval)time
{
    _valid = [self validWithTime:time];
    _view.frame = [self rectWithTime:time];
}

- (CGRect)rectWithTime:(NSTimeInterval)time
{
    return CGRectMake(_origin.x, _origin.y, self.size.width, self.size.height);
}

- (BOOL)validWithTime:(NSTimeInterval)time
{
    return YES;
}

#pragma mark - launch

- (void)activeWithContext:(NSDictionary *)context
{
    CGRect rect = [[context objectForKey:kBarrageRendererContextCanvasBounds]CGRectValue];
    NSArray * spirits = [context objectForKey:kBarrageRendererContextRelatedSpirts];
    NSTimeInterval timestamp = [[context objectForKey:kBarrageRendererContextTimestamp]doubleValue];
    _timestamp = timestamp;
    _view = [self bindingView];
    [_view sizeToFit];
    _origin = [self originInBounds:rect withSpirits:spirits];
    _view.frame = CGRectMake(_origin.x, _origin.y, self.size.width, self.size.height);
}

/// 返回绑定的view
- (UIView *)bindingView
{
    return [[UIView alloc]init];
}

///  区域内的初始位置,只在刚加入渲染器的时候被调用;子类继承需要override.
- (CGPoint)originInBounds:(CGRect)rect withSpirits:(NSArray *)spirits
{
    CGFloat x = random_between(rect.origin.x, rect.origin.x+rect.size.width-self.size.width);
    CGFloat y = random_between(rect.origin.y, rect.origin.y+rect.size.height-self.size.height);
    return CGPointMake(x, y);
}

#pragma mark - attributes

- (CGPoint)position
{
    return self.view.frame.origin;
}

- (CGSize)size
{
    return self.view.bounds.size;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
#ifdef DEBUG
    NSLog(@"[Class:%@] hasNo - [Property:%@]; [Value:%@] will be discarded.",NSStringFromClass([self class]),key,value);
#endif
}

@end
