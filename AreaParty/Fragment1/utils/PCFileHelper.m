//
//  m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
#import "ReceivedFileManagerMessageFormat.h"
#import "PCFileHelper.h"
#import "prepareDataForFragment.h"
#import "SharedflieBean.h"
#import "LoginViewController.h"
#import "AddFileMsg.pbobjc.h"
static NSString* HTTPINDEX =@"";
static BOOL isInitial = YES;
static BOOL isCopy = NO;
static BOOL isCut  = NO;
static NSMutableArray<fileBean*>* datas;
static NSString* sourcePath = @"";        // 复制、移动时的起始地址
static NSString* nowFilePath = @"";       // 当前路径
static NSMutableArray<fileBean*>* selectedFiles;
static NSMutableArray<fileBean*>* selectedFolders;
static SharedflieBean* selectedShareFile;
static NSMutableArray* reCeivedActionErrorMessageList;
@implementation PCFileHelper
- (instancetype)initWithmyHandler:(id<onHandler>) myh{
    if(self = [super init]){
        myHandler = myh;
        if(reCeivedActionErrorMessageList == nil){
        reCeivedActionErrorMessageList = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
/**
 * <summary>
 *  复制选中文件和文件夹，并发出消息
 * </summary>
 */
- (void) copyFileAndFolder{
    NSLog(@"PCFileHelper,开始复制选中的文件(夹)到%@",nowFilePath);
    [reCeivedActionErrorMessageList removeAllObjects];
    [[[NSThread alloc] initWithBlock:^{
            for (fileBean* file in selectedFiles) {
                @try {
                    ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)
                                                        [prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileOrFolderAction_copy_command param:[NSString stringWithFormat:@"%@%@%@%@%@",OrderConst_paramSourcePath,sourcePath,file.name,OrderConst_paramTargetPath,[nowFilePath substringToIndex:nowFilePath.length-1]]];

                    if(tmp.status == OrderConst_failure) {
                        [reCeivedActionErrorMessageList addObject:tmp.message];
                    } else {
                        file.isShow = NO;
                        file.isChecked = NO;
                        [datas addObject:file];
                    }
                }@catch(NSException* e) {
                    [reCeivedActionErrorMessageList addObject: e.name];
                }
            }
            for (fileBean* folder in selectedFolders) {
                @try {
                    ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)
                    [prepareDataForFragment getFileActionStateData:OrderConst_folderAction_name command:OrderConst_fileOrFolderAction_copy_command param:[NSString stringWithFormat:@"%@%@%@%@%@",OrderConst_paramSourcePath,sourcePath,folder.name,OrderConst_paramTargetPath,[nowFilePath substringToIndex:nowFilePath.length-1]]];
                    if(tmp.status == OrderConst_failure) {
                        [reCeivedActionErrorMessageList addObject:tmp.message];
                    }  else {
                        folder.isChecked = false;
                        folder.isShow = false;
                        [datas addObject:folder];
                    }
                } @catch (NSException* e) {
                    [reCeivedActionErrorMessageList addObject:e.name];
                }
            }
            // 执行成功
            if(reCeivedActionErrorMessageList.count == 0) {
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionSuccess_order],@"what",OrderConst_fileOrFolderAction_copy_command,@"actionType",nil];
                [myHandler onHandler:message];
            } else {
                // 执行失败
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionFail_order],@"what",@"部分文件复制出错，详情请查看错误日志。",@"error",OrderConst_fileOrFolderAction_copy_command,@"actionType",nil];
                [myHandler onHandler:message];
            }
            isCut = NO;
            isCopy = NO;
            isInitial = YES;
            [selectedFolders removeAllObjects];
            [selectedFiles removeAllObjects];
        }
    ]start];
}
/**
 * <summary>
 *  在当前路径下新建文件夹
 * </summary>
 * <param name="name">文件夹名称</param>
 */
