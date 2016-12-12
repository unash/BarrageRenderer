//
//  UIImageView+BarrageView.m
//  Pods
//
//  Created by UnAsh on 16/12/12.
//
//

#import "UIImageView+BarrageView.h"
#import "UIView+BarrageView.h"

@implementation UIImageView (BarrageView)

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.image = nil;
}

- (void)configureWithParams:(NSDictionary *)params
{
    [super configureWithParams:params];
    
    UIImage *image = params[@"image"];
    if (image) self.image = image;
}

@end
