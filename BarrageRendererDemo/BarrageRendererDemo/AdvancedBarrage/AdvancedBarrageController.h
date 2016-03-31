//
//  AdvancedBarrageController.h
//  BarrageRendererDemo
//
//  Created by UnAsh on 15/11/18.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedBarrageController : UIViewController

- (IBAction)start:(id)sender;
- (IBAction)load:(id)sender;
- (IBAction)hybridA:(id)sender;
- (IBAction)hybridB:(id)sender;
- (IBAction)backward:(id)sender;
- (IBAction)foreward:(id)sender;
@property(nonatomic, strong)IBOutlet UILabel *infoLabel;
@end
