//
//  BarrageWalkImageTextSprite.m
//  BarrageRendererDemo
//
//  Created by UnAsh on 15/11/15.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import "BarrageWalkImageTextSprite.h"
#import <MLEmojiLabel/MLEmojiLabel.h>

@implementation BarrageWalkImageTextSprite

- (UIView *)bindingView
{
    MLEmojiLabel * label = [[MLEmojiLabel alloc]initWithFrame:CGRectZero];
    label.text = self.text;
    label.textColor = self.textColor;
    label.font = [UIFont systemFontOfSize:self.fontSize];
    if (self.cornerRadius > 0) {
        label.layer.cornerRadius = self.cornerRadius;
        label.clipsToBounds = YES;
    }
    label.layer.borderColor = self.borderColor.CGColor;
    label.layer.borderWidth = self.borderWidth;
    label.backgroundColor = self.backgroundColor;
    
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.isNeedAtAndPoundSign = YES;
    return label;
}

@end
