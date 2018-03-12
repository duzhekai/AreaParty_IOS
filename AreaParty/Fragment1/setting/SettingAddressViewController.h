//
//  SettingAddressViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onUIControllerResult.h"
#import "CityPickerViewController.h"
@class SettingAddressHandler;
@interface SettingAddressViewController : UIViewController<onUIControllerResult>
@property (weak, nonatomic) IBOutlet UIButton *setting_address;
- (IBAction)press_select_address:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *setting_street;
@property (weak, nonatomic) IBOutlet UITextField *setting_community;
@property (weak, nonatomic) IBOutlet UIButton *sendChangeAddressMsgBtn;
- (IBAction)press_ok:(id)sender;
+ (SettingAddressHandler*) getHandler;
@end
