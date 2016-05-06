//
//  NSNumber+BarrageRenderer.h
//  BarrageRenderer
//
//  Created by Yifei Zhou on 4/11/16.
//  Copyright © 2016 Aladdin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (BarrageRenderer)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...

 @param string  The string described an number.

 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)brg_numberWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
