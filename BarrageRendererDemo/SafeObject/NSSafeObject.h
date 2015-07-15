//
//  NSSafeObject.h
//  demo_app_main
//
//  Created by UnAsh on 15/7/13.
//  Copyright (c) 2015年 UnAsh. All rights reserved.
//

#import <Foundation/Foundation.h>
/// justForText
@interface NSSafeObject : NSObject

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;
- (void)excute;

@end
