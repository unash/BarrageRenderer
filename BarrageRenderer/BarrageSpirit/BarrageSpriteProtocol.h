//
//  BarrageSpriteProtocol.h
//  Pods
//
//  Created by UnAsh on 15/11/13.
//
//

#import <Foundation/Foundation.h>

/// view 弹幕协议
@protocol BarrageViewProtocol <NSObject>

@required
@property(nonatomic,strong)UIColor * backgroundColor;
@property(nonatomic,assign)CGFloat borderWidth;
@property(nonatomic,strong)UIColor * borderColor;
/// 圆角,此属性十分影响绘制性能,谨慎使用
@property(nonatomic,assign)CGFloat cornerRadius;
/// 强制性大小,默认为CGSizeZero,大小自适应; 否则使用mandatorySize的值来设置view大小
@property(nonatomic,assign)CGSize mandatorySize;

@end

/// 文本弹幕协议
@protocol BarrageTextProtocol <BarrageViewProtocol>

@required
@property(nonatomic,strong)NSString * text;
@property(nonatomic,strong)UIColor * textColor; // 字体颜色
@property(nonatomic,assign)CGFloat fontSize;
@property(nonatomic,strong)NSString * fontFamily;
@property(nonatomic,retain)UIColor * shadowColor;
@property(nonatomic)CGSize shadowOffset;

@end

/// 图片弹幕协议
@protocol BarrageImageProtocol <BarrageViewProtocol>

@required
@property(nonatomic,strong)UIImage * image;

@end