//
//  prepareDataForFragment.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "prepareDataForFragment.h"

@implementation prepareDataForFragment
/**
 * <summary>
 *  发送磁盘操作指令并获取执行状态
 * </summary>
 * <param name="name">操作名称</param>
 * <param name="command">操作</param>
 * <param name="param">参数</param>
 * <returns>执行结果</returns>
 */
+(NSObject*)getDiskActionStateData:(NSString*)name command:(NSString*)command param:(NSString*) param{
    NSObject* message = [[NSObject alloc]init];
    RequestFormat* request = [[RequestFormat alloc]init];
    request.name = name;
    request.command = command;
    request.param = param;
    NSString* requestString = [request yy_modelToJSONString];
    NSLog(@"IPGET:loadDisksPre");
    if([command isEqualToString:OrderConst_diskAction_get_command]){
        NSString* msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestString];
        NSLog(@"IPGET:%@", msgReceived);
        if(![msgReceived isEqualToString:@""]) {
            message = [ReceivedDiskListFormat yy_modelWithJSON:msgReceived];
            }
    }
    NSLog(@"page04Fragment:disk返回");
    return message;
}
/**
 * <summary>
 *  发送文件或文件夹操作指令并获取执行状态
 * </summary>
 * <param name="name">操作名称</param>
 * <param name="command">操作</param>
 * <param name="param">参数</param>
 * <returns>执行结果</returns>
 */
+ (NSObject*) getFileActionStateData:(NSString*)name command:(NSString*) command param:(NSString*) param{
    NSObject* message = [[NSObject alloc] init];
    
    RequestFormat* request = [[RequestFormat alloc]init];
    request.name = name;
    request.command = command;
    request.param = param;
    NSString* requestString = [request yy_modelToJSONString];
    NSArray * a = [NSArray arrayWithObjects:OrderConst_fileAction_share_command,OrderConst_folderAction_addInComputer_command,OrderConst_fileAction_openInComputer_command,OrderConst_fileOrFolderAction_deleteInComputer_command,OrderConst_fileOrFolderAction_renameInComputer_command,OrderConst_fileOrFolderAction_copy_command,OrderConst_fileOrFolderAction_cut_command,OrderConst_folderAction_openInComputer_command,OrderConst_diskAction_get_command, nil];
    switch ([a indexOfObject:command]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6: {
            NSString* msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestString];
            NSLog(@"PCAction%@:%@",command,msgReceived);
            if(![msgReceived isEqualToString:@""]) {
                message = [ReceivedActionMessageFormat yy_modelWithJSON:msgReceived];
            }
        }
            break;
        case 7:{
            message =  [self getFolerInforArray:request];
        }
            break;
        case 8:{
            NSString* msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestString];
            if(![msgReceived isEqualToString:@""]) {
                message = [ReceivedDiskListFormat yy_modelWithJSON:msgReceived];
            }
        }
            break;
    }
    return message;
}
/**
 * <summary>
 *  发送请求并获取指定文件夹下所有文件组、文件夹组，并组合起来，形成新的节点信息
 * </summary>
 * <param name="request">请求(类)</param>
 * <returns>重组并封装好的节点信息组</returns>
 */
