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
#import "BarrageSpriteUtility.h"
#import "UIImage+Barrage.h"

@interface ViewController()<BarrageRendererDelegate>
{
    BarrageRenderer * _renderer;
    NSTimer * _timer;
    NSInteger _index;
    NSDate * _startTime;
    NSTimeInterval _predictedTime; //快进时间
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _index = 0;
    _predictedTime = 0.0f;
    [self initBarrageRenderer];
}

- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc]init];
    [_renderer setSpeed:1.0f];
    _renderer.delegate = self;
    _renderer.redisplay = YES;
    [self.view addSubview:_renderer.view];
    [self.view sendSubviewToBack:_renderer.view];
    [_renderer load:@[[self walkTextSpriteDescriptorWithDelay:1],[self walkTextSpriteDescriptorWithDelay:3],[self walkTextSpriteDescriptorWithDelay:5],[self walkTextSpriteDescriptorWithDelay:7],[self walkTextSpriteDescriptorWithDelay:9],[self walkTextSpriteDescriptorWithDelay:11]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];

    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    [_renderer stop];
}

#pragma mark - Action
- (IBAction)start:(id)sender
{
    _startTime = [NSDate date];
    [_renderer start];
}
- (IBAction)stop:(id)sender
{
    [_renderer stop];
}
- (IBAction)pause:(id)sender
{
    [_renderer pause];
}
- (IBAction)resume:(id)sender
{
    [_renderer start];
}
- (IBAction)send:(id)sender
{
    [self manualSendBarrage];
}
- (IBAction)faster:(id)sender
{
    CGFloat speed = _renderer.speed + 0.5;
    if (speed >= 10) {
        speed = 10.0f;
    }
    _renderer.speed = speed;
}
- (IBAction)slower:(id)sender
{
    CGFloat speed = _renderer.speed - 0.5;
    if (speed <= 0.5f) {
        speed = 0.5;
    }
    _renderer.speed = speed;
}

- (IBAction)backward:(id)sender
{
    _predictedTime -= 5.0f;
}

- (IBAction)forward:(id)sender
{
    _predictedTime += 5.0f;
}

- (void)autoSendBarrage
{
//    [_renderer receive:[self floatTextSpriteDescriptorWithDirection:2]];
//    [_renderer receive:[self walkTextSpriteDescriptorWithDirection:1]];
//    [_renderer receive:[self floatImageSpriteDescriptorWithDirection:1]];
//    [_renderer receive:[self walkImageSpriteDescriptorWithDirection:2]];
    [_renderer receive:[self walkImageTextSpriteDescriptorWithDirection:1]];
//    [_renderer receive:[self defaultSpriteDescriptor]];
}

- (void)manualSendBarrage
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageWalkTextSprite";
    [descriptor.params setObject:[NSString stringWithFormat:@"过场弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(20.0f) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor greenColor] forKey:@"borderColor"];
    [descriptor.params setObject:[UIColor yellowColor] forKey:@"backgroundColor"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"direction"];
    [_renderer receive:descriptor];
}

#pragma mark - 弹幕描述符生产方法

- (BarrageDescriptor *)defaultSpriteDescriptor
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageSprite";
    [descriptor.params setObject:[UIColor blueColor] forKey:@"backgroundColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:[NSValue valueWithCGSize:CGSizeMake(50, 30)] forKey:@"mandatorySize"];
    return descriptor;
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageWalkTextSprite";
    [descriptor.params setObject:[NSString stringWithFormat:@"过场弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(20.0f) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor yellowColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述 - 浮动文字弹幕
- (BarrageDescriptor *)floatTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageFloatTextSprite";
    [descriptor.params setObject:[NSString stringWithFormat:@"悬浮弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(12.0f) forKey:@"fontSize"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:[UIColor lightGrayColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述 - 过场图片弹幕
- (BarrageDescriptor *)walkImageSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageWalkImageSprite";
    [descriptor.params setObject:[[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(40, 20.0f)] forKey:@"image"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述 - 浮动图片弹幕
- (BarrageDescriptor *)floatImageSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageFloatImageSprite";
    [descriptor.params setObject:[[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(40, 20.0f)] forKey:@"image"];
    [descriptor.params setObject:@(1) forKey:@"borderWidth"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(3) forKey:@"duration"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

/// 生成精灵描述 - 延时文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageWalkTextSprite";
    [descriptor.params setObject:[NSString stringWithFormat:@"定时弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(20.0f) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor purpleColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(1) forKey:@"direction"];
    [descriptor.params setObject:@(delay) forKey:@"delay"];
    return descriptor;
}

/// 图文混排精灵弹幕 - 过场图文弹幕
- (BarrageDescriptor *)walkImageTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = @"BarrageWalkImageTextSprite";//这个控制样式
    [descriptor.params setObject:[NSString stringWithFormat:@"图文混排/::B过场弹幕:%ld",(long)_index++] forKey:@"text"];
    [descriptor.params setObject:@(20.0f) forKey:@"fontSize"];
    [descriptor.params setObject:[UIColor greenColor] forKey:@"textColor"];
    [descriptor.params setObject:@(100 * (double)random()/RAND_MAX+50) forKey:@"speed"];
    [descriptor.params setObject:@(direction) forKey:@"direction"];
    return descriptor;
}

#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:_startTime];
    interval += _predictedTime;
    return interval;
}

@end
