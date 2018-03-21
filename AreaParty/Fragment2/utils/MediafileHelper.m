//
//  MediafileHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/18.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MediafileHelper.h"
static NSMutableArray<MediaItem*>* recentAudios ; // 最近播放的音频文件
static NSMutableArray<MediaItem*>* recentVideos; // 最近播放的视频文件
static NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>* audioSets;  // 音频集
static NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>* imageSets;  // 图片集
// 进入相应媒体库时使用
static NSString* mediaType = @"";    // VIDEO, AUDIO, IMAGE
static NSMutableArray<NSString*>* startPathList;
static NSString* currentPath = @"";  // 当前路径
static NSMutableArray<MediaItem*>* mediaFiles;   // 当前路径下的媒体文件
static NSMutableArray<MediaItem*>* mediaFolders; // 当前路径下的文件夹
@implementation MediafileHelper

/**
 * <summary>
 *  清空最近播放文件和播放列表信息
 *  PC设备切换时调用
 * </summary>
 */
+ (void) resetTotalInfors{
    [[self getrecentAudios] removeAllObjects];
    [[self getrecentVideos] removeAllObjects];
    [[self getaudioSets] removeAllObjects];
    [[self getimageSets] removeAllObjects];
}
/**
 * <summary>
 *  清空媒体库文件信息
 *  从视频库、音频库或图片库返回媒体库页面(tab02)时调用
 * </summary>
 */
+ (void) resetMediaInfors{
    mediaType = @"";
    currentPath = @"";
    [[self getmediaFiles] removeAllObjects];
    [[self getmediaFolders] removeAllObjects];
    [[self getstartPathList] removeAllObjects];
}
/**
 * <summary>
 *  启动线程从pc下载图片集、音频集
 *  <param name="handler">消息传递句柄</param>
 * </summary>
 */
+ (void)loadMediaSets:(id<onHandler>) handler{
    [audioSets removeAllObjects];
    [imageSets removeAllObjects];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_audioAction_name commandType:OrderConst_mediaAction_getSets_command Handler:handler] start];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_imageAction_name commandType:OrderConst_mediaAction_getSets_command Handler:handler] start];
}
/**
 * <summary>
 *  启动线程从pc下载最近播放文件(视频和音频)
 *  每次初始化或PC切换时调用
 *  <param name="handler">消息传递句柄</param>
 * </summary>
 */
+ (void) loadRecentMediaFiles:(id<onHandler>) handler {
    [recentAudios removeAllObjects];
    [recentVideos removeAllObjects];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_audioAction_name commandType:OrderConst_appMediaAction_getRecent_command Handler:handler]start];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_videoAction_name commandType:OrderConst_appMediaAction_getRecent_command Handler:handler]start];
}
+ (void)setMediaSets:(NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>*) tempSets typename:(NSString*) typeName{
    if([typeName isEqualToString:OrderConst_audioAction_name]) {
        [[self getaudioSets] removeAllObjects];
        [audioSets setDictionary:tempSets];
    } else if([typeName isEqualToString:OrderConst_imageAction_name]) {
        [[self getimageSets] removeAllObjects];
        [imageSets setDictionary:tempSets];
    }
}
+ (void) setRecentFiles:(NSArray<MediaItem*>*)tempFiles filetype:(NSString*)fileType{
    if([fileType isEqualToString:OrderConst_audioAction_name]){
        [[self getrecentAudios] removeAllObjects];
        [recentAudios addObjectsFromArray:tempFiles];
    }
    else if([fileType isEqualToString:OrderConst_videoAction_name]) {
        [[self getrecentVideos] removeAllObjects];
        [recentVideos addObjectsFromArray:tempFiles];
    }
}
+ (void) setMediaFiles:(NSArray<MediaItem*>*)tempMediaFiles folders:(NSArray<MediaItem*>*) folders {
    [[self getmediaFiles] removeAllObjects];
    [[self getmediaFolders] removeAllObjects];
    [mediaFiles addObjectsFromArray:tempMediaFiles];
    [mediaFolders addObjectsFromArray:folders];
    if([self getstartPathList].count == 0) {
        if(folders.count > 0) {
            for(int i = 0; i < folders.count; ++i) {
                NSString* startPath = [folders objectAtIndex:i].pathName;
                startPath = [startPath substringWithRange:NSMakeRange(0, startPath.length - [folders objectAtIndex:i].name.length -1)];
                [startPathList addObject:startPath];
            }
            
        }
        for (int i = 0; i < startPathList.count; ++i)
            NSLog(@"Send2PCThread,初始路径%d --- %@",i,[startPathList objectAtIndex:i]);
    }
}
+ (NSMutableArray<MediaItem*>*)getrecentAudios{
    if(recentAudios ==nil){
        recentAudios = [[NSMutableArray alloc] init];
    }
    return recentAudios;
}
+ (NSMutableArray<MediaItem*>*)getrecentVideos{
    if(recentVideos ==nil){
        recentVideos = [[NSMutableArray alloc] init];
    }
    return recentVideos;
}
+ (NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>*) getaudioSets{
    if(audioSets ==nil){
        audioSets = [[NSMutableDictionary alloc] init];
    }
    return audioSets;
}
+ (NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>*) getimageSets{
    if(imageSets ==nil){
        imageSets = [[NSMutableDictionary alloc] init];
    }
    return imageSets;
}
+ (NSMutableArray<NSString*>*) getstartPathList{
    if(startPathList == nil){
        startPathList = [[NSMutableArray alloc] init];
    }
    return startPathList;
}
+ (NSMutableArray<MediaItem*>*) getmediaFiles{
    if(mediaFiles ==nil){
        mediaFiles = [[NSMutableArray alloc] init];
    }
    return mediaFiles;
}
+ (NSMutableArray<MediaItem*>*) getmediaFolders{
    if(mediaFolders ==nil){
        mediaFolders = [[NSMutableArray alloc] init];
    }
    return mediaFolders;
}
@end