- (void) addFolder:(NSString*) name {
    NSLog(@"PCFileHelper:新建文件夹%@@",name);
    [[[NSThread alloc] initWithBlock:^{
            @try {
                ReceivedActionMessageFormat* folderActionMessageReceived = (ReceivedActionMessageFormat*)
                                                                            [prepareDataForFragment getFileActionStateData:OrderConst_folderAction_name command:OrderConst_folderAction_addInComputer_command param:[NSString stringWithFormat:@"%@%@",nowFilePath,name]];
                if(folderActionMessageReceived.status == OrderConst_success) {
                    NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionSuccess_order],@"what",OrderConst_folderAction_addInComputer_command,@"actionType",nil];
                    [myHandler onHandler:message];
                } else {
                    NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionFail_order],@"what",folderActionMessageReceived.message,@"error",OrderConst_folderAction_addInComputer_command,@"actionType",nil];
                    [myHandler onHandler:message];
                }
            } @catch (NSException* e) {
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionFail_order],@"what",e.name,@"error",OrderConst_folderAction_addInComputer_command,@"actionType",nil];
                [myHandler onHandler:message];
            }
        }]start];
}
/**
 * <summary>
 *  分享当前文件到服务器
 * </summary>
 * <param name="des">文件描述信息</param>
 * <param name="file">文件</param>
 */
- (void) shareFile:(NSString*) des fileBean:(SharedflieBean*) file {
    [NSThread detachNewThreadWithBlock:^{
        AddFileReq* builder = [[AddFileReq alloc] init];
        builder.fileName = file.name;
        builder.userId = Login_userId;
        builder.fileInfo = des;
        builder.fileSize = [NSString stringWithFormat:@"%d",file.size];
        builder.fileDate = [NSString stringWithFormat:@"%ld",file.timeLong];
        builder.fileURL = file.url;
        builder.filePwd = file.pwd;
        for (int i = 0; i < file.listGroupId.count; i++) {
            [builder.fileGroupIdArray addValue:[file.listGroupId[i] intValue]];
        }
        @try {
            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_AddFileReq packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
        } @catch (NSException* e) {
            NSLog(@"%@",e.name);
        }
    }];
}
/**
 * <summary>
 *  移动选中文件和文件夹，并发出消息
 * </summary>
 */
- (void) cutFileAndFolder{
    NSLog(@"PCFileHelper,开始移动选中的文件(夹)到%@",nowFilePath);
    [reCeivedActionErrorMessageList removeAllObjects];
    [[[NSThread alloc] initWithBlock:^{
            // 依次移动选中的文件到当前路径下
            for (fileBean* file in selectedFiles) {
                @try {
                    ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)
                    [prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileOrFolderAction_cut_command param:[NSString stringWithFormat:@"%@%@%@%@%@",OrderConst_paramSourcePath,sourcePath,file.name,OrderConst_paramTargetPath,[nowFilePath substringToIndex:nowFilePath.length-1]]];
                    if(tmp.status == OrderConst_failure) {
                        [reCeivedActionErrorMessageList addObject:tmp.message];
                    } else {
                        file.isShow = NO;
                        file.isChecked = NO;
                        [datas addObject:file];
                    }
                } @catch(NSException* e) {
                    [reCeivedActionErrorMessageList addObject:e.name];
                }
            }
            for (fileBean* folder in selectedFolders) {
                @try {
                    ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)
                    [prepareDataForFragment getFileActionStateData:OrderConst_folderAction_name command:OrderConst_fileOrFolderAction_cut_command param:[NSString stringWithFormat:@"%@%@%@%@%@",OrderConst_paramSourcePath,sourcePath,folder.name,OrderConst_paramTargetPath,[nowFilePath substringToIndex:nowFilePath.length-1]]];
                    if(tmp.status == OrderConst_failure) {
                        [reCeivedActionErrorMessageList addObject:tmp.message];
                    } else {
                        folder.isChecked = NO;
                        folder.isShow = NO;
                        [datas insertObject:folder atIndex:0];
                    }
                } @catch (NSException* e) {
                    [reCeivedActionErrorMessageList addObject:e.name];
                }
            }
            // 执行成功
            if(reCeivedActionErrorMessageList.count == 0) {
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionSuccess_order],@"what",OrderConst_fileOrFolderAction_cut_command,@"actionType",nil];
                [myHandler onHandler:message];
            } else {
                // 执行失败
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionFail_order],@"what",@"部分文件移动出错，详情请查看错误日志。",@"error",OrderConst_fileOrFolderAction_cut_command,@"actionType",nil];
                [myHandler onHandler:message];
            }
        isCut = NO;
        isCopy = NO;
        isInitial = YES;
        [selectedFiles removeAllObjects];
        [selectedFolders removeAllObjects];
        
    }]start];
}
/**
 * <summary>
 *  删除选中文件和文件夹，并发出消息
 * </summary>
 */
