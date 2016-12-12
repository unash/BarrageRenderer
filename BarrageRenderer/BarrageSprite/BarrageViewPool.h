//
//  BarrageViewPool.h
//  Pods
//
//  Created by UnAsh on 16/12/12.
//
//

#import <Foundation/Foundation.h>

/// 虽如是, 性能提升并不明显; 因为性能的瓶颈在于GPU绘制，而非CPU创建对象

@class BarrageSprite;

@interface BarrageViewPool : NSObject

+ (instancetype)mainPool;

/// 装配 view
- (void)assembleBarrageViewForSprite:(BarrageSprite *)sprite;

/// 归还 view
- (void)reclaimBarrageViewForSprite:(BarrageSprite *)sprite;

@end
