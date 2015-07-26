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

#import "BarrageSpiritFactory.h"
#import "BarrageDescriptor.h"
#import "BarrageSpirit.h"
#import "BarrageTextSpirit.h"
#import "BarrageFloatTextSpirit.h"
#import "BarrageWalkTextSpirit.h"

@implementation BarrageSpiritFactory

+ (BarrageSpirit *)createSpiritWithDescriptor:(BarrageDescriptor *)descriptor
{
    BarrageSpirit * spirit = nil;
    if ([descriptor.spiritName isEqualToString:@"BarrageWalkTextSpirit"]) {
        spirit = [[BarrageWalkTextSpirit alloc]init];
    }
    else if ([descriptor.spiritName isEqualToString:@"BarrageFloatTextSpirit"]) {
        spirit = [[BarrageFloatTextSpirit alloc]init];
    }
    spirit.delay = [[descriptor.params objectForKey:@"delay"]doubleValue];
//    static int zindex = 1000;
//    spirit.z_index = zindex--;
    
    if ([spirit isKindOfClass:[BarrageTextSpirit class]]) {
        BarrageTextSpirit * textSpirit = (BarrageTextSpirit *)spirit;
        
        id text = [descriptor.params objectForKey:@"text"];
        if (text) textSpirit.text = text;
        
        id fontSize = [descriptor.params objectForKey:@"fontSize"];
        if (fontSize) textSpirit.fontSize = [fontSize doubleValue];
        
        id borderWidth = [descriptor.params objectForKey:@"borderWidth"];
        if (borderWidth) textSpirit.borderWidth = [borderWidth doubleValue];
        
        id bgColor = [descriptor.params objectForKey:@"bgColor"];
        if (bgColor) textSpirit.bgColor = bgColor;
        
        id textColor = [descriptor.params objectForKey:@"textColor"];
        if (textColor) textSpirit.textColor = textColor;
        
        id cornerRadius = [descriptor.params objectForKey:@"cornerRadius"];
        if (cornerRadius) textSpirit.cornerRadius = [cornerRadius doubleValue];
        
        id borderColor = [descriptor.params objectForKey:@"borderColor"];
        if (borderColor) textSpirit.borderColor = borderColor;
        
        if ([textSpirit isKindOfClass:[BarrageWalkTextSpirit class]]) {
            BarrageWalkTextSpirit * walkTextSpirit = (BarrageWalkTextSpirit *)textSpirit;
            
            id direction = [descriptor.params objectForKey:@"direction"];
            if (direction) walkTextSpirit.direction = [direction integerValue];
            
            id speed = [descriptor.params objectForKey:@"speed"];
            if (speed) walkTextSpirit.speed = [speed doubleValue];
        }
        if ([textSpirit isKindOfClass:[BarrageFloatTextSpirit class]]) {
            BarrageFloatTextSpirit * floatTextSpirit = (BarrageFloatTextSpirit *)textSpirit;
            
            id direction = [descriptor.params objectForKey:@"direction"];
            if (direction) floatTextSpirit.direction = [direction integerValue];
            
            id duration = [descriptor.params objectForKey:@"duration"];
            if (duration) floatTextSpirit.duration = [duration doubleValue];
        }
    }
    return spirit;
}

@end
