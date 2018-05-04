//
//  PCFileHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "onHandler.h"
#import "fileBean.h"
#import "SharedflieBean.h"
#import "FileTypeConst.h"
#import "SharedFilePathFormat.h"
#import "ReceivedAddPathToHttpMessageFormat.h"
#import "MCDownloadManager.h"
#import "DownloadFileModel.h"
@interface PCFileHelper : NSObject{
    id<onHandler> myHandler;
}
+ (NSString*)getNowFilePath;

+ (void) setNowFilePath:(NSString*) nowFilePath1;

- (instancetype)initWithmyHandler:(id<onHandler>) myh;

- (void) loadFiles;

+ (BOOL) isInitial;

+ (void) setIsInitial:(BOOL)isInitial1;

+ (BOOL) isCopy;

+ (void) setIsCopy:(BOOL) isCopy1;

+ (BOOL) isCut;

+ (void) setIsCut:(BOOL) isCut1;

+ (NSMutableArray<fileBean*>*) getDatas;

+ (void) clearDatas;

+ (void) setDatas:(NSMutableArray<fileBean*>*) datas1;

+ (NSString*)getSourcePath;

+ (void) setSourcePath:(NSString*) sourcePath1;

+ (NSMutableArray<NSString*>*) getReCeivedActionErrorMessageList;

+ (void) setReCeivedActionErrorMessageList:(NSMutableArray<NSString*>*) reCeivedActionErrorMessageList1;

+ (NSMutableArray<fileBean*>*) getSelectedFiles;

+ (void) setSelectedFiles:(NSMutableArray<fileBean*>*) selectedFiles1;

+ (NSMutableArray<fileBean*>*) getSelectedFolders;

+ (void) setSelectedFolders:(NSMutableArray<fileBean*>*) selectedFolders1;

+ (SharedflieBean*) getSelectedShareFile;

+ (void) setSelectedShareFile:(SharedflieBean*)selectedShareFile1;

- (void) copyFileAndFolder;

- (void) cutFileAndFolder;

- (void) addFolder:(NSString*) name;

- (void) deleteFileAndFolder;

- (void) shareFile:(NSString*) des fileBean:(SharedflieBean*) file;

- (void) shareFileState:(NSMutableDictionary*) msg;

- (void) reNameFolder:(NSString*) name Path:(NSString*) targetPath;

- (void) reNameFile:(NSString*) name Path:(NSString*) targetPath;

- (void) downloadSelectedFiles;
@end
