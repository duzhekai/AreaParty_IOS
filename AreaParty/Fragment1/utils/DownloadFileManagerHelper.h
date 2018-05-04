//
//  DownloadFileManagerHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileItemForMedia.h"
#import "MyUIApplication.h"
#import "prepareDataForFragment.h"
@interface DownloadFileManagerHelper : NSObject
+ (void) setcontext:(UIViewController*) context1;
+ (void) dlnaCast_File:(FileItemForMedia*) file Type:(NSString*) type;
+ (void) dlnaCast_List:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) type;
+ (void) dlnaCast_Folder:(NSString*)foldername Type:(NSString*) type;
+ (void) dlnaCast_bgm:(NSMutableArray<FileItemForMedia*>*) setList Type:(NSString*) type Asbgm:(BOOL) asbgm;
+ (void) dlnaCastDownloadedFile:(downloadedFileBean*)file;
@end