- (void) deleteFileAndFolder {
    NSLog(@"PCFileHelper,开始删除选中的文件(夹) %lu",(selectedFolders.count + selectedFiles.count));
    [reCeivedActionErrorMessageList removeAllObjects];
    [[[NSThread alloc] initWithBlock:^{
            // 依次删除选中的文件
            for (fileBean* file in selectedFiles) {
                @try {
                    ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)
                    [prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileOrFolderAction_deleteInComputer_command param:[NSString stringWithFormat:@"%@%@",nowFilePath,file.name]];
                    if(tmp.status == OrderConst_failure) {
                        [reCeivedActionErrorMessageList addObject:tmp.message];
                    }
                } @catch(NSException* e) {
                    [reCeivedActionErrorMessageList addObject:e.name];
                }
            }
            // 依次删除选中的文件夹
            for (fileBean* folder in selectedFolders) {
                @try {
                    ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)
                    [prepareDataForFragment getFileActionStateData:OrderConst_folderAction_name command:OrderConst_fileOrFolderAction_deleteInComputer_command param:[NSString stringWithFormat:@"%@%@",nowFilePath,folder.name]];
                    if(tmp.status == OrderConst_failure) {
                        [reCeivedActionErrorMessageList addObject:tmp.message];
                    }
                } @catch (NSException* e) {
                    [reCeivedActionErrorMessageList addObject:e.name];
                }
            }
            // 执行成功
            if(reCeivedActionErrorMessageList.count == 0) {
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionSuccess_order],@"what",OrderConst_fileOrFolderAction_deleteInComputer_command,@"actionType",nil];
                [myHandler onHandler:message];
            } else {
                // 执行失败
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_actionFail_order],@"what",@"部分文件删除出错，详情请查看错误日志。",@"error",OrderConst_fileOrFolderAction_deleteInComputer_command,@"actionType",nil];
                [myHandler onHandler:message];
            }
            isCut = NO;
            isCopy = NO;
            isInitial = YES;
        [selectedFolders removeAllObjects];
        [selectedFiles removeAllObjects];
        }]start];
}
/**
 * <summary>
 *  加载指定文件夹(路径)下的文件和文件夹，并发出消息
 * </summary>
 * <param name="path">路径(如："H:\\图片管理\\")</param>
 */
