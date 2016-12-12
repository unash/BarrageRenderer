//
//  UIView+BarrageView.m
//  Pods
//
//  Created by UnAsh on 16/12/12.
//
//

#import "UIView+BarrageView.h"

@implementation UIView (BarrageView)

- (void)prepareForReuse
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = 0;
    self.clipsToBounds = NO;
}

- (void)configureWithParams:(NSDictionary *)params
{
    UIColor *backgroundColor = params[@"backgroundColor"];
    if (backgroundColor) self.backgroundColor = backgroundColor;
    
    
    id borderWidthObj = params[@"borderWidth"];
    if (borderWidthObj) self.layer.borderWidth = [borderWidthObj doubleValue];
    
    UIColor *borderColor = params[@"borderColor"];
    if (borderColor) self.layer.borderColor = borderColor.CGColor;
    
    /// 圆角,此属性十分影响绘制性能,谨慎使用
    id cornerRadiusObj = params[@"cornerRadius"];
    if (cornerRadiusObj)
    {
        CGFloat cornerRadius = [cornerRadiusObj doubleValue];
        if (cornerRadius > 0) {
            self.layer.cornerRadius = cornerRadius;
            self.clipsToBounds = YES;
        }
    }
}

@end
