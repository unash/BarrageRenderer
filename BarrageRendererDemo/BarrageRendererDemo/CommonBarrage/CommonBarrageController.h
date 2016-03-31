//
//  BarrageTestController.h
//  demo_app_main
//
//  Created by UnAsh on 15/7/10.
//  Copyright (c) 2015年 UnAsh. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CommonBarrageController:UIViewController

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)resume:(id)sender;
- (IBAction)faster:(id)sender;
- (IBAction)slower:(id)sender;
@property(nonatomic, strong)IBOutlet UILabel *infoLabel;
@end