- (void) loadFiles{
    NSLog(@"PCFileHelper:开始加载%@下的文件",nowFilePath);
    if(!datas){
        datas =[[NSMutableArray alloc]init];
    }
    [[[NSThread alloc] initWithBlock:^{
        [datas removeAllObjects];
        @try {
            ReceivedFileManagerMessageFormat* fileManagerMessage = (ReceivedFileManagerMessageFormat*)
            [prepareDataForFragment getFileActionStateData:OrderConst_folderAction_name command:OrderConst_folderAction_openInComputer_command param:nowFilePath];
            if(fileManagerMessage.status == OrderConst_success) {
                NodeFormat* nodeFormat = fileManagerMessage.data;
                NSMutableArray<FolderInforFormat*>* folders = nodeFormat.folders;
                NSMutableArray<FileInforFormat*>* files = nodeFormat.files;
                int i = 0;
                int folderNum = (int)folders.count;
                int fileNum = (int)files.count;
                // 添加文件夹
                for(; i < folderNum; ++i) {
                    fileBean* file = [[fileBean alloc] init];
                    file.name = folders[i].name;
                    file.subNum = folders[i].subNum;
                    file.type = FileTypeConst_folder;
                    [datas addObject:file];
                }
                // 添加文件
                for(i = 0; i < fileNum; ++i) {
                    fileBean* file = [[fileBean alloc]init];
                    file.name = files[i].name;
                    file.size = files[i].size;
                    file.lastChangeTime = files[i].lastChangeTime;
                    file.type = [FileTypeConst determineFileType:file.name];
                    [datas addObject:file];
                }
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_openFolder_order_successful],@"what",nil];
                [myHandler onHandler:message];
            } else {
                [datas removeAllObjects];
                NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_openFolder_order_fail],@"what",[NSDictionary dictionaryWithObjectsAndKeys:fileManagerMessage.message,@"error",nil],@"bundle",nil];
                [myHandler onHandler:message];
            }
        } @catch(NSException* e) {
            [datas removeAllObjects];
            NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)OrderConst_openFolder_order_fail],@"what",[NSDictionary dictionaryWithObjectsAndKeys:e.reason,@"error",nil],@"bundle",nil];
            [myHandler onHandler:message];
        }
    }]start];
}

/**
 * <summary>
 *  根据分享文件到服务器的状态决定是否向PC写入信息
 * </summary>
 * <param name="msg">状态对象</param>
 */
- (void) shareFileState:(NSMutableDictionary*) msg{
    BOOL shareState =  [msg[@"obj"] boolValue];
    NSLog(@"PCFileHelper_开始向PC写入分享文件的信息,分享状态%@",shareState?@"yes":@"no");
    [NSThread detachNewThreadWithBlock:^{
        if(shareState) {
            SharedFilePathFormat* filePath =  [[SharedFilePathFormat alloc] init];
            filePath.creatTime = [NSString stringWithFormat:@"%ld",selectedShareFile.timeLong];
            filePath.wholePath = selectedShareFile.path;
            filePath.fileName = selectedShareFile.name;
            filePath.fileSize = selectedShareFile.size;
            @try {
                ReceivedActionMessageFormat* fileActionMessageReceived = (ReceivedActionMessageFormat*)[prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileAction_share_command param:[filePath yy_modelToJSONString]];
                if(fileActionMessageReceived.status == OrderConst_success) {
                    NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
                    message[@"what"] = [NSNumber numberWithInt:OrderConst_addSharedFilePath_successful];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [myHandler onHandler:message];
                    });
                } else {
                    NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
                    message[@"what"] = [NSNumber numberWithInt:OrderConst_addSharedFilePath_fail];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [myHandler onHandler:message];
                    });
                }
            } @catch (NSException* e) {
                NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
                message[@"what"] = [NSNumber numberWithInt:OrderConst_addSharedFilePath_fail];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [myHandler onHandler:message];
                });
            }
        } else {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_addSharedFilePath_fail];
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
    }];
}
/*重命名*/

