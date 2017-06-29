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

#import "BarrageSpriteQueue.h"
#import "BarrageSprite.h"

@interface BarrageSpriteQueue ()
@property(nonatomic,strong,readonly)NSMutableArray<BarrageSprite *> *sprites; // 增序排列
- (instancetype)initWithAscendingSprites:(NSArray<BarrageSprite *> *)sprites;
@end

@implementation BarrageSpriteQueue

- (instancetype)init
{
    return [self initWithAscendingSprites:nil];
}

- (instancetype)initWithAscendingSprites:(NSArray<BarrageSprite *> *)sprites
{
    if (self = [super init]) {
        _sprites = sprites?[sprites mutableCopy]:[NSMutableArray new];
    }
    return self;
}

#pragma mark - interface

- (void)addSprite:(BarrageSprite *)sprite
{
    NSInteger index = [self indexForSprite:sprite];
    [self.sprites insertObject:sprite atIndex:index];
}

- (NSArray *)ascendingSprites
{
    return [self.sprites copy];
}

- (NSArray *)descendingSprites
{
    return [[self.sprites reverseObjectEnumerator]allObjects];
}

- (void)removeSprite:(BarrageSprite *)sprite
{
    [self.sprites removeObject:sprite];
}

- (void)removeSprites:(NSArray<BarrageSprite *> *)sprites
{
    [self.sprites removeObjectsInArray:sprites];
}

- (instancetype)spriteQueueWithDelayLessThanOrEqualTo:(NSTimeInterval)delay
{
    return [self spriteQueueWithDelayLessThan:delay equal:YES];
}

- (instancetype)spriteQueueWithDelayLessThan:(NSTimeInterval)delay
{
    return [self spriteQueueWithDelayLessThan:delay equal:NO];
}

- (instancetype)spriteQueueWithDelayLessThan:(NSTimeInterval)delay equal:(BOOL)equal
{
    NSInteger total = self.sprites.count;
    NSInteger index = [self indexForSpriteDelay:delay];
    while (index <= total-1) {
        BarrageSprite *sprite = self.sprites[index];
        if ((equal && sprite.delay > delay)||(!equal && sprite.delay>=delay)) {
            break;
        } else {
            index++;
        }
    }
    while (!equal && index>0 && self.sprites[index-1].delay==delay) {
        index--;
    }
    if (index < 1) {
        return [[BarrageSpriteQueue alloc]init];
    } else {
        NSArray *subArray = [self.sprites subarrayWithRange:NSMakeRange(0, index)];
        return [[BarrageSpriteQueue alloc]initWithAscendingSprites:subArray];
    }
}

- (instancetype)spriteQueueWithDelayGreaterThanOrEqualTo:(NSTimeInterval)delay
{
    return [self spriteQueueWithDelayGreaterThan:delay equal:YES];
}

- (instancetype)spriteQueueWithDelayGreaterThan:(NSTimeInterval)delay
{
    return [self spriteQueueWithDelayGreaterThan:delay equal:NO];
}

- (instancetype)spriteQueueWithDelayGreaterThan:(NSTimeInterval)delay equal:(BOOL)equal
{
    NSInteger total = self.sprites.count;
    NSInteger index = [self indexForSpriteDelay:delay];
    index--;
    while (index >= 0) {
        BarrageSprite *sprite = self.sprites[index];
        if ((equal && sprite.delay < delay)||(!equal && sprite.delay<=delay)) {
            break;
        } else {
            index--;
        }
    }
    while (!equal && index<total-1 && self.sprites[index+1].delay==delay) {
        index++;
    }
    if (index >= total-1) {
        return [[BarrageSpriteQueue alloc]init];
    } else {
        NSArray *subArray = [self.sprites subarrayWithRange:NSMakeRange(index+1, total-index-1)];
        return [[BarrageSpriteQueue alloc]initWithAscendingSprites:subArray];
    }
}

#pragma mark - util

// 找到则返回元素在数组中的下标，如果没找到，则返回这个元素在有序数组中的位置
- (NSInteger)indexForSpriteDelay:(NSTimeInterval)delay
{
    NSInteger min = 0;
    NSInteger max = self.sprites.count - 1;
    NSInteger mid = 0;
    while (min <= max) {
        mid = (min + max) >> 1;
        BarrageSprite *baseSprite = self.sprites[mid];
        if (delay > baseSprite.delay) {
            min = mid + 1;
        } else if (delay < baseSprite.delay) {
            max = mid - 1;
        } else {
            return mid;
        }
    }
    return min;
}

- (NSInteger)indexForSprite:(BarrageSprite *)sprite
{
    return [self indexForSpriteDelay:sprite.delay];
}

@end
