//
//  searchFriend.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "searchFriend.h"
#import "headIndexToImgId.h"
#import "GetPersonalInfoMsg.pbobjc.h"
#import "NetworkPacket.h"
#import "ProtoHead.pbobjc.h"
#import "LoginViewController.h"
#import "LoginByVerificationCode.h"
#import "AddFriendMsg.pbobjc.h"
@interface searchFriend (){
    NSString* userSearchId;
}

@end

static searchFriendHandler* mHandler;
static userObj* userItem;
@implementation searchFriend

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchFriendWrap.hidden = YES;
    _userSearchBtn.hidden = YES;
    mHandler = [[searchFriendHandler alloc] initWithController:self];
    [_myIdNum setText:[NSString stringWithFormat:@"我的Id号：%@",_myUserId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Press_searchUserIdBtn:(id)sender {
    userSearchId = _searchUserId.text;
    [NSThread detachNewThreadWithBlock:^{
        @try{
            GetPersonalInfoReq* builder = [[GetPersonalInfoReq alloc] init];
            builder.where = @"searchFriend";
            builder.userId = userSearchId;
            builder.userInfo = YES;
            builder.fileInfo = YES;
            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_GetPersonalinfoReq packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
        }@catch (NSException* e){
            NSLog(@"%@",e.name);
        }
    }];
}

- (IBAction)Press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Press_userSearchBtn:(id)sender {
    if ([_userSearchBtn.titleLabel.text isEqualToString:@"添加好友"]){
        if(userItem.isOnline == YES){
            [NSThread detachNewThreadWithBlock:^{
                @try{
                    AddFriendReq* builder = [[AddFriendReq alloc] init];
                    builder.friendUserId = userItem.userId;
                    builder.requestType = AddFriendReq_RequestType_Request;
                    NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_AddFriendReq packetBytes:[builder data]];
                    [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
                }@catch (NSException* e){
                    NSLog(@"%@",e.name);
                }
            }];
            [Toast ShowToast:@"请求已发送" Animated:YES time:1 context:self.view];
        }
        else{
            [Toast ShowToast:@"该用户不在线，无法添加" Animated:YES time:1 context:self.view];
        }
    }
    else if ([_userSearchBtn.titleLabel.text isEqualToString:@"查看文件"]) {
        myFileList* mf = [[myFileList alloc] init];
        mf.list = userItem.shareFiles;
        fileList* fl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"fileList"];
        fl.intentBundle = [NSMutableDictionary dictionaryWithObjectsAndKeys:[headIndexToImgId toImgId:userItem.headIndex],@"userHead",
                           userItem.userName,@"userName",
                           userItem.userId,@"userId",
                           mf,@"friendFile",
                           Login_userId,@"myUserId",
                           [headIndexToImgId toImgId:Login_userHeadIndex],@"myUserHead",nil];
        [self presentViewController:fl animated:YES completion:nil];
    }
}
+ (searchFriendHandler*) getHandler{
    return mHandler;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchUserId resignFirstResponder];
}
@end


@implementation searchFriendHandler
- (instancetype)initWithController:(searchFriend*) ctl{
    if(self = [super init]){
        _holder = ctl;
    }
    return self;
}

- (void)onHandler:(NSDictionary *)message {
    switch ([message[@"what"] intValue]) {
        case 0:{
            if([message objectForKey:@"obj"] != nil){
                userItem = (userObj*)message[@"obj"];
                _holder.searchFriendWrap.hidden = NO;
                [_holder.userSearchFileNum setText:[NSString stringWithFormat:@"他共享了%d个文件",userItem.fileNum]];
                [_holder.searchUserHead setImage:[UIImage imageNamed:[headIndexToImgId toImgId:userItem.headIndex]]];
                if(userItem.isFriend || [userItem.userId isEqualToString:_holder.myUserId]){
                    if(userItem.isOnline){
                        [_holder.userSearchName setText:[NSString stringWithFormat:@"%@(在线)",userItem.userName]];
                    }
                    else{
                        [_holder.userSearchName setText:[NSString stringWithFormat:@"%@(不在线)",userItem.userName]];
                    }
                    [_holder.userSearchIsFriend setText:@"该用户与您已是好友，无法添加"];
                    [_holder.userSearchBtn setBackgroundColor:[UIColor colorWithRed:52/255.0 green:173/255.0 blue:253/255.0 alpha:1]];
                    [_holder.userSearchBtn setTitle:@"查看文件" forState:UIControlStateNormal];
                }
                else{
                    if(userItem.isOnline){
                        [_holder.userSearchName setText:[NSString stringWithFormat:@"%@(在线)",userItem.userName]];
                        [_holder.userSearchIsFriend setText:@"该用户与您还不是好友"];
                        [_holder.userSearchBtn setBackgroundColor:[UIColor colorWithRed:52/255.0 green:173/255.0 blue:253/255.0 alpha:1]];
                    }
                    else{
                        [_holder.userSearchName setText:[NSString stringWithFormat:@"%@(不在线)",userItem.userName]];
                        [_holder.userSearchIsFriend setText:@"该用户当前不在线，无法添加"];
                        [_holder.userSearchBtn setBackgroundColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1]];
                    }
                    [_holder.userSearchBtn setTitle:@"添加好友" forState:UIControlStateNormal];
                }
                _holder.userSearchBtn.hidden = NO;
            }
            break;
        }
        case 1:{
            [Toast ShowToast:@"未查询到相关用户" Animated:YES time:1 context:_holder.view];
            break;
        }
        default:break;
    }
}
@end
