//
//  FlowerBarrageSprite.m
//  BarrageRendererDemo
//
//  Created by InAsh on 21/07/2017.
//  Copyright © 2017 ExBye Inc. All rights reserved.
//

#import "FlowerBarrageSprite.h"

@interface FlowerBarrageSprite()
{
    NSTimeInterval _leftActiveTime;
}
@property(nonatomic,assign)CGRect originRect;
@end

@implementation FlowerBarrageSprite

- (instancetype)init
{
    if (self = [super init]) {
        self.duration = 1.0f;
        self.scaleRatio = 2.0f;
        self.rotateRatio = 20.0f;
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    _leftActiveTime = _duration;
}

- (void)updateWithTime:(NSTimeInterval)time
{
    self.view.transform = CGAffineTransformIdentity;
    
    [super updateWithTime:time];
    
    CGFloat x = self.originRect.origin.x;
    CGFloat y = (self.originRect.origin.y+self.originRect.size.height)*(self.duration - (time - self.timestamp))/self.duration;
    self.view.frame = CGRectMake(x, y, self.originRect.size.width, self.originRect.size.height);
    
    _leftActiveTime = self.duration - (time - self.timestamp);
    CGFloat ratio = 1-_leftActiveTime/self.duration;
    self.view.alpha = 1-ratio;
    
    CGFloat rotateRatio = ratio*self.rotateRatio;
    CGFloat scaleRatio = pow(self.scaleRatio, ratio);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleRatio, scaleRatio);
    transform = CGAffineTransformRotate(transform, M_PI*rotateRatio);
    
    self.view.transform = transform;
}

- (CGRect)rectWithTime:(NSTimeInterval)time
{
    return self.view.frame;
}

- (NSTimeInterval)estimateActiveTime
{
    return _leftActiveTime;
}

- (BOOL)validWithTime:(NSTimeInterval)time
{
    return [self estimateActiveTime] > 0;
}

- (CGPoint)originInBounds:(CGRect)rect withSprites:(NSArray *)sprites
{    
    CGPoint origin = CGPointZero;
    _originRect.size.height = self.size.height;
    _originRect.size.width = self.size.width;
    origin.x = (rect.origin.x+rect.size.width-self.size.width)/2+200*((double)random()/RAND_MAX-0.5);
    origin.y = rect.origin.y+rect.size.height;
    _originRect.origin = origin;
    return origin;
}

@end
