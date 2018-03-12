//
//  SettingNameViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUIApplication.h"
#import "onHandler.h"
#import "Toast.h"
#import "OrderConst.h"
#import "MainTabbarController.h"
#import "LoginViewController.h"
#import "PersonalSettingsMsg.pbobjc.h"
#import "NetworkPacket.h"
@class SettingNameHandler;
@interface SettingNameViewController : UIViewController<onHandler>
- (IBAction)press_set_name:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *setting_name_et;
@property (strong,nonatomic) NSString* mnewName;
+ (SettingNameHandler*) getHandler;
@end
