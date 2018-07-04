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
#import "onHandler.h"
#import "LoginSettingViewController.h"
#import "PreferenceUtil.h"
#import "GroupData.pbobjc.h"
@class Base;

extern Base* Login_base;
extern NSMutableArray<UserItem*> *Login_userFriend;
extern NSMutableArray<UserItem*> *Login_userNet;
extern NSMutableArray<UserItem*> *Login_userShare;
extern NSMutableArray<FileItem*> *Login_files;
extern NSMutableArray<GroupItem*> *Login_userGroups;
extern NSString* Login_userId;
extern NSString* Login_userName;
extern NSString* Login_userMac;
extern BOOL Login_mainMobile;
extern int Login_userHeadIndex;
extern myChatList* Login_myChats;
@interface LoginViewController : UIViewController<onHandler>

@property (weak, nonatomic) IBOutlet UITextField *musernameTF;
@property (weak, nonatomic) IBOutlet UITextField *mpasswdTF;
@property (weak, nonatomic) IBOutlet UIButton *Login_btn;
@property (weak, nonatomic) IBOutlet UIButton *offline;
@property (strong, nonatomic) UIAlertController *alertController;
@property (weak, nonatomic) IBOutlet UIImageView *lauch_pic;
- (IBAction)Press_login_btn:(UIButton *)sender;
- (IBAction)Press_offline_btn:(id)sender;
- (IBAction)Press_LoginByVerificationCode_btn:(id)sender;
-(void)setmport:(NSUInteger) num;
-(void)sethost:(NSString*)host;
@end
