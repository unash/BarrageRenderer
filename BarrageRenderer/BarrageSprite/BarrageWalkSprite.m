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

#import "BarrageWalkSprite.h"

static NSUInteger const STRIP_NUM = 160; // 总共的网格条数

@interface BarrageWalkSprite ()
{
    BarrageWalkDirection _direction;
}
@end

@implementation BarrageWalkSprite
@synthesize direction = _direction;
@synthesize destination = _destination;

- (instancetype)init
{
    if (self = [super init]) {
        _direction = BarrageWalkDirectionR2L;
        _side = BarrageWalkSideDefault;
        _speed = 30.0f; // 默认值
        _trackNumber = 40;
        _avoidCollision = NO;
    }
    return self;
}

- (BarrageWalkSide)side
{
    if (_side != BarrageWalkSideDefault) return _side;
    return [self defaultSideWithDirection:self.direction];
}

- (BarrageWalkSide)defaultSideWithDirection:(BarrageWalkDirection)direction
{
    if (direction == BarrageWalkDirectionR2L) return BarrageWalkSideRight;
    else if (direction == BarrageWalkDirectionL2R) return BarrageWalkSideLeft;
    else if (direction == BarrageWalkDirectionT2B) return BarrageWalkSideRight;
    else if (direction == BarrageWalkDirectionB2T) return BarrageWalkSideLeft;
    return BarrageWalkSideRight; // Chinese way
}

#pragma mark - update

- (BOOL)validWithTime:(NSTimeInterval)time
{
    return [self estimateActiveTime] > 0;
}

- (CGRect)rectWithTime:(NSTimeInterval)time
{
    CGFloat X = self.destination.x - self.origin.x;
    CGFloat Y = self.destination.y - self.origin.y;
    CGFloat L = sqrt(X * X + Y * Y);
    NSTimeInterval duration = time - self.timestamp;
    CGPoint position = CGPointMake(self.origin.x + duration * self.speed * X / L, self.origin.y + duration * self.speed * Y / L);
    return CGRectMake(position.x, position.y, self.size.width, self.size.height);
}

/// 估算精灵的剩余存活时间
- (NSTimeInterval)estimateActiveTime
{
    CGFloat activeDistance = 0;
    switch (_direction) {
        case BarrageWalkDirectionR2L:
            activeDistance = self.position.x - _destination.x;
            break;
        case BarrageWalkDirectionL2R:
            activeDistance = _destination.x - self.position.x;
            break;
        case BarrageWalkDirectionT2B:
            activeDistance = _destination.y - self.position.y;
            break;
        case BarrageWalkDirectionB2T:
            activeDistance = self.position.y - _destination.y;
        default:
            break;
    }
    return activeDistance / self.speed;
}

// 估算全部显示到界面的时间
- (NSTimeInterval)estimateAllDisplayedTime:(CGRect)rect {
    CGFloat activeDistance = 0;
    switch (_direction) {
        case BarrageWalkDirectionR2L:
            activeDistance = self.position.x - _destination.x - rect.size.width;
            break;
        case BarrageWalkDirectionL2R:
            activeDistance = _destination.x - self.position.x - rect.size.width;
            break;
        case BarrageWalkDirectionT2B:
            activeDistance = _destination.y - self.position.y - rect.size.height;
            break;
        case BarrageWalkDirectionB2T:
            activeDistance = self.position.y - _destination.y - rect.size.height;
        default:
            break;
    }
    return activeDistance / self.speed;
}

#pragma mark - launch

