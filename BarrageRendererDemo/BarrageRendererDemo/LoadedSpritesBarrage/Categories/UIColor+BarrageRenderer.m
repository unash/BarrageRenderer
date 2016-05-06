//
//  UIColor+BarrageRenderer.m
//  BarrageRenderer
//
//  Created by Yifei Zhou on 4/26/16.
//  Copyright © 2016 Aladdin Inc. All rights reserved.
//

#import "NSString+BarrageRenderer.h"
#import "UIColor+BarrageRenderer.h"

#define CLAMP_COLOR_VALUE(v) (v) = (v) < 0 ? 0 : (v) > 1 ? 1 : (v)

@implementation UIColor (BarrageRenderer)

static inline NSUInteger brg_hexStrToInt(NSString *str)
{
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL brg_hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a)
{
    str = [[str brg_trimmedString] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }

    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }

    // RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = brg_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = brg_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = brg_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)
            *a = brg_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else
            *a = 1;
    } else {
        *r = brg_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = brg_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = brg_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8)
            *a = brg_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else
            *a = 1;
    }
    return YES;
}

+ (instancetype)brg_colorWithHexString:(NSString *)hexStr
{
    CGFloat r, g, b, a;
    if (brg_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

@end
