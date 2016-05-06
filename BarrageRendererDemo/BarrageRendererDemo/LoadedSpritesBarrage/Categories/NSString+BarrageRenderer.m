//
//  NSString+BarrageRenderer.m
//  BarrageRenderer
//
//  Created by Yifei Zhou on 4/11/16.
//  Copyright © 2016 Aladdin Inc. All rights reserved.
//

#import "NSString+BarrageRenderer.h"

@implementation NSString (BarrageRenderer)

+ (instancetype)brg_hexStringWithDecimalString:(NSString *)decStr
{
    return [NSString stringWithFormat:@"0x%lX", (unsigned long)[decStr integerValue]];
}

- (instancetype)brg_trimmedString
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [[NSString alloc] initWithString:[self stringByTrimmingCharactersInSet:set]];
}

@end
