//
//  BarrageRepeatingWalkTextSpirit.h
//  BarrageRendererDemo
//
//  Created by UnAsh on 15/8/17.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import "BarrageWalkTextSpirit.h"

typedef NS_ENUM(NSInteger, BarrageWalkSide) { // 前进方向的...
    BarrageWalkSideLeft = 1,
    BarrageWalkSideMiddle = 2,
    BarrageWalkSideRight = 3
};

/// 循环轮播弹幕
@interface BarrageRepeatingWalkTextSpirit : BarrageWalkTextSpirit

@property(nonatomic,assign)NSInteger repeatTime; // 循环次数

@property(nonatomic,assign)BarrageWalkSide side; // 靠哪一侧

@end
