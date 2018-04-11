//
//  ContentDataControl.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ContentDataControl.h"

static NSMutableDictionary<NSNumber*, NSMutableArray<FileItemForMedia*>*>* mAllFileItem; //number is FileSystemType
static NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>* mVideoFolder;
static NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>* mMusicFolder;
static NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>* mPhotoFolder;
@implementation ContentDataControl
+ (void)load{
    mAllFileItem = [[NSMutableDictionary alloc] init];
    mVideoFolder = [[NSMutableDictionary alloc] init];
    mMusicFolder = [[NSMutableDictionary alloc] init];
    mPhotoFolder = [[NSMutableDictionary alloc] init];
}
+ (void) addFileListByType:(File_Sys_Type) type List:(NSMutableArray<FileItemForMedia*>*) fileItemList {
    if (fileItemList == nil) {
        return;
    }
    switch (type){
        case video:{
            for (FileItemForMedia* f in fileItemList){
                NSString* path = @"Videos";
                NSMutableArray<FileItemForMedia*>* fileItems1 = [mVideoFolder objectForKey:path];
                if (fileItems1 == nil){
                    fileItems1 =  [[NSMutableArray alloc] init];
                    [mVideoFolder setObject:fileItems1 forKey:path];
                }
                [fileItems1 addObject:f];
            }
            break;
        }
        case music:{
            for (FileItemForMedia* f in fileItemList){
                NSString* path = @"Musics";
                NSMutableArray<FileItemForMedia*>* fileItems1 = [mMusicFolder objectForKey:path];
                if (fileItems1 == nil){
                    fileItems1 =  [[NSMutableArray alloc] init];
                    [mMusicFolder setObject:fileItems1 forKey:path];
                }
                [fileItems1 addObject:f];
            }
            break;
        }
        case photo:{
            for (FileItemForMedia* f in fileItemList){
                NSString* path = @"Photos";
                NSMutableArray<FileItemForMedia*>* fileItems1 = [mPhotoFolder objectForKey:path];
                if (fileItems1 == nil){
                    fileItems1 =  [[NSMutableArray alloc] init];
                    [mPhotoFolder setObject:fileItems1 forKey:path];
                }
                [fileItems1 addObject:f];
            }
            break;
        }
    }
}
+ (NSArray<NSString*>*) getFolder:(File_Sys_Type) fileSystemType{
    switch (fileSystemType){
        case video:return [mVideoFolder allKeys];
        case music:return [mMusicFolder allKeys];
        case photo:return [mPhotoFolder allKeys];
        default: return [[NSArray alloc] init];
    }
    
}
+ (NSMutableArray<FileItemForMedia*>*) getFileItemListByFolder:(File_Sys_Type) type Folder:(NSString*)folder{
    switch (type){
        case video:return [mVideoFolder objectForKey:folder];
        case music:return [mMusicFolder objectForKey:folder];
        case photo:return [mPhotoFolder objectForKey:folder];
        default: return nil;
    }
}
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>*)getmPhotoFolder{
    return mPhotoFolder;
}
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>*)getmVideoFolder{
    return mVideoFolder;
}
+ (NSMutableDictionary<NSString*, NSMutableArray<FileItemForMedia*>*>*)getmMusicFolder{
    return mMusicFolder;
}
@end
