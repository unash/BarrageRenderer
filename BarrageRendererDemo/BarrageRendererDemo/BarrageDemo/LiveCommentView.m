//
//  LiveCommentView.m
//  BarrageRendererDemo
//
//  Created by lidawen on 2021/2/24.
//  Copyright © 2021 ExBye Inc. All rights reserved.
//

#import "LiveCommentView.h"
#import <BarrageRenderer/UIView+BarrageView.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LiveCommentView ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation LiveCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageDesignSize = CGSizeMake(40, 40);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, _imageDesignSize.width, _imageDesignSize.height);
    CGSize imageSize = _imageDesignSize;
    CGSize textSize = [self.titleLabel sizeThatFits:CGSizeMake(INT_MAX, imageSize.height)];
    CGFloat offset = ceil((imageSize.height - textSize.height)/2.0);
    self.titleLabel.frame = CGRectMake(imageSize.width, offset, ceil(textSize.width), ceil(textSize.height));
    NSLog(@"self.frame:%@", NSStringFromCGRect(self.frame));
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = _imageDesignSize;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(INT_MAX, imageSize.height)];
    return CGSizeMake(ceil(imageSize.width + titleSize.width), ceil(MAX(imageSize.height, titleSize.height)));
}

#pragma mark - BarrageViewProtocol

- (void)configureWithParams:(NSDictionary *)params
{
    [super configureWithParams:params];
    UILabel *label = self.titleLabel;
    NSString *text = params[@"text"];
    if (text) {
        label.text = text;
    }

    UIColor *textColor = params[@"textColor"];
    if (textColor) {
        label.textColor = textColor;
    } else {
        label.textColor = [UIColor blackColor];
    }

    UIColor *shadowColor = params[@"shadowColor"];
    if (shadowColor) {
        label.layer.shadowColor = shadowColor.CGColor;
    } else {
        label.layer.shadowColor = [UIColor clearColor].CGColor;
    }

    id shadowOffsetObj = params[@"shadowOffset"];
    if (shadowOffsetObj) {
        label.layer.shadowOffset = [shadowOffsetObj CGSizeValue];
    } else {
        label.layer.shadowOffset = CGSizeZero;
    }

    id fontSizeObj = params[@"fontSize"];
    CGFloat fontSize = fontSizeObj ? [fontSizeObj doubleValue] : 16.0f;

    NSString *fontFamily = params[@"fontFamily"];
    label.font = fontFamily ? [UIFont fontWithName:fontFamily size:fontSize] : [UIFont systemFontOfSize:fontSize];

    NSAttributedString *attributedText = params[@"attributedText"];
    if (attributedText) {
        label.attributedText = attributedText;
    }
    
    NSString *portraitUrl = params[@"portraitUrl"];
    if (portraitUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:portraitUrl]];
    }
}

@end
