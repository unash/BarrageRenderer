//
//  BarrageViewPool.m
//  Pods
//
//  Created by UnAsh on 16/12/12.
//
//

#import "BarrageViewPool.h"
#import "BarrageSpriteProtocol.h"
#import "BarrageSprite.h"

@interface BarrageViewPool ()
{
    NSMutableDictionary<NSString *,NSMutableArray<id<BarrageViewProtocol>>*> *_reusableViews;
}
@end

@implementation BarrageViewPool

+ (instancetype)mainPool
{
    static BarrageViewPool *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[BarrageViewPool alloc]init];
    });
    return pool;
}

- (instancetype)init
{
    if (self = [super init]) {
        _reusableViews = [[NSMutableDictionary alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearReusableSpriteViews) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearReusableSpriteViews
{
    [_reusableViews removeAllObjects];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - assistant
- (NSMutableArray<id<BarrageViewProtocol>>*)viewsForViewClassifier:(NSString *)classifier
{
    NSMutableArray *views = _reusableViews[classifier];
    if (!views) {
        views = [[NSMutableArray alloc]init];
        _reusableViews[classifier] = views;
    }
    return views;
}

- (NSString *)viewClassifierForSprite:(BarrageSprite *)sprite
{
    NSString *classifier = [NSString stringWithFormat:@"%@.%@",NSStringFromClass([self class]),sprite.viewClassName];
    return classifier;
}

#pragma mark - interface
/// 装配 view
- (void)assembleBarrageViewForSprite:(BarrageSprite *)sprite;
{
    NSParameterAssert(sprite.viewClassName.length>0);
    Class class = NSClassFromString(sprite.viewClassName);
    NSParameterAssert([class conformsToProtocol:@protocol(BarrageViewProtocol)]);
    
    NSString *classifier = [self viewClassifierForSprite:sprite];
    NSMutableArray *views = [self viewsForViewClassifier:classifier];
    
    UIView<BarrageViewProtocol> *view = [views firstObject];
    if (!view) {
        view = [[class alloc]initWithFrame:CGRectZero];
    }
    else
    {
        [view prepareForReuse];
        [views removeObject:view];
    }
    sprite.view = view;
}

/// 归还 view
- (void)reclaimBarrageViewForSprite:(BarrageSprite *)sprite;
{
    NSParameterAssert([sprite.view conformsToProtocol:@protocol(BarrageViewProtocol)]);
    NSString *classifier = [self viewClassifierForSprite:sprite];
    NSMutableArray *views = [self viewsForViewClassifier:classifier];
    if (![views containsObject:sprite.view]) {
        [views addObject:sprite.view];
    }
    sprite.view = nil;
}

@end
