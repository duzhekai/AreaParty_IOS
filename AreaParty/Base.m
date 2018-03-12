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
@implementation Base
int const HEAD_INT_SIZE = 4;
int const FILENUM = 3;
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
    Byte sizeByte[12];
    [inputstream read:sizeByte maxLength:sizeof(sizeByte)];
    
    int size = [DataTypeTranslater bytesToInt:sizeByte offset:0];
    if(size == 0){
        return [NSData dataWithBytes:sizeByte length:0];
    }
    int count = size -12;
    Byte b[count];
    int readCount = 0;
    @try{
    while(readCount < count){
        readCount += [inputstream read:b+readCount maxLength:count-readCount];
    }
    }@catch(NSException* e){NSLog(@"%@",e);}
    Byte all[size];
    memcpy(all,sizeByte,12);
    memcpy(all+12,b,count);
    return [NSData dataWithBytes:all length:size];
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
    return FILENUM;
}

- (void) listen{
    NSLog(@"2321321");
    while(_inputStream.streamStatus == NSStreamStatusOpen && _outputStream.streamStatus == NSStreamStatusOpen){
        NSData* byteArray = [self readFromServer:_inputStream];
        const Byte* byteArray_b = [byteArray bytes];
        int size = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:0];
        int type = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:4];
        switch(type){
            case ENetworkMessage_KeepAliveSync:
                NSLog(@"ENetworkMessage_KeepAliveSync");
                //keepAlive(byteArray,size);
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
                //sendChat(byteArray, size);
                break;
            case ENetworkMessage_ReceiveChatSync:
                NSLog(@"ENetworkMessage_ReceiveChatSync");
                //receiveChat(byteArray, size);
                break;
            case ENetworkMessage_GetPersonalinfoRsp:
                NSLog(@"ENetworkMessage_GetPersonalinfoRsp");
                //getPersonalInfo(byteArray,size);
                break;
            case ENetworkMessage_AddFriendRsp:
                NSLog(@"ENetworkMessage_AddFriendRsp");
                //addFriend(byteArray, size);
                break;
            case ENetworkMessage_ChangeFriendSync:
                NSLog(@"ENetworkMessage_ChangeFriendSync");
                //changeFriend(byteArray, size);
                break;
            case ENetworkMessage_AddFileRsp:
                NSLog(@"ENetworkMessage_AddFileRsp");
                //addFile(byteArray, size);
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
                //deleteFile(byteArray, size);
                break;
            default:
                break;
      }
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
    }@catch (NSException* e) {
        NSLog(@"%@",e);
    }
}
- (void) offlineSync:(NSData*)byteArray andSize:(int) size{
    [[SettingPwdViewController getHandler] onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"what",nil]];
}
@end
