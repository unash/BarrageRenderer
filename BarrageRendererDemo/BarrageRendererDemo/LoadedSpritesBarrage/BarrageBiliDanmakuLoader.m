//
//  BarrageBiliDanmakuLoader.m
//  Pods
//
//  Created by Yifei Zhou on 4/25/16.
//
//

#import "BarrageBiliDanmakuLoader.h"
#import "NSNumber+BarrageRenderer.h"
#import "NSString+BarrageRenderer.h"
#import "UIColor+BarrageRenderer.h"

// https://github.com/Bilibili/DanmakuFlameMaster/wiki/常见问题

// <d p="23.826000213623,1,25,16777215,1422201084,0,057075e9,757076900">我从未见过如此厚颜无耻之猴</d>
// 0:时间(弹幕出现时间)
// 1:类型(1从左至右滚动弹幕|6从右至左滚动弹幕|5顶端固定弹幕|4底端固定弹幕|7高级弹幕|8脚本弹幕)
// 2:字号
// 3:颜色
// 4:时间戳 ?
// 5:弹幕池id
// 6:用户hash
// 7:弹幕id

@interface BarrageBiliDanmakuLoader ()
{
    NSDataReadingOptions _options;
}
@end

@implementation BarrageBiliDanmakuLoader

@synthesize filePath = _filePath;
@synthesize descriptors = _descriptors;

- (instancetype)initWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)options
{
    self = [super init];
    if (self) {
        _filePath = path;
        _options = options;
        [self _commonInit];
    }
    return self;
}

- (BOOL)_commonInit
{
    if (!_filePath) {
        return NO;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:_filePath])
        return NO;
    
    NSData *data = [NSData dataWithContentsOfFile:_filePath options:_options error:nil];
    if (!data) {
        return NO;
    }
    
    NSString *danmakuContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *pattern = @"<d\\s?p=\\\"(.+)\\\">(.+)<\\/d>";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSMutableArray *descriptors = [@[] mutableCopy];
    
    [[danmakuContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""])
            return;
        NSTextCheckingResult *match = [regex firstMatchInString:obj options:0 range:NSMakeRange(0, obj.length)];
        if ([match numberOfRanges] < 3)
            return;
        
        NSString *parameters = [obj substringWithRange:[match rangeAtIndex:1]];
        NSString *text = [obj substringWithRange:[match rangeAtIndex:2]];
        
        [descriptors addObject:[[self class] _createDescriptorWithParameters:parameters text:text]];
    }];
    
    _descriptors = [NSArray arrayWithArray:descriptors];
    
    return _descriptors != nil;
}

- (BOOL)reloadData;
{
    return [self _commonInit];
}

+ (nonnull BarrageDescriptor *)_createDescriptorWithParameters:(NSString *)parameters text:(NSString *)text
{
    NSParameterAssert(parameters != nil);
    NSParameterAssert(text != nil);
    
    NSArray *components = [parameters componentsSeparatedByString:@","];
    
    NSAssert(components.count == 8, @"Malformed bilibili Danmaku format!");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSNumber *beginTime = [NSNumber brg_numberWithString:components[0]];
    NSNumber *DanmakuType = [NSNumber brg_numberWithString:components[1]];
    NSNumber *fontSize = [NSNumber brg_numberWithString:components[2]];
    NSString *fontColorDecString = [components[3] copy];
    NSNumber *timestamp = [NSNumber brg_numberWithString:components[4]];
    NSNumber *DanmakuPoolID = [NSNumber brg_numberWithString:components[5]];
    NSString *userHash = [components[6] copy];
    NSNumber *DanmakuID = [NSNumber brg_numberWithString:components[7]];
#pragma clang diagnostic pop

    BarrageDescriptor *descriptor = [[BarrageDescriptor alloc] init];
    descriptor.params[@"text"] = text;
    descriptor.params[@"textColor"] = [UIColor brg_colorWithHexString:[NSString brg_hexStringWithDecimalString:fontColorDecString]];
    descriptor.params[@"fontSize"] = fontSize;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"delay"] = @([beginTime floatValue]);

    /*
     typedef NS_ENUM(NSUInteger, BarrageWalkDirection) {
         BarrageWalkDirectionR2L = 1,  // 右向左
         BarrageWalkDirectionL2R = 2,  // 左向右
         BarrageWalkDirectionT2B = 3,  // 上往下
         BarrageWalkDirectionB2T = 4   // 下往上
     };
     typedef NS_ENUM(NSUInteger, BarrageFloatDirection) {
         BarrageFloatDirectionT2B = 1,     // 上往下
         BarrageFloatDirectionB2T = 2      // 下往上
     };
    */
    
    if ([DanmakuType unsignedIntegerValue] == 1) {
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    } else if ([DanmakuType unsignedIntegerValue] == 6) {
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"direction"] = @(BarrageWalkDirectionL2R);
    } else if ([DanmakuType unsignedIntegerValue] == 5) {
        descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);
        descriptor.params[@"direction"] = @(BarrageWalkDirectionT2B);
    } else if ([DanmakuType unsignedIntegerValue] == 4) {
        descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);
        descriptor.params[@"direction"] = @(BarrageWalkDirectionB2T);
    }
    return descriptor;
}

@end
