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
#import "BarrageWalkSpirit.h"
#import "BarrageFloatSpirit.h"
#import "BarrageWalkTextSpirit.h"
#import "BarrageFloatTextSpirit.h"
#import "BarrageWalkImageSpirit.h"
#import "BarrageFloatImageSpirit.h"

@implementation BarrageSpiritFactory

+ (BarrageSpirit *)createSpiritWithDescriptor:(BarrageDescriptor *)descriptor
{
    BarrageSpirit * spirit = nil;
    
    if (descriptor.spiritName.length != 0) {
        Class class = NSClassFromString(descriptor.spiritName);
        if (class) {
            spirit = [[class alloc]init];
        }
    }
    if (!spirit) {
        return nil;
    }
    
    spirit.delay = [[descriptor.params objectForKey:@"delay"]doubleValue];
//    static int zindex = 1000;
//    spirit.z_index = zindex--;
    
    if ([spirit isKindOfClass:[BarrageWalkSpirit class]]) {
        BarrageWalkSpirit * walkSpirit = (BarrageWalkTextSpirit *)spirit;
        
        id direction = [descriptor.params objectForKey:@"direction"];
        if (direction) walkSpirit.direction = [direction integerValue];
        
        id speed = [descriptor.params objectForKey:@"speed"];
        if (speed) walkSpirit.speed = [speed doubleValue];
    }
    
    if ([spirit isKindOfClass:[BarrageFloatSpirit class]]) {
        BarrageFloatSpirit * floatSpirit = (BarrageFloatSpirit *)spirit;
        
        id direction = [descriptor.params objectForKey:@"direction"];
        if (direction) floatSpirit.direction = [direction integerValue];
        
        id duration = [descriptor.params objectForKey:@"duration"];
        if (duration) floatSpirit.duration = [duration doubleValue];
    }
    
    if ([spirit isKindOfClass:[BarrageWalkTextSpirit class]]) {
        BarrageWalkTextSpirit * textSpirit = (BarrageWalkTextSpirit *)spirit;
        
        id text = [descriptor.params objectForKey:@"text"];
        if (text) textSpirit.text = text;
        
        id fontSize = [descriptor.params objectForKey:@"fontSize"];
        if (fontSize) textSpirit.fontSize = [fontSize doubleValue];
        
        id borderWidth = [descriptor.params objectForKey:@"borderWidth"];
        if (borderWidth) textSpirit.borderWidth = [borderWidth doubleValue];
        
        id backgroundColor = [descriptor.params objectForKey:@"backgroundColor"];
        if (backgroundColor) textSpirit.backgroundColor = backgroundColor;
        
        id textColor = [descriptor.params objectForKey:@"textColor"];
        if (textColor) textSpirit.textColor = textColor;
        
        id cornerRadius = [descriptor.params objectForKey:@"cornerRadius"];
        if (cornerRadius) textSpirit.cornerRadius = [cornerRadius doubleValue];
        
        id borderColor = [descriptor.params objectForKey:@"borderColor"];
        if (borderColor) textSpirit.borderColor = borderColor;
    }
    
    if ([spirit isKindOfClass:[BarrageFloatTextSpirit class]]) {
        BarrageFloatTextSpirit * textSpirit = (BarrageFloatTextSpirit *)spirit;
        
        id text = [descriptor.params objectForKey:@"text"];
        if (text) textSpirit.text = text;
        
        id fontSize = [descriptor.params objectForKey:@"fontSize"];
        if (fontSize) textSpirit.fontSize = [fontSize doubleValue];
        
        id borderWidth = [descriptor.params objectForKey:@"borderWidth"];
        if (borderWidth) textSpirit.borderWidth = [borderWidth doubleValue];
        
        id backgroundColor = [descriptor.params objectForKey:@"backgroundColor"];
        if (backgroundColor) textSpirit.backgroundColor = backgroundColor;
        
        id textColor = [descriptor.params objectForKey:@"textColor"];
        if (textColor) textSpirit.textColor = textColor;
        
        id cornerRadius = [descriptor.params objectForKey:@"cornerRadius"];
        if (cornerRadius) textSpirit.cornerRadius = [cornerRadius doubleValue];
        
        id borderColor = [descriptor.params objectForKey:@"borderColor"];
        if (borderColor) textSpirit.borderColor = borderColor;
    }
    
    if ([spirit isKindOfClass:[BarrageFloatImageSpirit class]]) {
        BarrageFloatImageSpirit * imageSpirit = (BarrageFloatImageSpirit *)spirit;
        
        id image = [descriptor.params objectForKey:@"image"];
        if (image) imageSpirit.image = image;
        
        id borderWidth = [descriptor.params objectForKey:@"borderWidth"];
        if (borderWidth) imageSpirit.borderWidth = [borderWidth doubleValue];
        
        id backgroundColor = [descriptor.params objectForKey:@"backgroundColor"];
        if (backgroundColor) imageSpirit.backgroundColor = backgroundColor;
        
        id cornerRadius = [descriptor.params objectForKey:@"cornerRadius"];
        if (cornerRadius) imageSpirit.cornerRadius = [cornerRadius doubleValue];
        
        id borderColor = [descriptor.params objectForKey:@"borderColor"];
        if (borderColor) imageSpirit.borderColor = borderColor;
    }
    
    if ([spirit isKindOfClass:[BarrageWalkImageSpirit class]]) {
        BarrageWalkImageSpirit * imageSpirit = (BarrageWalkImageSpirit *)spirit;
        
        id image = [descriptor.params objectForKey:@"image"];
        if (image) imageSpirit.image = image;
        
        id borderWidth = [descriptor.params objectForKey:@"borderWidth"];
        if (borderWidth) imageSpirit.borderWidth = [borderWidth doubleValue];
        
        id backgroundColor = [descriptor.params objectForKey:@"backgroundColor"];
        if (backgroundColor) imageSpirit.backgroundColor = backgroundColor;
        
        id cornerRadius = [descriptor.params objectForKey:@"cornerRadius"];
        if (cornerRadius) imageSpirit.cornerRadius = [cornerRadius doubleValue];
        
        id borderColor = [descriptor.params objectForKey:@"borderColor"];
        if (borderColor) imageSpirit.borderColor = borderColor;
    }
    
    return spirit;
}

@end