- (void) reNameFolder:(NSString*) name Path:(NSString*) targetPath{
    [reCeivedActionErrorMessageList removeAllObjects];
    [NSThread detachNewThreadWithBlock:^{
        @try {
            ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)[prepareDataForFragment getFileActionStateData:OrderConst_folderAction_name command:OrderConst_fileOrFolderAction_renameInComputer_command param:[NSString stringWithFormat:@"%@%@%@%@%@",OrderConst_paramSourcePath,nowFilePath,name,OrderConst_paramTargetPath,targetPath]];
            if(tmp.status == OrderConst_failure) {
                [reCeivedActionErrorMessageList addObject:tmp.message];
            }
        } @catch(NSException* e) {
                [reCeivedActionErrorMessageList addObject:e.name];
        }
        //
        // 执行成功
        if(reCeivedActionErrorMessageList.count == 0) {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionSuccess_order];
            message[@"actionType"] = OrderConst_fileOrFolderAction_renameInComputer_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        } else {
            // 执行失败
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
            message[@"actionType"] = OrderConst_fileOrFolderAction_renameInComputer_command;
            message[@"error"] = @"部分文件复制出错，详情请查看错误日志。";
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
    }];
}
- (void) reNameFile:(NSString*) name Path:(NSString*) targetPath{
    //Log.e("PCFileHelper", "开始复制选中的文件(夹)到" + targetPath);
    [reCeivedActionErrorMessageList removeAllObjects];
    [NSThread detachNewThreadWithBlock:^{
        @try {
            ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)[prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileOrFolderAction_renameInComputer_command param:[NSString stringWithFormat:@"%@%@%@%@%@",OrderConst_paramSourcePath,nowFilePath,name,OrderConst_paramTargetPath,targetPath]];
            if(tmp.status == OrderConst_failure) {
                [reCeivedActionErrorMessageList addObject:tmp.message];
            }
        } @catch(NSException* e) {
            [reCeivedActionErrorMessageList addObject:e.name];
        }
        //
        // 执行成功
        if(reCeivedActionErrorMessageList.count == 0) {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionSuccess_order];
            message[@"actionType"] = OrderConst_fileOrFolderAction_renameInComputer_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        } else {
            // 执行失败
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
            message[@"actionType"] = OrderConst_fileOrFolderAction_renameInComputer_command;
            message[@"error"] = @"部分文件复制出错，详情请查看错误日志。";
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
    }];
};
- (void) downloadSelectedFiles {
    NSLog(@"PCFileHelper---添加选定的文件路径到HTTP服务器%lu",(unsigned long)selectedFiles.count);
    [reCeivedActionErrorMessageList removeAllObjects];
    NSMutableArray<NSString*>* filePaths = [[NSMutableArray alloc] init];
    for(fileBean* file in selectedFiles) {
        [filePaths addObject:[NSString stringWithFormat:@"%@%@",nowFilePath,file.name]];
        NSLog(@"PCFileHelper---添加路径%@%@",nowFilePath,file.name);
    }
    [NSThread detachNewThreadWithBlock:^{
        @try {
            ReceivedAddPathToHttpMessageFormat* messageFormat = (ReceivedAddPathToHttpMessageFormat*)[prepareDataForFragment getAddPathToHttpState:filePaths];
            if(messageFormat.status == OrderConst_failure) {
                NSLog(@"PCFileHelper--添加路径到PC服务器出错");
                NSString* errorFiles = @"---";
                reCeivedActionErrorMessageList = messageFormat.data;
                // 过滤错误的文件
                for(NSString* errorPath in reCeivedActionErrorMessageList) {
                    for(int i = 0; i < selectedFiles.count; ++i) {
                        if([errorPath isEqualToString:[NSString stringWithFormat:@"%@%@",nowFilePath,selectedFiles[i].name]]) {
                            errorFiles = [[errorFiles stringByAppendingString:selectedFiles[i].name] stringByAppendingString:@"---"];
                            [selectedFiles removeObjectAtIndex:i];
                            break;
                        }
                    }
                }
                // 添加剩余文件到下载中
                for(fileBean* file in selectedFiles) {
                    DownloadFileModel* downloadFile = [[DownloadFileModel alloc] init];
                    downloadFile.createTime = [[NSDate date] timeIntervalSince1970]*1000;
                    downloadFile.name = file.name;
                    downloadFile.url = [NSString stringWithFormat:@"http://%@:%d/%@",[MyConnector sharedInstance].IP,IPAddressConst_LOCALHTTPPORT_Y,[file.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
                    //这里第一个参数是tag，代表下载任务的唯一标识，传任意字符串都行，需要保证唯一,我这里用url作为了tag
                    [[MCDownloadManager defaultInstance] downloadFileWithURL:downloadFile.url progress:nil destination:nil success:nil failure:nil];
                }
                
                if(selectedFiles.count == 0)
                    errorFiles = @"所有文件";
                NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
                message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
                message[@"actionType"] = OrderConst_addPathToHttp_command;
                message[@"error"] = [NSString stringWithFormat:@"%@保存失败",errorFiles];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [myHandler onHandler:message];
                });
            } else {
                for(fileBean* file in selectedFiles) {
                    NSString* url = [NSString stringWithFormat:@"http://%@:%d/%@",[MyConnector sharedInstance].IP,IPAddressConst_LOCALHTTPPORT_Y,[file.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
                    DownloadFileModel* downloadFile = [[DownloadFileModel alloc] init];
                    downloadFile.createTime = [[NSDate date] timeIntervalSince1970]*1000;
                    downloadFile.name = file.name;
                    downloadFile.url = url;
                    NSLog(@"PCFileHelper--添加路径正确%@",url);
                    [[MCDownloadManager defaultInstance] downloadFileWithURL:downloadFile.url progress:nil destination:nil success:nil failure:nil];
                }
                NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
                message[@"what"] = [NSNumber numberWithInt:OrderConst_actionSuccess_order];
                message[@"actionType"] = OrderConst_addPathToHttp_command;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [myHandler onHandler:message];
                });
            }
        } @catch (NSException* e) {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
            message[@"actionType"] = OrderConst_addPathToHttp_command;
            message[@"error"] = e.name;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
        
        [selectedFiles removeAllObjects];
        [selectedFolders removeAllObjects];
        for(fileBean* file in datas) {
            file.isChecked = NO;
            file.isShow = NO;
        }
    }];
}
- (void) addToVideoList:(fileBean*) file Type:(NSString*) type{
    NSString* path = [NSString stringWithFormat:@"%@%@%@",type,nowFilePath,file.name];
    NSLog(@"PCFileHelper:%@",path);
    [NSThread detachNewThreadWithBlock:^{
        int status = [(NSNumber*)[prepareDataForFragment addPathToList:path] intValue];
        if (status == OrderConst_success){
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionSuccess_order];
            message[@"actionType"] =OrderConst_folderAction_addToList_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }else {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
            message[@"actionType"] =OrderConst_folderAction_addToList_command;
            message[@"error"] =  @"添加到媒体库出错，详情请查看错误日志。";
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
    }];
    
}
/**
 * <summary>
 *  删除选中文件和文件夹，并发出消息
 * </summary>
 */
- (void) deleteFile:(NSArray<NSString*>*) paths{
    NSLog(@"PCFileHelper,开始删除选中的文件(夹)%lu",(unsigned long)paths.count);
    [reCeivedActionErrorMessageList removeAllObjects];
    [NSThread detachNewThreadWithBlock:^{
        // 依次删除选中的文件
        for (NSString* path in paths) {
            @try {
                ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)[prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileOrFolderAction_deleteInComputer_command param:path];
                if(tmp.status == OrderConst_failure) {
                    [reCeivedActionErrorMessageList addObject:tmp.message];
                }
            } @catch(NSException* e) {
                [reCeivedActionErrorMessageList addObject:e.name];
            }
        }
        // 执行成功
        if(reCeivedActionErrorMessageList.count == 0) {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionSuccess_order];
            message[@"actionType"] = OrderConst_fileOrFolderAction_deleteInComputer_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        } else {
            // 执行失败
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
            message[@"error"] = @"部分文件删除出错，详情请查看错误日志。";
            message[@"actionType"] = OrderConst_fileOrFolderAction_deleteInComputer_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
    }
    ];
}
/**
 * <summary>
 *  复制选中文件和文件夹，并发出消息
 * </summary>
 */