+ (ReceivedFileManagerMessageFormat*) getFolerInforArray:(RequestFormat*) request{
    NSMutableArray<ReceivedFileManagerMessageFormat*>* receivedFileInforArray = [[NSMutableArray alloc]init];
    NSString* requestMsg = [request yy_modelToJSONString];
    
    ReceivedFileManagerMessageFormat* messageTemp =  [[ReceivedFileManagerMessageFormat alloc] init];
    NSString* msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestMsg];
    @try {
        messageTemp = [ReceivedFileManagerMessageFormat yy_modelWithJSON:msgReceived];
    } @catch (NSException* e) {}
    [receivedFileInforArray addObject:messageTemp];
    
    BOOL signal = (messageTemp.status == OrderConst_success
                      && [messageTemp.message isEqualToString:OrderConst_folderAction_openInComputer_more_message]);
    while(signal) {
        request.param = OrderConst_folderAction_openInComputer_more_param;
        requestMsg = [request yy_modelToJSONString];
        msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestMsg];
        @try {
            messageTemp = [ReceivedFileManagerMessageFormat yy_modelWithJSON:msgReceived];
        } @catch (NSException* e) {}
        [receivedFileInforArray addObject:messageTemp];
        signal = (messageTemp.status == OrderConst_success
                  && [messageTemp.message isEqualToString:OrderConst_folderAction_openInComputer_more_message]);
    }
    
    ReceivedFileManagerMessageFormat* allFileInfor = [[ReceivedFileManagerMessageFormat alloc] init];
    NSMutableArray<FileInforFormat*>* allFiles = [[NSMutableArray alloc]init];
    NSMutableArray<FolderInforFormat*>* allFolders = [[NSMutableArray alloc]init];
    for (ReceivedFileManagerMessageFormat* temp in receivedFileInforArray) {
        [allFolders addObjectsFromArray:temp.data.folders];
        [allFiles addObjectsFromArray:temp.data.files];
    }
    NodeFormat* nodeTemp = [[NodeFormat alloc] init];
    nodeTemp.path = messageTemp.data.path;
    nodeTemp.folders = allFolders;
    nodeTemp.files = allFiles;
    int status = OrderConst_success;
    NSString* message = nil;
    if(allFiles.count == 0 && allFolders.count == 0) {
        status = messageTemp.status;
        message = messageTemp.message;
    }
    allFileInfor.status = status;;
    allFileInfor.data = nodeTemp;
    allFileInfor.message = message;
    
    return allFileInfor;
}
+ (BOOL) closeRDP{
    BOOL state = false;
    NSString* TVIp = [MyUIApplication getSelectedTVIP].ip;
    if(![TVIp isEqualToString:@""]) {
        TVCommandItem* tvCommandItem = [CommandUtil closeRdp];
        NSString* requestStr = [tvCommandItem yy_modelToJSONString];
        state = [[MyConnector sharedInstance] sendMsgToIP:TVIp Port:IPAddressConst_TVRECEIVEPORT_MM Msg:requestStr];
    }
    
    return state;
}
+ (BOOL) getDlnaCastState_File:(FileItemForMedia*) file Type:(NSString*) fileType{
    BOOL state = NO;
    NSString* ip = [MyUIApplication getIPStr];
    NSString* TVIp = [MyUIApplication getSelectedTVIP].ip;
    if(!([ip isEqualToString:@""]||ip == nil) && !([TVIp isEqualToString:@""] || TVIp ==nil) ){
        NSString* secondcommand = [NSString stringWithFormat:@"http://%@:%d/%@",ip,IPAddressConst_DLNAPHONEHTTPPORT_B,[file.mFilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        NSLog(@"test->secondcommand:%@",file.mFilePath);
        NSString* fourthcommand = file.mFileName;
        NSString* fifthcommand  = fileType;
        TVCommandItem* tvCommandItem = [CommandUtil createPlayUrlFileOnTVCommand_File:secondcommand FileName:fourthcommand Type:fifthcommand];
        NSString* requestStr = [tvCommandItem yy_modelToJSONString];
        state = [[MyConnector sharedInstance] sendMsgToIP:TVIp Port:IPAddressConst_TVRECEIVEPORT_MM Msg:requestStr];
    }
    
    return state;
}
+ (BOOL) getDlnaCastState_List:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) fileType{
    BOOL state = NO;
    if (setList!=nil && setList.count>0){
        NSString* ip = [MyUIApplication getIPStr];
        NSString* TVIp = [MyUIApplication getSelectedTVIP].ip;
        NSMutableArray<NSString*>* urls = [[NSMutableArray alloc] init];
        if(!([ip isEqualToString:@""]) && !([TVIp isEqualToString:@""])) {
            for (FileItemForMedia* file in setList){
                NSString* secondcommand = [NSString stringWithFormat:@"http://%@:%d/%@",ip,IPAddressConst_DLNAPHONEHTTPPORT_B,[file.mFilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
                NSLog(@"test->secondcommand***%@",file.mFilePath);
                [urls addObject:secondcommand];
            }
            NSString* fifthcommand  = fileType;
            TVCommandItem* tvCommandItem = [CommandUtil createPlayUrlFileOnTVCommand_List:urls FileName:@"" Type:fifthcommand];
            NSString* requestStr = [tvCommandItem yy_modelToJSONString];
            state = [[MyConnector sharedInstance] sendMsgToIP:TVIp Port:IPAddressConst_TVRECEIVEPORT_MM Msg:requestStr];
        }
    }
    return state;
}
+ (BOOL) getDlnaCastState_Folder:(NSString*) folderName Type:(NSString*) fileType{
    BOOL state = NO;
    NSString* ip = [MyUIApplication getIPStr];
    NSString* TVIp = [MyUIApplication getSelectedTVIP].ip;
    NSMutableArray<NSString*>* urls = [[NSMutableArray alloc] init];
    if(!([ip isEqualToString:@""]) && !([TVIp isEqualToString:@""])) {
        NSMutableArray<FileItemForMedia*>* fileList = [[NSMutableArray alloc] init];
        if ([fileType isEqualToString:@"image"]){
            [fileList addObjectsFromArray:[ContentDataControl getFileItemListByFolder:photo Folder:folderName]];
        }else if ([fileType isEqualToString:@"audio"]){
            [fileList addObjectsFromArray:[ContentDataControl getFileItemListByFolder:music Folder:folderName]];
        }
        for (FileItemForMedia* file in fileList){
            NSString* secondcommand = [NSString stringWithFormat:@"http://%@:%d/%@",ip,IPAddressConst_DLNAPHONEHTTPPORT_B,[file.mFilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
            NSLog(@"test->secondcommand***%@",file.mFilePath);
            [urls addObject:secondcommand];
        }
        NSString* fifthcommand  = fileType;
        TVCommandItem* tvCommandItem = [CommandUtil createPlayUrlFileOnTVCommand_List:urls FileName:@"" Type:fifthcommand];
        NSString* requestStr = [tvCommandItem yy_modelToJSONString];
        state = [[MyConnector sharedInstance] sendMsgToIP:TVIp Port:IPAddressConst_TVRECEIVEPORT_MM Msg:requestStr];
    }
    return state;
}
+ (BOOL) getDlnaCastState_bgm:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) fileType{
    BOOL state = NO;
    if (setList!=nil && setList.count>0){
        NSString* ip = [MyUIApplication getIPStr];
        NSString* TVIp = [MyUIApplication getSelectedTVIP].ip;
        NSMutableArray<NSString*>* urls = [[NSMutableArray alloc] init];
        if(!([ip isEqualToString:@""]) && !([TVIp isEqualToString:@""])) {
            for (FileItemForMedia* file in setList){
                NSString* secondcommand = [NSString stringWithFormat:@"http://%@:%d/%@",ip,IPAddressConst_DLNAPHONEHTTPPORT_B,[file.mFilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
                NSLog(@"test->secondcommand***%@",file.mFilePath);
                [urls addObject:secondcommand];
            }
            NSString* fifthcommand  = fileType;
            TVCommandItem* tvCommandItem = [CommandUtil createPlayBGMOnTVCommand:urls FileName:@"" Type:fifthcommand];
            NSString* requestStr = [tvCommandItem yy_modelToJSONString];
            state = [[MyConnector sharedInstance] sendMsgToIP:TVIp Port:IPAddressConst_TVRECEIVEPORT_MM Msg:requestStr];
        }
    }
    return state;
}
@end
