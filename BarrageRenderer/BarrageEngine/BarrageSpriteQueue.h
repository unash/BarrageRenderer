//
//  BarrageSpriteQueue.h
//  Pods
//
//  Created by UnAsh on 2017/6/16.
//
//

#import <Foundation/Foundation.h>

@class BarrageSprite;
@interface BarrageSpriteQueue : NSObject

/// 添加精灵
- (void)addSprite:(BarrageSprite *)sprite;

/// 移除精灵
- (void)removeSprite:(BarrageSprite *)sprite;
- (void)removeSprites:(NSArray<BarrageSprite *> *)sprites;

/// 筛选过滤
- (instancetype)spriteQueueWithDelayLessThanOrEqualTo:(NSTimeInterval)delay;
- (instancetype)spriteQueueWithDelayLessThan:(NSTimeInterval)delay;
- (instancetype)spriteQueueWithDelayGreaterThanOrEqualTo:(NSTimeInterval)delay;
- (instancetype)spriteQueueWithDelayGreaterThan:(NSTimeInterval)delay;

/// 依据delay增序
- (NSArray *)ascendingSprites;

/// 依据delay降序
- (NSArray *)descendingSprites;

@end