- (void) copyFile:(NSMutableArray<NSString*>*) paths TargetPath:(NSString*) targetPath{
    NSLog(@"PCFileHelper,开始复制选中的文件(夹)到%@",targetPath);
    [reCeivedActionErrorMessageList removeAllObjects];
    [NSThread detachNewThreadWithBlock:^{
        for (NSString*  path in paths) {
            @try {
                ReceivedActionMessageFormat* tmp = (ReceivedActionMessageFormat*)[prepareDataForFragment getFileActionStateData:OrderConst_fileAction_name command:OrderConst_fileOrFolderAction_copy_command param:[NSString stringWithFormat:@"%@%@%@%@",OrderConst_paramSourcePath,path,OrderConst_paramTargetPath,[targetPath substringToIndex:targetPath.length-1]]];
                if(tmp.status == OrderConst_failure) {
                    [reCeivedActionErrorMessageList addObject:tmp.message];
                }
            } @catch(NSException* e) {
                [reCeivedActionErrorMessageList addObject:e.name];
            }
        }
        // 执行成功
        if(reCeivedActionErrorMessageList.count == 0) {
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionSuccess_order];
            message[@"actionType"] = OrderConst_fileOrFolderAction_copy_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        } else {
            // 执行失败
            // 执行失败
            NSMutableDictionary* message = [[NSMutableDictionary alloc] init];
            message[@"what"] = [NSNumber numberWithInt:OrderConst_actionFail_order];
            message[@"error"] = @"部分文件复制出错，详情请查看错误日志。";
            message[@"actionType"] = OrderConst_fileOrFolderAction_copy_command;
            dispatch_async(dispatch_get_main_queue(), ^{
                [myHandler onHandler:message];
            });
        }
    }];
}


