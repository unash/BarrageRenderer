//
//  LoadedSpritesBarrageController.h
//  BarrageRendererDemo
//
//  Created by Yifei Zhou on 5/6/16.
//  Copyright © 2016 ExBye Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadedSpritesBarrageController : UIViewController

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;

@property(nonatomic, strong)IBOutlet UILabel *infoLabel;

@end
