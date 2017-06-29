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

#import "BarrageViewPool.h"
#import "BarrageSpriteProtocol.h"
#import "BarrageSprite.h"

@interface BarrageViewPool ()
{
    NSMutableDictionary<NSString *,NSMutableArray<id<BarrageViewProtocol>>*> *_reusableViews;
}
@end

@implementation BarrageViewPool

+ (instancetype)mainPool
{
    static BarrageViewPool *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[BarrageViewPool alloc]init];
    });
    return pool;
}

- (instancetype)init
{
    if (self = [super init]) {
        _reusableViews = [[NSMutableDictionary alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearReusableSpriteViews) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearReusableSpriteViews
{
    [_reusableViews removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - assistant
- (NSMutableArray<id<BarrageViewProtocol>>*)viewsForViewClassifier:(NSString *)classifier
{
    NSMutableArray *views = _reusableViews[classifier];
    if (!views) {
        views = [[NSMutableArray alloc]init];
        _reusableViews[classifier] = views;
    }
    return views;
}

- (NSString *)viewClassifierForSprite:(BarrageSprite *)sprite
{
    NSString *classifier = [NSString stringWithFormat:@"%@.%@",NSStringFromClass([self class]),sprite.viewClassName];
    return classifier;
}

#pragma mark - interface
/// 装配 view
- (void)assembleBarrageViewForSprite:(BarrageSprite *)sprite;
{
    NSParameterAssert(sprite.viewClassName.length>0);
    Class class = NSClassFromString(sprite.viewClassName);
    NSParameterAssert([class conformsToProtocol:@protocol(BarrageViewProtocol)]);
    
    NSString *classifier = [self viewClassifierForSprite:sprite];
    NSMutableArray *views = [self viewsForViewClassifier:classifier];
    
    UIView<BarrageViewProtocol> *view = [views firstObject];
    if (!view) {
        view = [[class alloc]initWithFrame:CGRectZero];
    }
    else
    {
        [view prepareForReuse];
        [views removeObject:view];
    }
    sprite.view = view;
}

/// 归还 view
- (void)reclaimBarrageViewForSprite:(BarrageSprite *)sprite;
{
    NSParameterAssert([sprite.view conformsToProtocol:@protocol(BarrageViewProtocol)]);
    NSString *classifier = [self viewClassifierForSprite:sprite];
    NSMutableArray *views = [self viewsForViewClassifier:classifier];
    if (![views containsObject:sprite.view]) {
        [views addObject:sprite.view];
    }
    sprite.view = nil;
}

@end
