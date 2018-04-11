//
//  prepareDataForFragment.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestFormat.h"
#import "YYModel.h"
#import "OrderConst.h"
#import "MyConnector.h"
#import "ReceivedDiskListFormat.h"
#import "MyConnector.h"
#import "ReceivedFileManagerMessageFormat.h"
#import "NodeFormat.h"
#import "ContentDataControl.h"
#import "FileItemForMedia.h"
@interface prepareDataForFragment : NSObject
+(NSObject*)getDiskActionStateData:(NSString*)name command:(NSString*)command param:(NSString*) param;
+ (NSObject*) getFileActionStateData:(NSString*)name command:(NSString*) command param:(NSString*) param;
+ (BOOL) closeRDP;
+ (BOOL) getDlnaCastState_File:(FileItemForMedia*) file Type:(NSString*) fileType;
+ (BOOL) getDlnaCastState_List:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) fileType;
+ (BOOL) getDlnaCastState_Folder:(NSString*) folderName Type:(NSString*) fileType;
+ (BOOL) getDlnaCastState_bgm:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) fileType;
@end
