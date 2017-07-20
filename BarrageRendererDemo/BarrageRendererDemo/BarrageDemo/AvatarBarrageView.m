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
@property(nonatomic,strong)UILabel *detailLabel;
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
    
    _detailLabel = [[UILabel alloc]init];
    self.detailLabel.textColor = [UIColor lightGrayColor];
    self.detailLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:self.detailLabel];
}

- (void)layoutSubviews
{
    CGFloat const imageWidth = 30.0f;
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, imageWidth, imageWidth);
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(10000, 10)];
    self.titleLabel.frame = CGRectMake(imageWidth, 0, self.bounds.size.width-imageWidth, titleSize.height);
    self.detailLabel.frame = CGRectMake(imageWidth, titleSize.height, self.bounds.size.width-imageWidth, self.bounds.size.height-titleSize.height);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat const imageWidth = 30.0f;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(10000, 10)];
    CGSize detailSize = [self.detailLabel sizeThatFits:CGSizeMake(10000, 10)];
    CGFloat height = MAX(titleSize.height+detailSize.height, imageWidth);
    CGFloat width = imageWidth+MAX(titleSize.width, detailSize.width);
    return CGSizeMake(width, height);
}

#pragma mark - BarrageViewProtocol

- (void)configureWithParams:(NSDictionary *)params
{
    [super configureWithParams:params];
    NSString *title = params[@"title"];
    NSString *detail = params[@"detail"];
    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}

@end
