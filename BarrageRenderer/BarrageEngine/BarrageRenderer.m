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

#import "BarrageRenderer.h"
#import "BarrageCanvas.h"
#import "BarrageDispatcher.h"
#import "BarrageSpirit.h"
#import "BarrageSpiritFactory.h"
#import "BarrageClock.h"
#import "BarrageDescriptor.h"

NSString * const kBarrageRendererContextCanvasBounds = @"kBarrageRendererContextCanvasBounds";   // 画布大小
NSString * const kBarrageRendererContextRelatedSpirts = @"kBarrageRendererContextRelatedSpirts"; // 相关精灵
NSString * const kBarrageRendererContextTimestamp = @"kBarrageRendererContextTimestamp";         // 时间戳

@interface BarrageRenderer()<BarrageDispatchDelegate>
{
    BarrageDispatcher * _dispatcher; //调度器
    BarrageCanvas * _canvas; // 画布
    BarrageClock * _clock;
    NSMutableDictionary * _spiritClassMap;
    __block NSTimeInterval _time;
    NSMutableDictionary * _context; // 渲染器上下文
    
    NSMutableArray * _records;//记录数组
    NSDate * _startTime; //如果是nil,表示弹幕渲染不在运行中; 否则,表示开始的时间
    NSTimeInterval _pausedDuration; // 暂停持续时间
    NSDate * _pausedTime; // 上次暂停时间; 如果为nil, 说明当前没有暂停
}
@property(nonatomic,assign)NSTimeInterval pausedDuration; // 暂停时间
@end

@implementation BarrageRenderer
@synthesize pausedDuration = _pausedDuration;
#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {
        _canvas = [[BarrageCanvas alloc]init];
        _spiritClassMap = [[NSMutableDictionary alloc]init];
        _zIndex = NO;
        _context = [[NSMutableDictionary alloc]init];
        _recording = NO;
        _startTime = nil; // 尚未开始
        _pausedTime = nil;
        self.pausedDuration = 0;
        [self initClock];
    }
    return self;
}

/// 初始化时钟
- (void)initClock
{
    __weak id weakSelf = self;
    _clock = [BarrageClock clockWithHandler:^(NSTimeInterval time){
        BarrageRenderer * strongSelf = weakSelf;
        _time = time;
        [strongSelf update];
    }];
}

#pragma mark - control
- (void)receive:(BarrageDescriptor *)descriptor
{
    if (!_startTime) { // 如果没有启动,则抛弃接收弹幕
        return;
    }
    [self convertDelayTime:descriptor];
    BarrageSpirit * spirit = [BarrageSpiritFactory createSpiritWithDescriptor:descriptor];
    [_dispatcher addSpirit:spirit];
    if (_recording) {
        [self recordDescriptor:descriptor];
    }
}

- (void)start
{
    if (!_startTime) { // 尚未启动,则初始化时间系统
        _startTime = [NSDate date];
        _records = [[NSMutableArray alloc]init];
        _dispatcher = [[BarrageDispatcher alloc]initWithStartTime:_startTime];
        _dispatcher.delegate = self;
    }
    else if(_pausedTime)
    {
        _pausedDuration += [[NSDate date]timeIntervalSinceDate:_pausedTime];
    }
    _pausedTime = nil;
    [_clock start];
}

- (void)pause
{
    if (!_startTime) { // 没有运行, 则暂停无效
        return;
    }
    if (!_pausedTime) { // 当前没有暂停
        [_clock pause];
        _pausedTime = [NSDate date];
    }
    else
    {
        _pausedDuration += [[NSDate date]timeIntervalSinceDate:_pausedTime];
        _pausedTime = [NSDate date];
    }
}

- (void)stop
{
    _startTime = nil;
    [_clock stop];
    [_dispatcher deactiveAllSpirits];
}

- (void)setSpeed:(CGFloat)speed
{
    if (speed > 0) {
        _clock.speed = speed;
    }
}

- (CGFloat)speed
{
    return _clock.speed;
}

- (NSTimeInterval)pausedDuration
{
    return _pausedDuration + (_pausedTime?[[NSDate date]timeIntervalSinceDate:_pausedTime]:0); // 当前处于暂停当中
}

