//
//  MySocket.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Base.h"
#import "DataTypeTranslater.h"
#import "SettingNameHandler.h"
#import "SettingPwdHandler.h"
#import "SettingAddressHandler.h"
#import "SettingMainPhoneHandler.h"
#import "AlertRequestViewController.h"
NSDate* aliveDate;
int _random = 0;
@implementation Base{
    int r;
    NSTimer* timer;
}
int const HEAD_INT_SIZE = 4;
int const Base_FILENUM = 3;
- (instancetype)initWithHost:(NSString*)host andPort:(int)port
{
    self = [super init];
    if (self) {
        //定义C语言输入输出流
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)host,port,&readStream,&writeStream);
        _inputStream = (__bridge NSInputStream*)(readStream);
        _outputStream = (__bridge NSOutputStream*)(writeStream);
        //设置代理
        _inputStream.delegate = self;
        _outputStream.delegate = self;
        [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream open];
        [_outputStream open];
        //初始化在线用户列表
        _onlineUserId = [[NSMutableArray alloc] init];
    }
    return self;
}
//- (void) timer{
//    // TODO Auto-generated method stub
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        timer = [NSTimer timerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            if (r != _random){
//                [timer invalidate];
//                return;
//            }
//            NSDate* date = [NSDate date];
//            long a = [date timeIntervalSince1970];
//            long b = [aliveDate timeIntervalSince1970];
//            int c = (int)(a - b);
//            if (c > 21){//25s没有接受到KEEP_ALIVE_SYNC,连接可能断开，尝试重新连接
//                if ([NetUtil getNetWorkStates] != AFNetworkReachabilityStatusNotReachable ){
//                    //reLogin();
//                }
//                [timer invalidate];
//            }
//        }];
//    });
//}
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    //    NSStreamEventOpenCompleted = 1UL << 0,//输入输出流打开完成
    //    NSStreamEventHasBytesAvailable = 1UL << 1,//有字节可读
    //    NSStreamEventHasSpaceAvailable = 1UL << 2,//可以发放字节
    //    NSStreamEventErrorOccurred = 1UL << 3,// 连接出现错误
    //    NSStreamEventEndEncountered = 1UL << 4// 连接结束
    switch (eventCode) {
            case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            break;
            case NSStreamEventHasBytesAvailable:
            NSLog(@"有字节可读");
            //[self readFromServer:self.inputStream];
            break;
            case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送字节");
            break;
            case NSStreamEventErrorOccurred:
            NSLog(@" 连接出现错误");
            break;
            case NSStreamEventEndEncountered:
            
            NSLog(@"连接结束");
        default:
            break;
    }
}
-(NSData*) readFromServer:(NSInputStream*) inputstream{
    @try{
        Byte sizeByte[12];
        [inputstream read:sizeByte maxLength:sizeof(sizeByte)];
        
        int size = [DataTypeTranslater bytesToInt:sizeByte offset:0];
        if(size == 0){
            return [NSData dataWithBytes:sizeByte length:0];
        }
        int count = size -12;
        Byte b[count];
        int readCount = 0;
        while(readCount < count){
            readCount += [inputstream read:b+readCount maxLength:count-readCount];
        }
        Byte all[size];
        memcpy(all,sizeByte,12);
        memcpy(all+12,b,count);
        return [NSData dataWithBytes:all length:size];
    }@catch(NSException* e){NSLog(@"%@",e);}
}
-(void) writeToServer:(NSOutputStream*) outputstream arrayBytes:(NSData*)bytes{
    const Byte* sendbytes = [bytes bytes];
    [outputstream write:sendbytes maxLength:[bytes length]];
}
-(void) close{
    // 关闭输入输出流
    [_inputStream close];
    [_outputStream close];
    // 从主runloop循环移除
    [_inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
-(int)getFileNum{
    return Base_FILENUM;
}
- (void) listen{
    NSLog(@"2321321");
//    aliveDate = [NSDate date];
//    [self timer];
    while(_inputStream.streamStatus == NSStreamStatusOpen && _outputStream.streamStatus == NSStreamStatusOpen){
        NSData* byteArray = [self readFromServer:_inputStream];
        const Byte* byteArray_b = [byteArray bytes];
        int size = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:0];
        int type = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:4];
//        if (r != _random) break;//已经建立新的Base时，结束此线程
        switch(type){
            case ENetworkMessage_KeepAliveSync:
                NSLog(@"ENetworkMessage_KeepAliveSync");
//                aliveDate = [NSDate date];
                [self keepAlive:byteArray andSize:size];
                break;
            case ENetworkMessage_LoginRsp:
                NSLog(@"ENetworkMessage_LoginRsp");
                //logInMsg(byteArray, size);
                break;
            case ENetworkMessage_GetUserinfoRsp :
                NSLog(@"ENetworkMessage_GetUserinfoRsp");
                //getUserInfo(byteArray, size);
                break;
            case ENetworkMessage_SendChatRsp:
                NSLog(@"ENetworkMessage_SendChatRsp");
                [self sendChat:byteArray andSize:size];
                break;
            case ENetworkMessage_ReceiveChatSync:
                NSLog(@"ENetworkMessage_ReceiveChatSync");
                [self receiveChat:byteArray andSize:size];
                break;
            case ENetworkMessage_GetPersonalinfoRsp:
                NSLog(@"ENetworkMessage_GetPersonalinfoRsp");
                [self getPersonalInfo:byteArray andSize:size];
                break;
            case ENetworkMessage_AddFriendRsp:
                NSLog(@"ENetworkMessage_AddFriendRsp");
                [self addFriend:byteArray andSize:size];
                break;
            case ENetworkMessage_ChangeFriendSync:
                NSLog(@"ENetworkMessage_ChangeFriendSync");
                [self changeFriend:byteArray andSize:size];
                break;
            case ENetworkMessage_AddFileRsp:
                NSLog(@"ENetworkMessage_AddFileRsp");
                [self addFile:byteArray andSize:size];
                break;
            case ENetworkMessage_AccreditRsp:
                NSLog(@"ENetworkMessage_AccreditRsp");
                //accredit(byteArray, size);
                break;
            case ENetworkMessage_GetDownloadFileInfoRsp:
                NSLog(@"ENetworkMessage_GetDownloadFileInfoRsp");
                //getProgress(byteArray, size);
                break;
            case ENetworkMessage_PersonalsettingsRsp:
                NSLog(@"ENetworkMessage_PersonalsettingsRsp");
                [self personalSetting:byteArray andSize:size];
                break;
            case ENetworkMessage_OfflineSync:
                NSLog(@"ENetworkMessage_OfflineSync");
                [self offlineSync:byteArray andSize:size];
                break;
            case ENetworkMessage_DeleteFileRsp:
                NSLog(@"ENetworkMessage_DeleteFileRsp");
                [self deleteFile:byteArray andSize:size];
                break;
            case ENetworkMessage_CreateGroupChatRsp:
                NSLog(@"ENetworkMessage_CreateGroupChatRsp");
                [self createGroupChat:byteArray andSize:size];
                break;
            case ENetworkMessage_GetGroupInfoRsp:
                NSLog(@"ENetworkMessage_GetGroupInfoRsp");
                [self getGroupInfo:byteArray andSize:size];
                break;
            case ENetworkMessage_ChangeGroupRsp:
                NSLog(@"ENetworkMessage_ChangeGroupRsp");
                [self changeGroupInfo:byteArray andSize:size];
                break;
            default:
                break;
      }
    }
    
}
- (void) changeGroupInfo:(NSData*)byteArray andSize:(int) size{
    @try {
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        ChangeGroupRsp* response = [ChangeGroupRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.resultCode == ChangeGroupRsp_ResultCode_UpdateSuccess){
            NSMutableDictionary* updateGroupMsg = [[NSMutableDictionary alloc] init];
            groupObj* group = [[groupObj alloc] init];
            group.groupId = [NSString stringWithFormat:@"%d",response.groupChatId];
            group.groupName =  response.newGroupName;
            group.memberUserId =  response.userIdArray;
            updateGroupMsg[@"obj"] = group;
            updateGroupMsg[@"what"] = [NSNumber numberWithInt:OrderConst_updateGroupInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:updateGroupMsg];
            });
        }
        if(response.resultCode == ChangeGroupRsp_ResultCode_DeleteSuccess){
            NSMutableDictionary* updateGroupMsg = [[NSMutableDictionary alloc] init];
            groupObj* group = [[groupObj alloc] init];
            group.groupId = [NSString stringWithFormat:@"%d",response.groupChatId];
            updateGroupMsg[@"obj"] = group;
            updateGroupMsg[@"what"] = [NSNumber numberWithInt:OrderConst_deleteGroupInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:updateGroupMsg];
            });
            /**
             * 感觉有安全隐患，List遍历中一旦出现多线程修改情况，会产生异常，
             * 如产生异常请修改，留坑，:>
             */
            for(int i = 0; i< Login_userGroups.count;i++){
                GroupItem* g = Login_userGroups[i];
                if([g.groupId intValue] == response.groupChatId){
                    [Login_userGroups removeObject:g];
                    break;
                }
            }
        }
    }@catch (NSException* e){
    }
}
- (void) getGroupInfo:(NSData*)byteArray andSize:(int) size{
    @try {
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        GetGroupInfoRsp* response = [GetGroupInfoRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if([response.where isEqualToString:@"page06FragmentGroup"]){
            NSMutableDictionary* msg = [[NSMutableDictionary alloc] init];
            msg[@"what"] = [NSNumber numberWithInt:OrderConst_showGroupFiles];
            msg[@"obj"] = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:msg];
            });
        }
    }@catch (NSException* e) {
    }
}
- (void) createGroupChat:(NSData*)byteArray andSize:(int) size{
    @try {
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        CreateGroupChatRsp* response = [CreateGroupChatRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.resultCode == CreateGroupChatRsp_ResultCode_Fail){

        }else{
            NSString* gid = [NSString stringWithFormat:@"%d",response.groupChatId];
            NSString* groupName = response.groupName;
            NSString* createrId = Login_userId;
            GroupItem* g = [[GroupItem alloc] init];
            g.createrUserId = createrId;
            g.groupId = gid;
            g.groupName = groupName;
            [Login_userGroups addObject:g];
            [NSThread detachNewThreadWithBlock:^{
                if (MainTabbarController_handlerTab06!= nil){
                    NSMutableDictionary* groupMsg = [[NSMutableDictionary alloc] init];
                    groupObj* group = [[groupObj alloc] init];
                    group.groupId = gid;
                    group.groupName = groupName;
                    group.groupCreateId = createrId;
                    groupMsg[@"what"] = [NSNumber numberWithInt:OrderConst_addGroupRequest];
                    groupMsg[@"obj"] = group;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MainTabbarController_handlerTab06 onHandler:groupMsg];
                    });
                }
            }];
        }
        
    }@catch (NSException* e){
    }
}
- (void)personalSetting:(NSData*)byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        PersonalSettingsRsp* response =  [PersonalSettingsRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.changeType == PersonalSettingsRsp_ChangeType_Password) {
            if (response.resultCode == PersonalSettingsRsp_ResultCode_Fail) {
                [[SettingPwdViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"what",nil]];
            } else if (response.resultCode == PersonalSettingsRsp_ResultCode_Success) {
                [[SettingPwdViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"what",nil]];
            } else if (response.resultCode == PersonalSettingsRsp_ResultCode_Oldpasswordwrong) {
                [[SettingPwdViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"what",nil]];
            }else if (response.resultCode == PersonalSettingsRsp_ResultCode_Codewrong){
                [[SettingPwdViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4],@"what",nil]];
            }
        }else if(response.changeType == PersonalSettingsRsp_ChangeType_Name) {
            if (response.resultCode == PersonalSettingsRsp_ResultCode_Fail) {
                [[SettingNameViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"what",nil]];
            } else if (response.resultCode == PersonalSettingsRsp_ResultCode_Success) {
                [[SettingNameViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"what",nil]];
            }
        }else if(response.changeType == PersonalSettingsRsp_ChangeType_Address) {
            if (response.resultCode == PersonalSettingsRsp_ResultCode_Fail) {
                [[SettingAddressViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"what",nil]];
            } else if (response.resultCode == PersonalSettingsRsp_ResultCode_Success) {
                [[SettingAddressViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"what",nil]];
            }
        }
        else if (response.changeType == PersonalSettingsRsp_ChangeType_Mainmac){
            if (response.resultCode == PersonalSettingsRsp_ResultCode_Fail){
               [[SettingMainPhoneViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"what",nil]];
            } else if (response.resultCode == PersonalSettingsRsp_ResultCode_Success){
               [[SettingMainPhoneViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"what",nil]];
            }else if(response.resultCode == PersonalSettingsRsp_ResultCode_Codewrong){
               [[SettingMainPhoneViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"what",nil]];
            }
        }
    }@catch (NSException* e) {
        NSLog(@"%@",e);
    }
}
- (void) offlineSync:(NSData*)byteArray andSize:(int) size{
    [[SettingPwdViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"what",nil]];
}
- (void) getPersonalInfo:(NSData*) byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        GetPersonalInfoRsp* response = [GetPersonalInfoRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        
        if (response.resultCode == GetPersonalInfoRsp_ResultCode_Fail  && [response.where isEqualToString:@""]){
            if (!([searchFriend getHandler] == nil)){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[searchFriend getHandler] onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                });
            }
        }
        else if([response.where isEqualToString:@"searchFriend"]){
            userObj* user = [[userObj alloc] init];
            user.userId = response.userInfo.userId;
            user.userName = response.userInfo.userName;
            user.isFriend = response.userInfo.isFriend;
            user.fileNum = response.userInfo.fileNum;
            user.isOnline = response.userInfo.isOnline;
            user.headIndex = response.userInfo.headIndex;
            user.shareFiles = response.filesArray;
            dispatch_async(dispatch_get_main_queue(), ^{
            [[searchFriend getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"what",user,@"obj",nil]];
            });
        }
        else if([response.where isEqualToString:@"page06FragmentUnfriend"]){
            NSMutableArray<FileItem*>* showFilesList = response.filesArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_showUnfriendFiles],@"what",showFilesList,@"obj", nil]];
            });
        }
        else if([response.where isEqualToString:@"page06FragmentFriend"]){
            NSMutableArray<FileItem*>* showFilesList = response.filesArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_showFriendFiles],@"what",showFilesList,@"obj", nil]];
            });
        }
        else if([response.where isEqualToString:@"baseLogin"]){
            NSString* uid = response.userInfo.userId;
            if(![uid isEqualToString:Login_userId]){
                userObj* user = [[userObj alloc] init];
                user.userId = uid;
                user.userName = response.userInfo.userName;
                user.fileNum = response.userInfo.fileNum;
                user.headIndex = response.userInfo.headIndex;
                NSNumber* what;
                if(response.userInfo.isFriend){
                    what = [NSNumber numberWithInt:OrderConst_friendUserLogIn_order];//好友用户登录
                }
                else if(response.userInfo.fileNum >= Base_FILENUM){
                    what = [NSNumber numberWithInt:OrderConst_shareUserLogIn_order];//多文件用户登录
                }
                else{
                    what = [NSNumber numberWithInt:OrderConst_netUserLogIn_order];//多文件用户登录
                }
                [MainTabbarController_handlerTab06 onHandler:[NSDictionary dictionaryWithObjectsAndKeys:what,@"what",user,@"obj", nil]];
                [_onlineUserId addObject:uid];
            }
        }
    }@catch (NSException* e) {
        NSLog(@"%@",e.name);
    }
}
- (void) addFriend:(NSData*) byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        AddFriendRsp* response = [AddFriendRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.requestType == AddFriendRsp_RequestType_Request){
            NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
            userObj* user = [[userObj alloc] init];
            user.userId = response.user.userId;
            user.fileNum= response.user.fileNum;
            user.userName = response.user.userName;
            user.headIndex = response.user.headIndex;
            [msg setObject:[NSNumber numberWithInt:OrderConst_addFriend_order] forKey:@"what"];
            [msg setObject:user forKey:@"obj"];
            RequestFriendObj* request = [[RequestFriendObj alloc] init];
            request.friend_id = response.user.userId;
            request.friend_filenum = response.user.fileNum;
            request.friend_headindex = response.user.headIndex;
            request.friend_name = response.user.userName;
            request.isagree = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:msg];
            });
            FriendRequestDBManager* friendRequestDB = [MainTabbarController getFriendRequestDBManager];
            [friendRequestDB addRequestFriendSQL:request AndTable:[NSString stringWithFormat:@"%@friend",Login_userId]];
        }
    }@catch (NSException* e) {
        NSLog(@"%@",e.name);
    }
}
- (void) changeFriend:(NSData*) byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        
        ChangeFriendSync* response = [ChangeFriendSync parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.changeType == ChangeFriendSync_ChangeType_Add){
            NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
            userObj* user = [[userObj alloc] init];
            user.userId = response.userItem.userId;
            user.fileNum= response.userItem.fileNum;
            user.userName = response.userItem.userName;
            user.isFriend = response.userItem.isFriend;
            user.headIndex = response.userItem.headIndex;
            [msg setObject:[NSNumber numberWithInt:OrderConst_userFriendAdd_order] forKey:@"what"];
            [msg setObject:user forKey:@"obj"];
            RequestFriendObj* request = [[RequestFriendObj alloc] init];
            request.friend_id = response.userItem.userId;
            request.friend_filenum = response.userItem.fileNum;
            request.friend_headindex = response.userItem.headIndex;
            request.friend_name = response.userItem.userName;
            request.isagree = 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:msg];
            });
            FriendRequestDBManager* friendRequestDB = [MainTabbarController getFriendRequestDBManager];
            [friendRequestDB changeRequestStateSQL:request Table:[NSString stringWithFormat:@"%@friend",Login_userId]];
            NSLog(@"addfriend_add finish");
        }
    }@catch (NSException* e) {
        NSLog(@"%@",e.name);
    }
}
- (void)sendChat:(NSData*) byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        
        SendChatRsp* response =  [SendChatRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.resultCode == SendChatRsp_ResultCode_Success){
            if([response.where isEqualToString:@"chat"]) {
                long chatId = response.chatId;
                long date = response.date;
                NSMutableArray<NSNumber*>* msgObj = [[NSMutableArray alloc] init];
                [msgObj addObject:[NSNumber numberWithLong:chatId]];
                [msgObj addObject:[NSNumber numberWithLong:date]];
                NSMutableDictionary* msg = [[NSMutableDictionary alloc] init];
                msg[@"obj"] = msgObj;
                msg[@"what"] = @0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[fileList getHandler] onHandler:msg];
                });
            }
            else if([response.where isEqualToString:@"group"]) {
                long chatId = response.chatId;
                long date = response.date;
                NSMutableArray<NSNumber*>* msgObj = [[NSMutableArray alloc] init];
                [msgObj addObject:[NSNumber numberWithLong:chatId]];
                [msgObj addObject:[NSNumber numberWithLong:date]];
                NSMutableDictionary* msg = [[NSMutableDictionary alloc] init];
                msg[@"obj"] = msgObj;
                msg[@"what"] = @0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[GroupChat getHandler] onHandler:msg];
                });
            }
            else if([response.where isEqualToString:@"download"]){
                
            }else if([response.where isEqualToString:@"agreeDownload"]){
                FileRequestDBManager* fileRequestDBManager = [MainTabbarController getFileRequestDBManager];
                [fileRequestDBManager deleteFileRequestSQL:response.peerId Date:response.fileDate Table:[NSString stringWithFormat:@"%@transform",Login_userId]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[dealFileRequest getmHandler] onHandler:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                });
            }else if([response.where isEqualToString:@"disagreeDownload"]){
                FileRequestDBManager* fileRequestDBManager = [MainTabbarController getFileRequestDBManager];
                [fileRequestDBManager deleteFileRequestSQL:response.peerId Date:response.fileDate Table:[NSString stringWithFormat:@"%@transform",Login_userId]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[dealFileRequest getmHandler] onHandler:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"what"]];
                });
            }
        }else{
            if([response.where isEqualToString:@"agreeDownload"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[dealFileRequest getmHandler] onHandler:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:3] forKey:@"what"]];
                });
            }
        }
    }@catch (NSException* e) {
        NSLog(@"%@",e.name);
    }
}
- (void) receiveChat:(NSData*) byteArray andSize:(int) size{
    [NSThread detachNewThreadWithBlock:^{
        @try {
            int objlength = size - [NetworkPacket getMessageObjectStartIndex];
            Byte* byteArray_b = (Byte*)[byteArray bytes];
            Byte objBytes[objlength];
            for (int i = 0; i < objlength; i++)
                objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
            
            ReceiveChatSync* response = [ReceiveChatSync parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
            
            if (response.chatDataArray[0].targetType == ChatItem_TargetType_System) {
                NSString* chatData = response.chatDataArray[0].chatBody;
                if([chatData containsString:@"logOut"]){
                    NSString* logOutUserId = [chatData substringToIndex:chatData.length-6];
                    NSMutableDictionary* userMsg = [[NSMutableDictionary alloc] init];
                    userObj* user = [[userObj alloc] init];
                    user.userId = logOutUserId;
                    userMsg[@"what"] =[NSNumber numberWithInt:OrderConst_userLogOut];
                    userMsg[@"obj"] = user;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MainTabbarController_handlerTab06 onHandler:userMsg];
                    });
                }else if([[chatData componentsSeparatedByString:@","][0] isEqualToString:@"mobile accredit request"]){
                    NSMutableDictionary * bundle = [[NSMutableDictionary alloc] init];
                    bundle[@"style"] = @"accreditRequest";
                    bundle[@"mobileInfo"] = [chatData componentsSeparatedByString:@","][2];
                    bundle[@"mobileMac"] = [chatData componentsSeparatedByString:@","][1];
                    bundle[@"deviceType"] = @"mobile";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AlertAccreditActivity* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertAccreditActivity"];
                        vc.intentBundle = bundle;
                        [[self topViewController] presentViewController:vc animated:YES completion:nil];
                    });
                }else if([[chatData componentsSeparatedByString:@","][0] isEqualToString:@"pc accredit request"]){
                    NSLog(@"授权消息");
                    NSMutableDictionary * bundle = [[NSMutableDictionary alloc] init];
                    bundle[@"style"] = @"accreditRequest";
                    bundle[@"mobileInfo"] = [chatData componentsSeparatedByString:@","][2];
                    bundle[@"mobileMac"] = [chatData componentsSeparatedByString:@","][1];
                    bundle[@"deviceType"] = @"pc";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AlertAccreditActivity* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertAccreditActivity"];
                        vc.intentBundle = bundle;
                        [[self topViewController] presentViewController:vc animated:YES completion:nil];
                    });
                }else if([chatData containsString:@"FILE_EXIST_RECEIVER"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo","已存在相同文件"+chatData.split(",")[1]);
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"FILE_EXIST_SENDER"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo","对方已存在相同文件"+chatData.split(",")[1]);
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"NO_SUCH_FILE_RECEIVER"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"已被对方删除或更换了路径");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"NO_SUCH_FILE_SENDER"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"已删除或更换了路径");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"HOLE_SUCCESS"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"打洞成功,开始直接传输");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"HOLE_FAIL"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"由于运营商问题直接传输失败，开始中继传输");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"FILE_OVER"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"文件接收完成");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"RELAY_SUCCESS"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo","中继传输成功");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"RELAY_FAIL"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo","中继传输失败，请重试");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"PAIR_CONNECTION_FULL"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"正在下载，请等待传输完成后再重试");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"UDP_CONNECTION_FULL"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo","下载通路已满，请等待正在下载的文件下载完成后重试");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"RELAY_CONNECTION_FULL"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo","下载通路已满，请等待正在下载的文件下载完成后重试");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"RELAY_FILE_TOO_BIG"]){
//                    Intent intent = new Intent(MyApplication.getContext(),MyService.class);
//                    intent.putExtra("style","holeMsg");
//                    intent.putExtra("msgInfo",chatData.split(",")[1]+"文件太大，请重试");
//                    MyApplication.getContext().startService(intent);
                }
                else if([chatData containsString:@"fileProcess"]){
//                    Message friendDownloadStateMsg = DownloadStateFragment.mHandler.obtainMessage();
//                    String fileList = chatData.substring(chatData.indexOf(",")+1);
//                    friendDownloadStateMsg.obj = fileList;
//                    friendDownloadStateMsg.what = 0;
//                    downloadManager.mHandler.sendMessage(friendDownloadStateMsg);
                }
            }
            if (response.chatDataArray[0].targetType == ChatItem_TargetType_Download) {
                NSMutableDictionary* fileRequestMsg = [[NSMutableDictionary alloc] init];
                fileObj* fileRequest = [[fileObj alloc] init];
                fileRequest.fileDate = response.chatDataArray[0].fileDate;
                fileRequest.fileName = response.chatDataArray[0].fileName;
                fileRequest.senderId = response.chatDataArray[0].sendUserId;
                fileRequest.fileSize = [response.chatDataArray[0].fileSize intValue];
                FileRequestDBManager* fileRequestDBManager = [MainTabbarController getFileRequestDBManager];
                [fileRequestDBManager addFileRequestSQL:fileRequest AndTable:[NSString stringWithFormat:@"%@transform",Login_userId]];
                fileRequestMsg[@"obj"] = fileRequest;
                fileRequestMsg[@"what"] = [NSNumber numberWithInt:OrderConst_addFileRequest];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MainTabbarController_handlerTab06 onHandler:fileRequestMsg];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    AlertRequestViewController* vc = [[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertRequestViewController"];
                    vc.intentBundle = [NSMutableDictionary dictionaryWithObjectsAndKeys:response.chatDataArray[0].fileName,@"fileName",response.chatDataArray[0].sendUserId,@"userId",nil];
                    [[self topViewController] presentViewController:vc animated:YES completion:nil];
                });
            }
            if(response.chatDataArray[0].targetType == ChatItem_TargetType_Agreedownload){
                @try {
                    NSMutableDictionary* friendDownloadMsg = [[NSMutableDictionary alloc] init];
                    NSMutableDictionary* friendDownloadStateMsg = [[NSMutableDictionary alloc] init];
                    fileObj* fileInfo = [[fileObj alloc] init];
                    fileInfo.fileName = response.chatDataArray[0].fileName;
                    fileInfo.fileSize = [response.chatDataArray[0].fileSize intValue];
                    fileInfo.senderId = response.chatDataArray[0].sendUserId;
                    
                    friendDownloadMsg[@"obj"] = fileInfo;
                    friendDownloadMsg[@"what"] = [NSNumber numberWithInt:OrderConst_agreeDownload];
                    friendDownloadStateMsg[@"obj"] = fileInfo;
                    friendDownloadStateMsg[@"what"] = [NSNumber numberWithInt:OrderConst_agreeDownloadState];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MainTabbarController_downloadHandler onHandler:friendDownloadMsg];
                        [MainTabbarController_stateHandler onHandler:friendDownloadStateMsg];
                        [MainTabbarController_handlerTab06 onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:OrderConst_shareFileFail] forKey:@"what"]];
                    });
                }@catch (NSException* e){
                    NSLog(@"%@",e.name);
                }
            }
            if(response.chatDataArray[0].targetType == ChatItem_TargetType_Disagreedownload){
                //对方拒绝传输文件
            }
            //成为发送端，发送到pc
            if(response.chatDataArray[0].targetType == ChatItem_TargetType_Send){
                NSString* receiverId = response.chatDataArray[0].sendUserId;
                NSString* senderId = response.chatDataArray[0].receiveUserId;
                NSString* fileDate = response.chatDataArray[0].fileDate;
                NSString* fileName = response.chatDataArray[0].fileName;
                
                NSString* PcIp = @"";
                if([MyUIApplication getPC_YInforList].count == 0){
                    return;
                }else{
                    // PcIp = "192.168.1.132";
                    PcIp = [MyUIApplication getPC_YInforList][0].ip;
                }
                int PcPort = 4003;
                ///
                NSString* s = @"";
                CFReadStreamRef readStream;
                CFWriteStreamRef writeStream;
                NSInputStream* inputStream;
                NSOutputStream* outputStream;
                @try{
                    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)PcIp,PcPort,&readStream,&writeStream);
                    inputStream = (__bridge NSInputStream*)(readStream);
                    outputStream = (__bridge NSOutputStream*)(writeStream);
                    [inputStream open];
                    [outputStream open];
                    //发送数据
                    NSString* message = [NSString stringWithFormat:@"send:%@,%@,%@\n",fileDate,senderId,receiverId];
                    NSData* senddata =[message dataUsingEncoding:NSUTF8StringEncoding];
                    [outputStream write:[senddata bytes] maxLength:[senddata length]];
                    Byte receivedbuf[100];
                    [inputStream read:receivedbuf maxLength:sizeof(receivedbuf)];
                    s = [[NSString alloc] initWithData:[NSData dataWithBytes:receivedbuf length:100] encoding:NSUTF8StringEncoding];
                    ///
                if([s isEqualToString:@"server is busy"]){
                    NSLog(@"服务器忙，请稍后在试");
                }
                if([s isEqualToString:@"server get"]){
                    NSLog(@"发送成功");
                }
                }@catch(NSException* e){}
                @finally{
                    [inputStream close];
                    [outputStream close];
                }
            }
            //成为接收端，发送到PC
            if(response.chatDataArray[0].targetType == ChatItem_TargetType_Receive){
                NSString* fileName = response.chatDataArray[0].fileName;
                NSString* senderId = response.chatDataArray[0].sendUserId;
                NSString* receiverId = response.chatDataArray[0].receiveUserId;
                
                NSString* PcIp = @"";
                if([MyUIApplication getPC_YInforList].count == 0){
                    return;
                }else{
                    // PcIp = "192.168.1.132";
                    PcIp = [MyUIApplication getPC_YInforList][0].ip;
                }
                int PcPort = 4003;
                ///
                NSString* s = @"";
                CFReadStreamRef readStream;
                CFWriteStreamRef writeStream;
                NSInputStream* inputStream;
                NSOutputStream* outputStream;
                @try{
                    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)PcIp,PcPort,&readStream,&writeStream);
                    inputStream = (__bridge NSInputStream*)(readStream);
                    outputStream = (__bridge NSOutputStream*)(writeStream);
                    [inputStream open];
                    [outputStream open];
                    //发送数据
                    NSString* message = [NSString stringWithFormat:@"receive:%@,%@,%@\n",fileName,senderId,receiverId];
                    NSData* senddata =[message dataUsingEncoding:NSUTF8StringEncoding];
                    [outputStream write:[senddata bytes] maxLength:[senddata length]];
                    Byte receivedbuf[100];
                    [inputStream read:receivedbuf maxLength:sizeof(receivedbuf)];
                    s = [[NSString alloc] initWithData:[NSData dataWithBytes:receivedbuf length:100] encoding:NSUTF8StringEncoding];
                    ///
                    if([s isEqualToString:@"server is busy"]){
                        NSLog(@"服务器忙，请稍后在试");
                    }
                    if([s isEqualToString:@"server get"]){
                        NSLog(@"发送成功");
                    }
                }@catch(NSException* e){}
                @finally{
                    [inputStream close];
                    [outputStream close];
                }
            }
            if(response.chatDataArray[0].targetType == ChatItem_TargetType_Individual || response.chatDataArray[0].targetType == ChatItem_TargetType_Group ){
                NSString* chatContent = response.chatDataArray[0].chatBody;
                NSString* senderId = response.chatDataArray[0].sendUserId;
                ChatObj* chat = [[ChatObj alloc] init];
                chat.date = response.chatDataArray[0].date;
                chat.msg = chatContent;
                chat.receiver_id = response.chatDataArray[0].receiveUserId;
                chat.sender_id = senderId;
                ChatDBManager* chatDB = [MainTabbarController getChatDBManager];
                [chatDB addChatSQL:chat AndTable:Login_userId];
                
                UIViewController* top = [self topViewController];
                NSString* className =  NSStringFromClass([top class]);
                NSLog(@"base_current activity is %@",className);
                if([className isEqualToString:@"fileList"] && [senderId isEqualToString:[fileList getUserId]]){
                    NSMutableDictionary* chatMsg = [[NSMutableDictionary alloc] init];
                    chatMsg[@"obj"] = chat;
                    chatMsg[@"what"] = @2;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[fileList getHandler] onHandler:chatMsg];
                    });
                }else{
                    if([[Fragment4ViewController getFriendChatNum] objectForKey:senderId]){
                        NSMutableDictionary * temp =[Fragment4ViewController getFriendChatNum];
                        [temp setObject:@([[temp objectForKey:senderId] intValue]+1) forKey:senderId];
                    }else{
                        [[Fragment4ViewController getFriendChatNum] setObject:@1 forKey:senderId];
                    }
                    NSMutableDictionary* chatMsg = [[NSMutableDictionary alloc] init];
                    userObj* user = [[userObj alloc] init];
                    user.userId = senderId;
                    chatMsg[@"obj"] = user;
                    chatMsg[@"what"] = [NSNumber numberWithInt:OrderConst_addChatNum];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MainTabbarController_handlerTab06 onHandler:chatMsg];
                    });
                }
            }
        }@catch (NSException* e) {
            NSLog(@"%@",e.name);
        }
    }];
}
- (void) addFile:(NSData*) byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        
        AddFileRsp* response =  [AddFileRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];

        if(response.resultCode == AddFileRsp_ResultCode_Success){
            
            [MyUIApplication addMySharedFlies:[PCFileHelper getSelectedShareFile]];
            
            NSMutableDictionary* shareFile04 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* shareFile06 = [[NSMutableDictionary alloc] init];
            BOOL shareState = YES;
            shareFile04[@"what"] = [NSNumber numberWithInt:OrderConst_shareFileState];
            shareFile04[@"obj"] = [NSNumber numberWithBool:shareState];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab01 onHandler:shareFile04];
            });
            fileObj* file = [[fileObj alloc] init];
            file.fileName = response.fileName;
            file.fileInfo = response.fileInfo;
            file.fileSize = [response.fileSize intValue];
            file.fileDate = response.fileDate;
            shareFile06[@"what"] = [NSNumber numberWithInt:OrderConst_shareFileSuccess];
            shareFile06[@"obj"] = file;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:shareFile06];
            });
        }else {
            NSMutableDictionary* shareFile04 = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* shareFile06 = [[NSMutableDictionary alloc] init];
            BOOL shareState = NO;
            shareFile04[@"what"] = [NSNumber numberWithInt:OrderConst_shareFileState];
            shareFile04[@"obj"] = [NSNumber numberWithBool:shareState];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab01 onHandler:shareFile04];
            });
            
            shareFile06[@"what"] = [NSNumber numberWithInt:OrderConst_shareFileFail];
            shareFile06[@"obj"] = [NSNumber numberWithBool:shareState];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab01 onHandler:shareFile04];
            });
        }
    }@catch (NSException* e) {
        NSLog(@"%@",e.name);
    }
}
- (void) keepAlive:(NSData*) byteArray andSize:(int) size{
    @try {
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        
        KeepAliveSyncPacket* response =  [KeepAliveSyncPacket parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if([response.clientsId isEqualToString:@""]) return;
        NSArray* ids = [response.clientsId componentsSeparatedByString:@","];
//        System.out.println(response.getClientsId());
//        System.out.println(onlineUserId);
        NSMutableDictionary<NSString*, NSNumber*>* hm = [[NSMutableDictionary alloc] init];
        for (NSString* userid in _onlineUserId){
            [hm setObject:@5 forKey:userid];
        }

        for(int i = 0; i < ids.count; i++){
            if([hm objectForKey:ids[i]]){
                [hm setObject:@7 forKey:ids[i]];
            }else{
                [hm setObject:@2 forKey:ids[i]];
            }
        }
        for (NSString *s in [hm allKeys]) {
            NSLog(@"key: %@", s);
            if([hm[s] intValue] == 2){
                //新登录用户
                @try {
                    if(![s isEqualToString:Login_userId]){
                        GetPersonalInfoReq* builder = [[GetPersonalInfoReq alloc] init];
                        builder.where = @"baseLogin";
                        builder.userId  = s;
                        builder.userInfo = YES;
                        
                        NSData* getUserInfo = [NetworkPacket packMessage:ENetworkMessage_GetPersonalinfoReq packetBytes:[builder data]];
                        [Login_base writeToServer:Login_base.outputStream arrayBytes:getUserInfo];
                    }
                } @catch (NSException* e) {
                
                }
                
            }
            else if([hm[s] intValue] == 5){
                //有用户登出
                [NSThread detachNewThreadWithBlock:^{
                    if (MainTabbarController_handlerTab06 != nil){
                        NSMutableDictionary* userMsg = [[NSMutableDictionary alloc] init];
                        userObj* user = [[userObj alloc] init];
                        user.userId = s;
                        userMsg[@"what"] = [NSNumber numberWithInt:OrderConst_userLogOut];
                        userMsg[@"obj"] = user;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MainTabbarController_handlerTab06 onHandler:userMsg];
                        });
                        [_onlineUserId removeObject:s];
                    }
                }];
            }
        }
    }@catch (NSException* e){
        NSLog(@"%@",e.name);
    }
}
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
- (void) deleteFile:(NSData*) byteArray andSize:(int) size{
    @try{
        int objlength = size - [NetworkPacket getMessageObjectStartIndex];
        Byte* byteArray_b = (Byte*)[byteArray bytes];
        Byte objBytes[objlength];
        for (int i = 0; i < objlength; i++)
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex] + i];
        
        DeleteFileRsp* response =  [DeleteFileRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.resultCode == DeleteFileRsp_ResultCode_Fail){
            if([sharedFileIntentVC getHandler] !=nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[sharedFileIntentVC getHandler] onHandler:[NSDictionary dictionaryWithObject:@2 forKey:@"what"]];
                });
            }
        }else if(response.resultCode == DeleteFileRsp_ResultCode_Success){
            for (int i = 0; i < [MyUIApplication getmySharedFiles].count; i++){
                SharedflieBean* file = [MyUIApplication getmySharedFiles][i];
                if ([file.name isEqualToString:response.fileName] && [file.des isEqualToString:response.fileInfo]){
                    [[MyUIApplication getmySharedFiles] removeObjectAtIndex:i];
                    i--;
                }
            }
            if([sharedFileIntentVC getHandler] !=nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[sharedFileIntentVC getHandler] onHandler:[NSDictionary dictionaryWithObject:@1 forKey:@"what"]];
                });
            }
            NSMutableDictionary* shareFile06 = [[NSMutableDictionary alloc] init];
            shareFile06[@"what"] = [NSNumber numberWithInt:OrderConst_deleteShareFileSuccess];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MainTabbarController_handlerTab06 onHandler:shareFile06];
            });
        }
    }@catch (NSException* e) {
    }
}
@end
