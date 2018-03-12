//
//  computerSettingViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "RebootDialog.h"
#import "MyConnector.h"
@interface computerSettingViewController : UIViewController
- (IBAction)press_return_button:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *rebootview;
@property (weak, nonatomic) IBOutlet UIView *scanexeview;
@property (weak, nonatomic) IBOutlet UIView *registeroperatorview;
- (IBAction)press_info_exe:(id)sender;
- (IBAction)press_info_reboot:(id)sender;
- (IBAction)press_info_registeroperator:(id)sender;

@end
