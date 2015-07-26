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
@class BarrageDescriptor;

//TODO: 添加对弹幕隐藏功能的支持

/// 弹幕渲染器
@interface BarrageRenderer : NSObject

#pragma mark - life cycle

#pragma mark - control

/// 启动弹幕, 内部时钟从0开始
/// 若是stop之后的start,则start函数内部会清空records.
/// 视频开始的时候需要同时运行此方法
- (void)start;

/// 暂定, 已经渲染上去的保持不变, 此时发送弹幕无效, 内部时钟暂停
/// 视频暂停的时候需要同时运行此方法
- (void)pause;

/// 停止弹幕渲染, 会清空所有; 再发弹幕就无效了; 一切都会停止
/// 此方法在不再需要弹幕的时候必须调用,否则可能造成内存泄露
- (void)stop;

/// 接收弹幕消息
- (void)receive:(BarrageDescriptor *)descriptor;

/// 调整弹幕反应,需要>0,否则会被抛弃
@property(nonatomic,assign)CGFloat speed;

/// 返回给外部的view
@property(nonatomic,weak)UIView * view;

#pragma mark - z-index

/// 是否开启z-index功能,开启之后,性能会稍有降低,绘图会按照z_index进行,值越大,越靠上;默认关闭.
@property(nonatomic,assign)BOOL zIndex;

#pragma mark - record

/// 如需要记录,需要在运行start之后立即运行此函数,内部会通过时间差计算delay.
/// 记录弹幕,可能会序列化到本地; 默认为NO
@property(nonatomic,assign)BOOL recording;

/// 加载已经存在的弹幕,应该在start运行之后立刻就把已有的弹幕描述数组加载进来
/// 什么时期开始录制的弹幕,就要什么时期加载.
- (void)load:(NSArray *)descriptors;

/// 弹幕记录文件
- (NSArray *)records;

@end