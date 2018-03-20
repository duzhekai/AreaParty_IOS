//
//  AlterDeviceNameDialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/15.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
@class tvInforViewController;
@interface AlterDeviceNameDialog : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *name_tv;
@property (strong,nonatomic) UIViewController* pushvc;
- (IBAction)press_cancel:(id)sender;
- (IBAction)press_ok:(id)sender;

@end
