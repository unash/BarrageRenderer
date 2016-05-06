//
//  NSString+BarrageRenderer.h
//  BarrageRenderer
//
//  Created by Yifei Zhou on 4/11/16.
//  Copyright © 2016 Aladdin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BarrageRenderer)

+ (instancetype)brg_hexStringWithDecimalString:(NSString *)decStr;

- (instancetype)brg_trimmedString;

@end

NS_ASSUME_NONNULL_END