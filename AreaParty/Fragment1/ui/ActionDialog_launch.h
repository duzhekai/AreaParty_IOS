//
//  ActionDialog_launch.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceUtil.h"
@interface ActionDialog_launch : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *check_button;
- (IBAction)press_checkbox:(id)sender;
- (IBAction)press_cancel:(id)sender;
- (IBAction)press_ok:(id)sender;

@end
