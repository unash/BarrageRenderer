//
//  LiveCommentView.h
//  BarrageRendererDemo
//
//  Created by lidawen on 2021/2/24.
//  Copyright © 2021 ExBye Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BarrageRenderer/BarrageSpriteProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveCommentView : UIView<BarrageViewProtocol>

@property(assign, nonatomic) CGSize imageDesignSize;

@end

NS_ASSUME_NONNULL_END
