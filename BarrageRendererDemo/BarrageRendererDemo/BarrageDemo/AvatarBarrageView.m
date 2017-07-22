//
//  AvatarBarrageView.m
//  BarrageRendererDemo
//
//  Created by InAsh on 20/07/2017.
//  Copyright © 2017 ExBye Inc. All rights reserved.
//

#import "AvatarBarrageView.h"
#import <BarrageRenderer/UIView+BarrageView.h>

@interface AvatarBarrageView ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,assign)NSTimeInterval time;
@property(nonatomic,strong)NSArray *titles;
@end

@implementation AvatarBarrageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews
{
    _imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"avatar"];
    [self addSubview:self.imageView];
    
    _titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor purpleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    CGFloat const imageWidth = 30.0f;
    [super layoutSubviews];
    NSTimeInterval time = self.time*10;
    NSInteger num = 10;
    NSInteger frame = fabs(num/2 - time + (NSInteger)(time/num)*num);
    CGFloat newImageWidth = imageWidth*pow(0.9, frame);
    self.imageView.frame = CGRectMake((imageWidth-newImageWidth)/2, (imageWidth-newImageWidth)/2, newImageWidth, newImageWidth);
    self.titleLabel.frame = CGRectMake(imageWidth, 0, self.bounds.size.width-imageWidth, self.bounds.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat const imageWidth = 30.0f;
    UILabel *prototypeLabel = self.titleLabel;
    CGFloat maxWidth = 0;
    CGFloat maxHeight = 0;
    for (NSString *title in self.titles) {
        prototypeLabel.text = title;
        CGSize titleSize = [prototypeLabel sizeThatFits:CGSizeMake(10000, 10)];
        if (titleSize.width>maxWidth) {
            maxWidth = titleSize.width;
        }
        if (titleSize.height>maxHeight) {
            maxHeight = titleSize.height;
        }
    }
    if (imageWidth>maxHeight) {
        maxHeight = imageWidth;
    }
    maxWidth+= imageWidth;
    return CGSizeMake(maxWidth, maxHeight);
}

#pragma mark - BarrageViewProtocol

- (void)configureWithParams:(NSDictionary *)params
{
    [super configureWithParams:params];
    self.titles = params[@"titles"];
    self.titleLabel.text = [self.titles firstObject];
}

- (void)updateWithTime:(NSTimeInterval)time
{
    _time = time;
    [self updateTexts];
    [self setNeedsLayout];
}

- (void)updateTexts
{
    if (!self.titles.count) {
        return;
    }
    NSInteger frame = ((NSInteger)floor(self.time*5)) % self.titles.count;
    self.titleLabel.text = self.titles[frame];
}

@end
