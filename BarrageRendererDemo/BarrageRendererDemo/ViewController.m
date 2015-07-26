//
//  BarrageTestController.m
//  demo_app_main
//
//  Created by UnAsh on 15/7/10.
//  Copyright (c) 2015年 UnAsh. All rights reserved.
//

#import "ViewController.h"
#import "BarrageHeader.h"
#import "NSSafeObject.h"
#import "BarrageSpiritUtility.h"

@interface ViewController()
{
    BarrageRenderer * _renderer;
    NSTimer * _timer;
    NSInteger _index;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _index = 0;
    _renderer = [[BarrageRenderer alloc]init];
    [_renderer setSpeed:1.0f];
    [self.view addSubview:_renderer.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_renderer start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self bashSendBarrage];
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    [self performSelector:@selector(viewChanged) withObject:nil afterDelay:10.0f];
}

- (void)viewChanged
{
    [_renderer setSpeed:2.0f];
}

- (void)dealloc
{
    [_renderer stop];
}

- (void)autoSendBarrage
{
    [_renderer receive:[self floatTextSpiritDescriptor]];
    [_renderer receive:[self walkTextSpiritDescriptor]];
}

- (void)bashSendBarrage
{
    for (int i = 0; i < 30; i++) {
        [_renderer receive:[self floatTextSpiritDescriptor]];
        [_renderer receive:[self walkTextSpiritDescriptor]];
    }
}

/// 生成精灵描述
- (BarrageDescriptor *)walkTextSpiritDescriptor
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageWalkTextSpirit";
    [descriptor.params setObject:[NSString stringWithFormat:@"过场弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(random_between(10,30)) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor blueColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(2) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述
- (BarrageDescriptor *)floatTextSpiritDescriptor
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spiritName = @"BarrageFloatTextSpirit";
    [descriptor.params setObject:[NSString stringWithFormat:@"悬浮弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(random_between(10,15)) forKey:@"fontSize"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:[UIColor purpleColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(2) forKey:@"direction"];
    return descriptor;
}

@end