+ (NSString*)getNowFilePath {
    return nowFilePath;
}

+ (void) setNowFilePath:(NSString*) nowFilePath1{
    nowFilePath = nowFilePath1;
}
+ (BOOL) isInitial {
    return isInitial;
}

+ (void) setIsInitial:(BOOL)isInitial1{
    isInitial = isInitial1;
}

+ (BOOL) isCopy {
    return isCopy;
}

+ (void) setIsCopy:(BOOL) isCopy1{
    isCopy = isCopy1;
}

+ (BOOL) isCut {
    return isCut;
}

+ (void) setIsCut:(BOOL) isCut1 {
    isCut = isCut1;
}

+ (NSMutableArray<fileBean*>*) getDatas {
    return datas;
}

+ (void) clearDatas {
    [datas removeAllObjects];
}

+ (void) setDatas:(NSMutableArray<fileBean*>*) datas1{
    datas = datas1;
}

+ (NSString*)getSourcePath {
    return sourcePath;
}

+ (void) setSourcePath:(NSString*) sourcePath1{
    sourcePath = sourcePath1;
}

+ (NSMutableArray<NSString*>*) getReCeivedActionErrorMessageList {
    return reCeivedActionErrorMessageList;
}

+ (void) setReCeivedActionErrorMessageList:(NSMutableArray<NSString*>*) reCeivedActionErrorMessageList1 {
    reCeivedActionErrorMessageList = reCeivedActionErrorMessageList1;
}

+ (NSMutableArray<fileBean*>*) getSelectedFiles {
    if(selectedFiles == nil){
        selectedFiles = [[NSMutableArray alloc] init];
    }
    return selectedFiles;
}

+ (void) setSelectedFiles:(NSMutableArray<fileBean*>*) selectedFiles1 {
    selectedFiles = selectedFiles1;
}

+ (NSMutableArray<fileBean*>*) getSelectedFolders {
    if(selectedFolders == nil){
        selectedFolders = [[NSMutableArray alloc] init];
    }
    return selectedFolders;
}

+ (void) setSelectedFolders:(NSMutableArray<fileBean*>*) selectedFolders1 {
    selectedFolders = selectedFolders1;
}

+ (SharedflieBean*) getSelectedShareFile {
    return selectedShareFile;
}

+ (void) setSelectedShareFile:(SharedflieBean*)selectedShareFile1{
    selectedShareFile = selectedShareFile1;
}
@end
