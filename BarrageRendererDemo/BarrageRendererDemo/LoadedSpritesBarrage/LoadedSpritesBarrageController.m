//
//  LoadedSpritesBarrageController.m
//  BarrageRendererDemo
//
//  Created by Yifei Zhou on 5/6/16.
//  Copyright © 2016 ExBye Inc. All rights reserved.
//

#import "LoadedSpritesBarrageController.h"
#import <BarrageRenderer/BarrageRenderer.h>
#import "BarrageBiliDanmakuLoader.h"

@interface LoadedSpritesBarrageController ()
{
    BarrageRenderer * _renderer;
    NSInteger _index;
}
@end

@implementation LoadedSpritesBarrageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _index = 0;
    [self initBarrageRenderer];
}

- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc]init];
    [self.view addSubview:_renderer.view];
    _renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    // 若想为弹幕增加点击功能, 请添加此句话, 并在Descriptor中注入行为
    _renderer.view.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:_renderer.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _renderer.redisplay = YES;

    BarrageBiliDanmakuLoader *loader = [[BarrageBiliDanmakuLoader alloc]
                                        initWithContentsOfFile:[[NSBundle mainBundle]
                                                                pathForResource:@"Bilibili - 7064760"
                                                                ofType:@"xml"]
                                        options:kNilOptions];
    [_renderer registerModules:@[loader]];
}

- (void)dealloc
{
    [_renderer stop];
}

#pragma mark - Action
- (IBAction)start:(id)sender
{
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

@end
