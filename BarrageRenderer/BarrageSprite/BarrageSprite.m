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

#import "BarrageSprite.h"
#import "BarrageViewPool.h"

@interface BarrageSprite()
@property(nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic,assign)BOOL forcedInvalid;
@end

@implementation BarrageSprite

@synthesize mandatorySize = _mandatorySize;
@synthesize clickAction = _clickAction;

@synthesize origin = _origin;
@synthesize valid = _valid;
@synthesize view = _view;
@synthesize viewClassName = _viewClassName;

- (instancetype)init
{
    if (self = [super init]) {
        _delay = 0.0f;
        _birth = [NSDate date];
        _valid = YES;
        _origin.x = _origin.y = MAXFLOAT;
        _z_index = 0;
        _forcedInvalid = NO;
        _mandatorySize = CGSizeZero;
        
        _viewClassName = NSStringFromClass([UIView class]);
    }
    return self;
}

#pragma mark - update

- (void)updateWithTime:(NSTimeInterval)time
{
    _valid = !self.forcedInvalid && [self validWithTime:time];
    _view.frame = [self rectWithTime:time];
    if ([_view respondsToSelector:@selector(updateWithTime:)]) {
        [_view updateWithTime:time];
    }
}

- (CGRect)rectWithTime:(NSTimeInterval)time
{
    return CGRectMake(_origin.x, _origin.y, self.size.width, self.size.height);
}

- (BOOL)validWithTime:(NSTimeInterval)time
{
    return YES;
}

- (void)forceInvalid
{
    self.forcedInvalid = YES;
}

#pragma mark - active and deactive

- (void)activeWithContext:(NSDictionary *)context
{
    CGRect rect = [[context objectForKey:kBarrageRendererContextCanvasBounds]CGRectValue];
    NSArray * sprites = [context objectForKey:kBarrageRendererContextRelatedSpirts];
    NSTimeInterval timestamp = [[context objectForKey:kBarrageRendererContextTimestamp]doubleValue];
    _timestamp = timestamp;
    [[BarrageViewPool mainPool]assembleBarrageViewForSprite:self];
    [self initializeViewState];
    [self.view sizeToFit];
    if (!CGSizeEqualToSize(_mandatorySize, CGSizeZero)) {
        self.view.frame = CGRectMake(0, 0, _mandatorySize.width, _mandatorySize.height);
    }
    _origin = [self originInBounds:rect withSprites:sprites];
    self.view.frame = CGRectMake(_origin.x, _origin.y, self.size.width, self.size.height);
}

- (void)deactive
{
    [self restoreViewState];
    self.forcedInvalid = NO;
    [[BarrageViewPool mainPool]reclaimBarrageViewForSprite:self];
}

/// 恢复view状态，初始化view时使用
- (void)restoreViewState
{
    if (self.clickAction) {
        self.view.userInteractionEnabled = NO;
        [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    }
}

- (void)initializeViewState
{
    self.view.frame = CGRectZero;
    [self.view configureWithParams:self.viewParams];
    if (self.clickAction) {
        _view.userInteractionEnabled = YES;
        [_view addGestureRecognizer:self.tapGestureRecognizer];
    }
}

#pragma mark - gesture

- (UIGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSpriteView)];
    }
    return _tapGestureRecognizer;
}

- (void)clickSpriteView
{
    if (self.clickAction) self.clickAction(self.viewParams);
}

///  区域内的初始位置,只在刚加入渲染器的时候被调用;子类继承需要override.
- (CGPoint)originInBounds:(CGRect)rect withSprites:(NSArray *)sprites
{
    CGFloat x = random_between(rect.origin.x, rect.origin.x+rect.size.width-self.size.width);
    CGFloat y = random_between(rect.origin.y, rect.origin.y+rect.size.height-self.size.height);
    return CGPointMake(x, y);
}

#pragma mark - attributes

- (void)setClickAction:(BarrageClickAction)clickAction
{
    _clickAction = [clickAction copy];
}

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
    // NSLog(@"[Class:%@] hasNo - [Property:%@]; [Value:%@] will be discarded.",NSStringFromClass([self class]),key,value);
#endif
}

@end
