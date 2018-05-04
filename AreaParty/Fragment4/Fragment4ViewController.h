//
//  Fragment4ViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabbarController.h"
#import "SharedflieBean.h"
#import "MyUIApplication.h"
#import "FileTypeConst.h"
#import "UserData.pbobjc.h"
#import "LoginViewController.h"
#import "LoginByVerificationCode.h"
#import "fileIndexToImgId.h"
#import "searchFriend.h"
#import "tab06_useritem.h"
#import "tab06_fileitem.h"
#import "fileList.h"
#import "dealFriendRequest.h"
#import "UserInfoListDialog.h"
#import "GetPersonalInfoMsg.pbobjc.h"
#import "NetworkPacket.h"
#import "FileListDialog.h"
#import "downloadManager.h"
#import "DeleteFileMsg.pbobjc.h"
#import "Share_File_Dialog.h"
@interface Fragment4ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *outline_view;
@property (weak, nonatomic) IBOutlet UITableView *id_tab06_userFriend;
- (IBAction)press_helpInfo:(id)sender;
- (IBAction)press_addFriend:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addFriend_btn;
@property (weak, nonatomic) IBOutlet UIImageView *id_tab06_friend;
@property (weak, nonatomic) IBOutlet UITableView *id_tab06_userNet;
@property (weak, nonatomic) IBOutlet UITableView *id_tab06_fileComputer;
@property (weak, nonatomic) IBOutlet UIView *mnewFriend_wrap;
@property (weak, nonatomic) IBOutlet UIView *transform_wrap;
@property (weak, nonatomic) IBOutlet UIView *download_wrap;

@property (weak, nonatomic) IBOutlet UIImageView *id_tab06_net;
@property (weak, nonatomic) IBOutlet UIView *id_tab06_shareWrap;
@property (weak, nonatomic) IBOutlet UITableView *id_tab06_userShare;
@property (weak, nonatomic) IBOutlet UIImageView *id_tab06_share;
@property (weak, nonatomic) IBOutlet UIView *id_tab06_netWrap;
@property (weak, nonatomic) IBOutlet UIView *id_tab06_fileWrap;
@property (weak, nonatomic) IBOutlet UIImageView *id_tab06_file;
@property (weak, nonatomic) IBOutlet UIView *id_tab06_friendWrap;
@property (weak, nonatomic) IBOutlet UIScrollView *container_scroll_view;
@property (weak, nonatomic) IBOutlet UIButton *help_btn;
- (void) delFriend:(NSMutableDictionary*) msg;
- (void) addFriend:(NSMutableDictionary*) msg;
- (void) friendUserAdd:(NSMutableDictionary*) msg;
- (void) showFriendFiles:(NSDictionary*) message;
+ (NSMutableDictionary<NSString*,NSNumber*>*)getFriendChatNum;
- (void) addFileRequest:(NSDictionary*) message;
- (void) showFileList:(NSMutableDictionary*) msg;
- (void) shareUserLogIn:(NSMutableDictionary*) msg;
- (void) friendUserLogIn:(NSMutableDictionary*) msg;
- (void) userLogOut:(NSMutableDictionary*) msg;
- (void) shareFileSuccess:(NSMutableDictionary*) msg;
- (void) addChatNum:(NSMutableDictionary*) msg;
- (void) shareFileFail;
- (void) deleteFileSuccess:(NSMutableDictionary*) msg;
@end
