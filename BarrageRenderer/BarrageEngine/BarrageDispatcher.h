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

#import <Foundation/Foundation.h>

@class BarrageSpirit;
@protocol BarrageDispatchDelegate <NSObject>
@optional
- (BOOL)shouldActiveSpirit:(BarrageSpirit *)spirit;
@required
- (void)willActiveSpirit:(BarrageSpirit *)spirit;
- (void)willDeactiveSpirit:(BarrageSpirit *)spirit;
@end

/// 弹幕调度器,主要完成负载均衡的工作
@interface BarrageDispatcher : NSObject

- (instancetype)initWithStartTime:(NSDate *)startTime;

/// 添加精灵
- (void)addSpirit:(BarrageSpirit *)spirit;

/// 派发精灵,如果有变化,则返回YES; 否则返回NO
- (void)dispatchSpiritsWithPausedDuration:(NSTimeInterval)pausedDuration;

/// 是否开启过期精灵缓存功能,默认关闭,所以 deadSpirits.count = 0
@property (nonatomic,assign)BOOL cacheDeadSpirits;

@property (nonatomic,strong,readonly)NSArray * waitingSpirits;  // 当前等待的精灵
@property (nonatomic,strong,readonly)NSArray * activeSpirits;   // 当前活跃的精灵
@property (nonatomic,strong,readonly)NSArray * deadSpirits;     // 当前过期的精灵

/// 停止当前被激活的精灵
- (void)deactiveAllSpirits;

@property (nonatomic,weak)id<BarrageDispatchDelegate> delegate; //

@end
