//
//  UILabel+BarrageView.m
//  Pods
//
//  Created by UnAsh on 16/12/12.
//
//

#import "UILabel+BarrageView.h"
#import "UIView+BarrageView.h"

@implementation UILabel (BarrageView)

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.text = nil;
    self.attributedText = [[NSAttributedString alloc]init];
}

- (void)configureWithParams:(NSDictionary *)params
{
    [super configureWithParams:params];
    
    NSString *text = params[@"text"];
    if (text) self.text = text;
    
    UIColor *textColor = params[@"textColor"];
    if (textColor) self.textColor = textColor;
    else self.textColor = [UIColor blackColor];
    
    UIColor *shadowColor = params[@"shadowColor"];
    if (shadowColor) self.layer.shadowColor = shadowColor.CGColor;
    else self.layer.shadowColor = [UIColor clearColor].CGColor;
    
    id shadowOffsetObj = params[@"shadowOffset"];
    if (shadowOffsetObj) self.layer.shadowOffset = [shadowOffsetObj CGSizeValue];
    else self.layer.shadowOffset = CGSizeZero;
    
    id fontSizeObj = params[@"fontSize"];
    CGFloat fontSize = fontSizeObj?[fontSizeObj doubleValue]:16.0f;
    
    NSString *fontFamily = params[@"fontFamily"];
    self.font = fontFamily?[UIFont fontWithName:fontFamily size:fontSize]:[UIFont systemFontOfSize:fontSize];
    
    NSAttributedString *attributedText = params[@"attributedText"];
    if (attributedText) self.attributedText = attributedText;
}

@end
