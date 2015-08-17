//
//  BarrageRepeatingWalkTextSpirit.m
//  BarrageRendererDemo
//
//  Created by UnAsh on 15/8/17.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import "BarrageRepeatingWalkTextSpirit.h"

@interface BarrageRepeatingWalkTextSpirit()
{
    NSTimeInterval _waitingTime; // 需要等待的时间
    NSTimeInterval _currentTime;
}
@property(nonatomic,assign)NSTimeInterval onceDuration; // 一次有效持续时间
@end

@implementation BarrageRepeatingWalkTextSpirit

- (instancetype)init
{
    if (self = [super init]) {
        _side = BarrageWalkSideRight; // 靠右行驶
    }
    return self;
}

- (CGPoint)originInBounds:(CGRect)rect withSpirits:(NSArray *)spirits
{
    // 获取同方向精灵
    NSMutableArray * synclasticSpirits = [[NSMutableArray alloc]initWithCapacity:spirits.count];
    for (BarrageRepeatingWalkTextSpirit * spirit in spirits) {
        if (spirit.direction == self.direction && spirit.side == self.side) {
            [synclasticSpirits addObject:spirit];
        }
    }
    
    // 必须等待的时间
    _waitingTime = 0;
    NSTimeInterval lastSpiritTimeStamp = 0;
    for (BarrageRepeatingWalkTextSpirit * spirit in synclasticSpirits) {
        if (spirit.timestamp > lastSpiritTimeStamp) {
            lastSpiritTimeStamp = spirit.timestamp;
            _waitingTime = [spirit estimateActiveTime];
        }
    }
    
    // 获取duration时间
    BOOL oritation = self.direction == BarrageWalkDirectionL2R || self.direction == BarrageWalkDirectionR2L; // 方向, YES代表水平弹幕
    CGPoint origin = CGPointZero;
    
    if (oritation) { // 水平
        if ((self.direction == BarrageWalkDirectionL2R && self.side == BarrageWalkSideLeft) || (self.direction == BarrageWalkDirectionR2L && self.side == BarrageWalkSideRight)) {
            _destination.y = origin.y = 0;
        }
        else if ((self.direction == BarrageWalkDirectionR2L && self.side == BarrageWalkSideLeft) || (self.direction == BarrageWalkDirectionL2R && self.side == BarrageWalkSideRight))
        {
            _destination.y = origin.y = rect.size.height - self.size.height;
        }
        else if (self.side == BarrageWalkSideMiddle)
        {
            _destination.y = origin.y = (rect.size.height - self.size.height)/2;
        }
        origin.x = (self.direction == BarrageWalkDirectionL2R)?rect.origin.x - self.size.width:rect.origin.x + rect.size.width;
        _destination.x = (self.direction == BarrageWalkDirectionL2R)?rect.origin.x + rect.size.width:rect.origin.x - self.size.width;
        self.onceDuration = fabs(_destination.x - origin.x)/self.speed;
    }
    else
    {
        if ((self.direction == BarrageWalkDirectionB2T && self.side == BarrageWalkSideLeft) || (self.direction == BarrageWalkDirectionT2B && self.side == BarrageWalkSideRight)) {
            _destination.x = origin.x = 0;
        }
        else if ((self.direction == BarrageWalkDirectionT2B && self.side == BarrageWalkSideLeft) || (self.direction == BarrageWalkDirectionB2T && self.side == BarrageWalkSideRight))
        {
            _destination.x = origin.x = rect.size.width - self.size.width;
        }
        else if (self.side == BarrageWalkSideMiddle)
        {
            _destination.x = origin.x = (rect.size.width - self.size.height)/2;
        }
        origin.y = (self.direction == BarrageWalkDirectionT2B)?rect.origin.y - self.size.height:rect.origin.y + rect.size.height;
        _destination.y = (self.direction == BarrageWalkDirectionT2B)?rect.origin.y + rect.size.height:rect.origin.y - self.size.height;
        self.onceDuration = fabs(_destination.y - origin.y)/self.speed;
    }
    return origin;
}

/// 估算精灵的剩余存活时间
- (NSTimeInterval)estimateActiveTime
{
    return self.onceDuration * self.repeatTime + _waitingTime - (_currentTime - self.timestamp);
}

- (void)updateWithTime:(NSTimeInterval)time
{
    _currentTime = time;
    [super updateWithTime:time];
}

- (CGRect)rectWithTime:(NSTimeInterval)time
{
    NSTimeInterval runningTime = time - self.timestamp - _waitingTime;
    if (runningTime < 0) {
        runningTime = 0;
    }
    NSTimeInterval duration = fmod(runningTime, self.onceDuration);
    CGFloat X = self.destination.x - self.origin.x;
    CGFloat Y = self.destination.y - self.origin.y;
    CGFloat L = sqrt(X*X + Y*Y);
    CGPoint position = CGPointMake(self.origin.x + duration * self.speed * X/L, self.origin.y + duration * self.speed * Y/L);
    return CGRectMake(position.x, position.y, self.size.width, self.size.height);
}

@end
