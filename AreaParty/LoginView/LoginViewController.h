//
//  LoginViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/10.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
#import "FileData.pbobjc.h"
#import "myChatList.h"

#import "Toast.h"
#import <sys/sysctl.h>
#import "LoginMsg.pbobjc.h"
#import <net/if.h>
#import <sys/utsname.h>
#import <net/if_dl.h>
#import "NetworkPacket.h"
#import "ProtoHead.pbobjc.h"
#import "DataTypeTranslater.h"
#import "NetworkPacket.h"
#import "AccreditMsg.pbobjc.h"
#import "UserData.pbobjc.h"
#import "ChatData.pbobjc.h"
#import "GetUserInfoMsg.pbobjc.h"
#import "SharedflieBean.h"
#import "MyUIApplication.h"
#import "MainTabbarController.h"
@class Base;
@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *musernameTF;
@property (weak, nonatomic) IBOutlet UITextField *mpasswdTF;
@property (weak, nonatomic) IBOutlet UIButton *Login_btn;
@property (weak, nonatomic) IBOutlet UIButton *offline;
@property (weak, nonatomic) IBOutlet UIButton *registerbtn;
@property (strong, nonatomic) UIAlertController *alertController;
- (IBAction)Press_login_btn:(UIButton *)sender;
- (IBAction)Press_offline_btn:(id)sender;
- (IBAction)Press_register_btn:(id)sender;
-(void)setmport:(NSUInteger) num;
-(void)sethost:(NSString*)host;
+ (NSMutableArray *)userFriend;
+ (NSMutableArray *)userNet;
+ (NSMutableArray *)userShare;
+ (NSMutableArray *)files;
+ (myChatList *)myChats;
+ (NSString*) getuserId;
+ (NSString*) getuserMac;
+ (NSString*) getuserName;
+ (Base*) getBase;
@end
