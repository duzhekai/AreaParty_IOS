//
//  RegisterPersonalInfo.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/6.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "Base.h"
#import "SendCode.pbobjc.h"
#import "NetworkPacket.h"
#import "RegisterMsg.pbobjc.h"
#import "DataTypeTranslater.h"
#import <net/if.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <net/if_dl.h>
@interface RegisterPersonalInfo : UIViewController<onUIControllerResult>
@property (weak, nonatomic) IBOutlet UIButton *btn_selectAddress;

@property (weak, nonatomic) IBOutlet UITextField *et_mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *et_userCode;
@property (weak, nonatomic) IBOutlet UITextField *et_userStreet;
@property (weak, nonatomic) IBOutlet UITextField *et_userCommunity;
@property (weak, nonatomic) IBOutlet UIButton *btn_send_code;
@property (weak, nonatomic) IBOutlet UIButton *btn_register;
- (IBAction)Press_btn_sendcode:(UIButton *)sender;
- (IBAction)Press_btn_register:(UIButton *)sender;
- (IBAction)Press_btn_selectAddress:(UIButton *)sender;
- (void)setuserid:(NSString*) uid;
- (void)setusername:(NSString*) uname;
- (void)setkeyword:(NSString*) kw;
@end
