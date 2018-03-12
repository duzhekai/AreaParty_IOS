//
//  SettingPwdViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUIApplication.h"
#import "Toast.h"
#import "SendCode.pbobjc.h"
#import "NetworkPacket.h"
#import "ProtoHead.pbobjc.h"
#import "LoginViewController.h"
#import "PersonalSettingsMsg.pbobjc.h"
@class SettingPwdHandler;
@interface SettingPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *setting_oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *setting_newPwd;
@property (weak, nonatomic) IBOutlet UITextField *setting_codePwd;
@property (weak, nonatomic) IBOutlet UIButton *getChangePwdCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendChangeMsgBtn;
- (IBAction)onclick:(id)sender;
+ (SettingPwdHandler*) getHandler;

@end