/// 转换descriptor的delay时间(相对于start), 如果delay<0, 则将delay置为0
- (void)convertDelayTime:(BarrageDescriptor *)descriptor
{
    NSTimeInterval delay = [[descriptor.params objectForKey:@"delay"]doubleValue];
    delay += [[NSDate date]timeIntervalSinceDate:_startTime]-self.pausedDuration;
    if (delay < 0) {
        delay = 0;
    }
    [descriptor.params setObject:@(delay) forKey:@"delay"];
}

#pragma mark - record
/// 此方法会修改desriptor的值
- (void)recordDescriptor:(BarrageDescriptor *)descriptor
{
    __block BOOL exists = NO;
    [_records enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL * stop){
        if([((BarrageDescriptor *)obj).identifier isEqualToString:descriptor.identifier]){
            exists = YES;
            *stop = YES;
        }
    }];
    if(!exists){
        [_records addObject:descriptor];
    }
}

- (NSArray *)records
{
    return [_records copy];
}

- (void)load:(NSArray *)descriptors
{
    for (BarrageDescriptor * descriptor in descriptors) {
        [self receive:descriptor];
    }
}

#pragma mark - update
/// 每个刷新周期执行一次
- (void)update
{
    [_dispatcher dispatchSpiritsWithPausedDuration:self.pausedDuration]; // 分发精灵
    for (BarrageSpirit * spirit in _dispatcher.activeSpirits) {
        [spirit updateWithTime:_time];
    }
}

#pragma mark - BarrageDispatchDelegate

- (BOOL)shouldActiveSpirit:(BarrageSpirit *)spirit
{
    return !_pausedTime;
}

- (void)willActiveSpirit:(BarrageSpirit *)spirit
{
    NSValue * value = [NSValue valueWithCGRect:_canvas.bounds];
    [_context setObject:value forKey:kBarrageRendererContextCanvasBounds];
    
    NSArray * itemMap = [_spiritClassMap objectForKey:NSStringFromClass([spirit class])];
    if (itemMap) {
        [_context setObject:[itemMap copy] forKey:kBarrageRendererContextRelatedSpirts];
    }
    
    [_context setObject:@(_time) forKey:kBarrageRendererContextTimestamp];
    
    NSInteger index = [self viewIndexOfSpirit:spirit];
    
    [spirit activeWithContext:_context];
    [self indexAddSpirit:spirit];
    [_canvas insertSubview:spirit.view atIndex:index];
}

- (NSUInteger)viewIndexOfSpirit:(BarrageSpirit *)spirit
{
    NSInteger index = _dispatcher.activeSpirits.count;
    
    /// 添加根据z-index 增序排列
    if (self.zIndex) {
        NSMutableArray * preSpirits = [[NSMutableArray alloc]initWithArray:_dispatcher.activeSpirits];
        [preSpirits addObject:spirit];
        NSArray * sortedSpirits = [preSpirits sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [@(((BarrageSpirit *)obj1).z_index) compare:@(((BarrageSpirit *)obj2).z_index)];
        }];
        index = [sortedSpirits indexOfObject:spirit];
    }
    return index;
}

- (void)willDeactiveSpirit:(BarrageSpirit *)spirit
{
    [self indexRemoveSpirit:spirit];
    [spirit.view removeFromSuperview];
}

#pragma mark - indexing className-spirits
/// 更新活跃精灵类型索引
- (void)indexAddSpirit:(BarrageSpirit *)spirit
{
    NSString * className = NSStringFromClass([spirit class]);
    NSMutableArray * itemMap = [_spiritClassMap objectForKey:className];
    if (!itemMap) {
        itemMap = [[NSMutableArray alloc]init];
        [_spiritClassMap setObject:itemMap forKey:className];
    }
    [itemMap addObject:spirit];
}

/// 更新活跃精灵类型索引
- (void)indexRemoveSpirit:(BarrageSpirit *)spirit
{
    NSString * className = NSStringFromClass([spirit class]);
    NSMutableArray * itemMap = [_spiritClassMap objectForKey:className];
    if (!itemMap) {
        itemMap = [[NSMutableArray alloc]init];
        [_spiritClassMap setObject:itemMap forKey:className];
    }
    [itemMap removeObject:spirit];
}

#pragma mark - attributes

- (UIView *)view
{
    return _canvas;
}

@end
