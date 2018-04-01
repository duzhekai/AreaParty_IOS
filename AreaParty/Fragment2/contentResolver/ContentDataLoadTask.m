//
//  ContentDataLoadTask.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ContentDataLoadTask.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FileItemForMedia.h"
@implementation ContentDataLoadTask{
    file_sys_type type;
}
- (void) onPreExecute{
    if (_mOnContentDataLoadListener != nil) {
        [_mOnContentDataLoadListener onStartLoad];
    }
}
- (void)onPostExecute{
    if (_mOnContentDataLoadListener != nil) {
        [_mOnContentDataLoadListener onFinishLoad];
    }
}
- (void)main{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPreExecute];
    });
    // do in background
    switch (type){
//        case video:ContentDataControl.addFileListByType(type, getAllVideo());break;
//        case music:ContentDataControl.addFileListByType(type, getAllMusic());break;
//        case photo:ContentDataControl.addFileListByType(type, getAllPhoto());break;
    }
    // end
    dispatch_async(dispatch_get_main_queue(), ^{
        [self onPostExecute];
    });
}
- (NSMutableArray<FileItemForMedia*>*) getAllVideo{
    NSMutableArray<FileItemForMedia*>* videos =[[NSMutableArray alloc] init];
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
        // 读取条件
    MPMediaPropertyPredicate *albumNamePredicate =[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
    [everything addFilterPredicate:albumNamePredicate];
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        NSString *fileid = [song valueForProperty:MPMediaItemPropertyPersistentID];
        NSString *filename = [song valueForProperty: MPMediaPlaylistPropertyName];
        NSString *filePath = [song valueForProperty:MPMediaItemPropertyAssetURL];
        FileItemForMedia* fileItem = [[FileItemForMedia alloc] initWithmFileId:fileid mFilePath:filePath mFileName:filename];
        [videos addObject:fileItem];
    }
    return videos;
}

@end
