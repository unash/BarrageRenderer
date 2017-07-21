//
//  FlowerBarrageSprite.h
//  BarrageRendererDemo
//
//  Created by InAsh on 21/07/2017.
//  Copyright © 2017 ExBye Inc. All rights reserved.
//

#import <BarrageRenderer/BarrageRenderer.h>

@interface FlowerBarrageSprite : BarrageSprite

/// 存活时间
@property(nonatomic,assign)NSTimeInterval duration;
@property(nonatomic,assign)CGFloat scaleRatio;
@property(nonatomic,assign)CGFloat rotateRatio;

@end
