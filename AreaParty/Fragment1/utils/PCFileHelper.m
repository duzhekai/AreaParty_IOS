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