- (CGPoint)originInBounds:(CGRect)rect withSprites:(NSArray *)sprites
{
    // 获取同方向精灵
    NSMutableArray *synclasticSprites = [[NSMutableArray alloc]initWithCapacity:sprites.count];
    for (BarrageWalkSprite *sprite in sprites) {
        if (sprite.direction == _direction && sprite.side == self.side) { // 找寻同道中人
            [synclasticSprites addObject:sprite];
        }
    }

    // 每一条网格 已有精灵中最后退出屏幕的时间
    NSTimeInterval stripMaxActiveTimes[STRIP_NUM] = { 0 };
    // 每一条网格 包含精灵的数目
    NSUInteger stripSpriteNumbers[STRIP_NUM] = { 0 };
    // between (1,STRIP_NUM)
    NSUInteger stripNum = MIN(STRIP_NUM, MAX(self.trackNumber, 1));
    // 每一条网格水平条高度
    CGFloat stripHeight = rect.size.height / stripNum;
    // 竖直条宽度
    CGFloat stripWidth = rect.size.width / stripNum;
    // 是否水平弹幕
    BOOL horizontal = (_direction == BarrageWalkDirectionL2R || _direction == BarrageWalkDirectionR2L);
    // 是否翻转，从右到左就是翻转
    BOOL rotation = (self.side == [self defaultSideWithDirection:_direction]);
    /// 计算数据结构,便于应用算法
    
    // 精灵占用（横跨）的网格条数目
    NSUInteger overlandStripNum = 1;
    if (horizontal) { // 水平
        overlandStripNum = (NSUInteger)ceil((double)self.size.height / stripHeight);
    } else { // 竖直
        overlandStripNum = (NSUInteger)ceil((double)self.size.width / stripWidth);
    }
    NSUInteger availableFrom = 0;

    for (NSUInteger i = 0; i < stripNum; i++) {
        // 寻找当前行里包含的sprites
        CGFloat stripFrom = i * (horizontal ? stripHeight : stripWidth);
        CGFloat stripTo = stripFrom + (horizontal ? stripHeight : stripWidth);
        if (!rotation) {
            CGFloat preStripFrom = stripFrom;
            stripFrom = (horizontal ? rect.size.height : rect.size.width) - stripTo;
            stripTo = (horizontal ? rect.size.height : rect.size.width) - preStripFrom;
        }
        for (BarrageWalkSprite *sprite in synclasticSprites) {
            CGFloat spriteFrom = horizontal ? sprite.origin.y : sprite.origin.x;
            CGFloat spriteTo = spriteFrom + (horizontal ? sprite.size.height : sprite.size.width);
            // 在条条里
            if ((spriteTo - spriteFrom) + (stripTo - stripFrom) > MAX(stripTo - spriteFrom, spriteTo - stripFrom)) {
                stripSpriteNumbers[i]++;
                NSTimeInterval displayedTime = [sprite estimateAllDisplayedTime:rect];
                // 获取最慢的那个
                if (displayedTime > stripMaxActiveTimes[i]) {
                    stripMaxActiveTimes[i] = displayedTime;
                }
            }
        }
        if (stripMaxActiveTimes[i] > 0) {
            availableFrom = i + 1;
        } else if (i - availableFrom >= overlandStripNum - 1) {
            break;
        }
    }
    if (availableFrom > stripNum - overlandStripNum) {
        // 没有找到的话，返回0，上层不处理
        return CGPointZero;
    }

    CGPoint origin = CGPointZero;
    if (horizontal) {
         origin.y = (rotation ? stripHeight * availableFrom : rect.size.height - stripHeight * availableFrom - self.size.height) + rect.origin.y;
        _destination.y = origin.y;
        origin.x = (self.direction == BarrageWalkDirectionL2R) ? rect.origin.x - self.size.width : rect.origin.x + rect.size.width;
        _destination.x = (self.direction == BarrageWalkDirectionL2R) ? rect.origin.x + rect.size.width : rect.origin.x - self.size.width;
    } else {
        _destination.x = origin.x = (rotation ? stripWidth * availableFrom : rect.size.width - stripWidth * availableFrom - self.size.width) + rect.origin.x;
        origin.y = (self.direction == BarrageWalkDirectionT2B) ? rect.origin.y - self.size.height : rect.origin.y + rect.size.height;
        _destination.y = (self.direction == BarrageWalkDirectionT2B) ? rect.origin.y + rect.size.height : rect.origin.y - self.size.height;
    }
    return origin;
}

@end
