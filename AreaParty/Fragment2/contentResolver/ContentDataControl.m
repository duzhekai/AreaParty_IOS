//
//  ContentDataControl.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ContentDataControl.h"
#import "FileSystemType.h"
#import "FileItemForMedia.h"
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
//+ (void) addFileListByType:(file_sys_type) type List:(NSMutableArray<FileItem*>*) fileItemList {
//    if (type == nil || fileItemList == nil) {
//        return;
//    }
//    switch (type){
//        case video:
//            for (FileItem* f in fileItemList){
//                NSString* path = f.getmFilePath();
//                path = path.substring(0,path.lastIndexOf("/"));
//                path = path.substring(path.lastIndexOf("/")+1);
//                ArrayList<FileItem> fileItems1 = mVideoFolder.get(path);
//                if (fileItems1 == null){
//                    fileItems1 = new ArrayList<>();
//                    mVideoFolder.put(path, fileItems1);
//                }
//                fileItems1.add(f);
//            }
//            break;
//        case music:
//            for (FileItem f : fileItemList){
//                String path = f.getmFilePath();
//                path = path.substring(0,path.lastIndexOf("/"));
//                path = path.substring(path.lastIndexOf("/")+1);
//                ArrayList<FileItem> fileItems1 = mMusicFolder.get(path);
//                if (fileItems1 == null){
//                    fileItems1 = new ArrayList<>();
//                    mMusicFolder.put(path, fileItems1);
//                }
//                fileItems1.add(f);
//            }
//            break;
//        case photo:
//            for (FileItem f : fileItemList){
//                String path = f.getmFilePath();
//                path = path.substring(0,path.lastIndexOf("/"));
//                path = path.substring(path.lastIndexOf("/")+1);
//                ArrayList<FileItem> fileItems1 = mPhotoFolder.get(path);
//                if (fileItems1 == null){
//                    fileItems1 = new ArrayList<>();
//                    mPhotoFolder.put(path, fileItems1);
//                }
//                fileItems1.add(f);
//            }
//            break;
//    }
//}
@end
