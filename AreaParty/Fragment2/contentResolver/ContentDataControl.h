//
//  ContentDataControl.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemType.h"
#import "FileItemForMedia.h"
@interface ContentDataControl : NSObject
+ (void) addFileListByType:(File_Sys_Type) type List:(NSMutableArray<FileItemForMedia*>*) fileItemList;
+ (NSMutableArray<FileItemForMedia*>*) getFileItemListByFolder:(File_Sys_Type) type Folder:(NSString*)folder;
+ (NSArray<NSString*>*) getFolder:(File_Sys_Type) fileSystemType;
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>*)getmPhotoFolder;
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>*)getmVideoFolder;
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>*)getmMusicFolder;
+ (void) addPCDownloadFileListByType:(File_Sys_Type) type List:(NSMutableArray<FileItemForMedia*>*) fileItemList;
@end
