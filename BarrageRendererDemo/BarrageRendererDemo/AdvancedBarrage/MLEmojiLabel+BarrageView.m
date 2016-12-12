//
//  MLEmojiLabel+BarrageView.m
//  BarrageRendererDemo
//
//  Created by UnAsh on 16/12/12.
//  Copyright © 2016年 ExBye Inc. All rights reserved.
//

#import "MLEmojiLabel+BarrageView.h"
#import <BarrageRenderer/UILabel+BarrageView.h>

@implementation MLEmojiLabel (BarrageView)

- (void)configureWithParams:(NSDictionary *)params
{
    [super configureWithParams:params];
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.isNeedAtAndPoundSign = YES;
}

@end
