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

#import "BarrageDispatcher.h"
#import "BarrageSprite.h"
#import "BarrageSpriteQueue.h"

@interface BarrageDispatcher()
{
    NSMutableArray * _activeSprites;
    BarrageSpriteQueue *_waitingSpriteQueue; /// 当前等待的精灵队列.
    NSMutableArray * _deadSprites; /// 当前过期的精灵.
    NSTimeInterval _previousTime;
    CGFloat _smoothness;
}

@end

@implementation BarrageDispatcher

- (instancetype)init
{
    if (self = [super init]) {
        _activeSprites = [[NSMutableArray alloc]init];
        _waitingSpriteQueue = [[BarrageSpriteQueue alloc]init];
        _deadSprites = [[NSMutableArray alloc]init];
        _cacheDeadSprites = NO;
        _previousTime = 0.0f;
    }
    return self;
}

- (void)setDelegate:(id<BarrageDispatcherDelegate>)delegate
{
    _delegate = delegate;
    _previousTime = [self currentTime];
}

- (NSTimeInterval)currentTime
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeForBarrageDispatcher:)]) {
        return [self.delegate timeForBarrageDispatcher:self];
    }
    return 0.0f;
}

- (void)addSprite:(BarrageSprite *)sprite
{
    if ([sprite isKindOfClass:[BarrageSprite class]]) {
        [_waitingSpriteQueue addSprite:sprite];
    }
}

/// 停止当前被激活的精灵
- (void)deactiveAllSprites
{
    for (NSInteger i = 0; i < _activeSprites.count; i ++) { // 活跃精灵队列
        BarrageSprite * sprite = [_activeSprites objectAtIndex:i];
        if (_cacheDeadSprites) {
            [_deadSprites addObject:sprite];
        }
        [self deactiveSprite:sprite];
        [_activeSprites removeObjectAtIndex:i--];
    }
}

- (void)setSmoothness:(CGFloat)smoothness
{
    if (smoothness<0) {
        smoothness = 0;
    } else if (smoothness > 1) {
        smoothness = 1;
    }
    _smoothness = smoothness;
}

/// 派发精灵
- (void)dispatchSprites
{
    for (NSInteger i = 0; i < _activeSprites.count; i ++) {
        BarrageSprite * sprite = [_activeSprites objectAtIndex:i];
        if (!sprite.isValid) {
            if (_cacheDeadSprites) {
                [_deadSprites addObject:sprite];
            }
            [self deactiveSprite:sprite];
            [_activeSprites removeObjectAtIndex:i--];
        }
    }
    // 弹幕最大保留时间, 当视频快进时，有可能大于timeWindow
    static NSTimeInterval const MAX_EXPIRED_SPRITE_RESERVED_TIME = 0.5f; // 经验值
    static NSTimeInterval const DISPATCHER_SMOOTH_FACTOR = 5.0f; // 经验值
    NSTimeInterval currentTime = [self currentTime];
    NSTimeInterval timeWindow = currentTime - _previousTime; // 有可能为正,也有可能为负(如果倒退的话)
//    NSLog(@"内部时间:%f -- 变化时间:%f",currentTime,timeWindow);
    //如果是正, 可能是正常时钟,也可能是快进
    if (timeWindow >= 0) {
        BarrageSpriteQueue *queue = [_waitingSpriteQueue spriteQueueWithDelayLessThanOrEqualTo:currentTime];
        NSArray *participants = [queue ascendingSprites];
        NSMutableArray *candidates = [NSMutableArray arrayWithCapacity:participants.count];
        
        for (NSInteger i = 0; i < participants.count; i++) {
            BarrageSprite * sprite = [participants objectAtIndex:i];
            NSTimeInterval overtime = currentTime - sprite.delay;
            //NSLog(@"%f",overtime);
            if ((_smoothness>0.0f || overtime < timeWindow) && overtime <= MAX_EXPIRED_SPRITE_RESERVED_TIME) {
                if ([self shouldActiveSprite:sprite]) {
                    [candidates addObject:sprite];
                } else {
                    [_waitingSpriteQueue removeSprite:sprite];
                }
            }
            else
            {
                if (_cacheDeadSprites) {
                    [_deadSprites addObject:sprite];
                }
                [_waitingSpriteQueue removeSprite:sprite];
            }
        }
        
        NSInteger count = candidates.count;
        
        if (_smoothness>0.0f) { //可以优化掉此判断
            NSInteger frequence = (NSInteger)floorf(MAX_EXPIRED_SPRITE_RESERVED_TIME * DISPATCHER_SMOOTH_FACTOR/timeWindow * _smoothness); // 估算平滑频率
            if (count>0 && frequence>=1) {
                count = MAX(1, ceil(count/frequence));
            }
        }

        for (NSInteger i = 0; i < count; i++) {
            BarrageSprite *sprite = candidates[i];
            [self activeSprite:sprite];
            //NSLog(@"%@",sprite.viewParams[@"text"]);
            [_activeSprites addObject:sprite];
            [_waitingSpriteQueue removeSprite:sprite];
        }
    }
    else // 倒退,需要起死回生
    {
        for (NSInteger i = 0; i < _deadSprites.count; i++) { // 活跃精灵队列
            BarrageSprite * sprite = [_deadSprites objectAtIndex:i];
            if (sprite.delay > currentTime) {
                [_waitingSpriteQueue addSprite:sprite];
                [_deadSprites removeObjectAtIndex:i--];
            }
            else if (sprite.delay == currentTime)
            {
                if ([self shouldActiveSprite:sprite]) {
                    [self activeSprite:sprite];
                    [_activeSprites addObject:sprite];
                    [_deadSprites removeObjectAtIndex:i--];
                }
            }
        }
    }
    
    _previousTime = currentTime;
}

/// 是否可以激活精灵
- (BOOL)shouldActiveSprite:(BarrageSprite *)sprite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldActiveSprite:)]) {
        return [self.delegate shouldActiveSprite:sprite];
    }
    return YES;
}

/// 激活精灵
- (void)activeSprite:(BarrageSprite *)sprite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willActiveSprite:)]) {
        [self.delegate willActiveSprite:sprite];
    }
}

/// 精灵失活
- (void)deactiveSprite:(BarrageSprite *)sprite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDeactiveSprite:)]) {
        [self.delegate willDeactiveSprite:sprite];
    }
}

@end
