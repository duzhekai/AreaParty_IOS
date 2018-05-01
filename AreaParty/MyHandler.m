//
//  MyHandler.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MyHandler.h"
#import "Fragment1ViewController.h"
#import "Fragment4ViewController.h"
#import "DownloadFolderFragment.h"
#import "DownloadStateFragment.h"
@implementation MyHandler{
    Fragment1ViewController* fragment01;
    Fragment4ViewController* fragment06;
    DownloadFolderFragment* downloadFolderFragment;
    DownloadStateFragment* downloadStateFragment;
}
- (instancetype)initWithFragment1:(Fragment1ViewController*) controller{
    self = [super init];
    if(self){
        fragment01 = controller;
    }
    return self;
}
- (instancetype)initWithFragment6:(Fragment4ViewController*) controller{
    self = [super init];
    if(self){
        fragment06 = controller;
    }
    return self;
}
- (instancetype)initWithDownloadFolderFragment:(DownloadFolderFragment*) controller{
    self = [super init];
    if(self){
        downloadFolderFragment = controller;
    }
    return self;
}
- (instancetype)initWithDownloadStateFragment:(DownloadStateFragment*) controller{
    self = [super init];
    if(self){
        downloadStateFragment = controller;
    }
    return self;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
            //set_username
        case 0x119:{
            [fragment01 setUserName:message];
            break;
        }
            //delFriend_order
        case 0x605:{
            [fragment06 delFriend:message];
            break;
        }
            //shareFileState
        case 0x118:{
            [[diskContentVC getPCFileHelper] shareFileState:message];
            break;
        }
            //addFriend_order
        case 0x600:{
            [fragment06 addFriend:message];
            break;
        }
            //userFriendAdd_order
        case 0x606:{
            [fragment06 friendUserAdd:message];
            break;
        }
            //showFriendFiles
        case 0x609:{
            [fragment06 showFriendFiles:message];
            break;
        }
            //addFileRequest
        case 0x613:{
            [fragment06 addFileRequest:message];
            break;
        }
            //showUnfriendFiles
        case 0x608:{
            [fragment06 showFileList:message];
            break;
        }
            //agreeDownload
        case 0x6106:{
            [downloadFolderFragment agreeDownload:message];
            break;
        }
            //shareUserLogIn_order
        case 0x603:{
            [fragment06 shareUserLogIn:message];
            break;
        }
            //friendUserLogIn_order
        case 0x602:{
            [fragment06 friendUserLogIn:message];
            break;
        }
            //netUserLogIn_order
        case 0x604:{
            //fragment06.netUserLogIn(msg);不做处理
            break;
        }
            //getUserMsgFail_order
        case 0x601:{
            //fragment06.getUserMsgFail();//暂时废弃
            break;
        }
            //userLogOut
        case 0x607:{
            [fragment06 userLogOut:message];
            break;
        }
            //shareFileSucces
        case 0x610:{
            [fragment06 shareFileSuccess:message];
            break;
        }
            //deleteShareFileSuccess
        case 0x614:{
            [fragment06 deleteFileSuccess:message];
            break;
        }
            //shareFileFail
        case 0x611:{
            [fragment06 shareFileFail];
            break;
        }
            //addChatNum
        case 0x612:{
            [fragment06 addChatNum:message];
            break;
        }
        default:
            break;
    }
}
@end
