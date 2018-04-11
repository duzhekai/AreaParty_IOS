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
+ (void) setMediaType:(NSString*) mediaType1{
    mediaType = mediaType1;
}
+ (NSString*) getMediaType {
    return mediaType;
}
+ (BOOL) isPathContained:(NSString*) path  List:(NSMutableArray<NSString*>*) lists {
    if(lists.count == 0)
        return true;
    if([path isEqualToString:@""])
        return true;
    for(int i = 0; i < lists.count; ++i)
        if([path isEqualToString:lists[i]]) 
            return true;
    return false;
}
+ (NSString*)getcurrentPath{
    return currentPath;
}
+ (void) setcurrentPath:(NSString*) path{
    currentPath = path;
}
/**
 * <summary>
 *  启动线程从pc下载对应媒体库文件列表
 *  进入相应媒体库时调用
 * </summary>
 * <param name="handler">消息传递句柄</param>
 */
+ (void) loadMediaLibFiles:(id<onHandler>)handler{
    [mediaFiles removeAllObjects];
    [mediaFolders removeAllObjects];
    BOOL isRoot = true;
    if(startPathList.count != 0)
        isRoot =  [self isPathContained:currentPath List:startPathList];
    [[[Send2PCThread alloc] initWithtypeName:mediaType path:currentPath isRoot:isRoot Handler:handler] start];
}
/**
 * <summary>
 *  启动线程播放PC上指定的媒体文件到指定TV的
 * </summary>
 * <param name="filetype">媒体文件类别(AUDIO、VIDEO、IMAGE)</param>
 * <param name="filename">媒体文件名称</param>
 * <param name="path">媒体文件路径信息</param>
 * <param name="tvname">tv名称</param>
 * <param name="myhandler">消息传递句柄</param>
 */
+ (void) playMediaFile:(NSString*) filetype Path:(NSString*) path Filename:(NSString*) filename TVname:(NSString*) tvname  Handler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:path forKey:@"path"];
    [param setObject:filename forKey:@"filename"];
    [param setObject:tvname forKey:@"tvname"];
    [[[Send2PCThread alloc] initWithtypeName:filetype commandType:OrderConst_mediaAction_play_command Map:param Handler:myhandler] start];
//    if (!ReceiveCommandFromTVPlayer.getPlayerIsRun()){
//        new ReceiveCommandFromTVPlayer(true).start();
//    }
}
/**
 * <summary>
 *  播放视频成功后调用将当前视频文件添加到最近播放文件中
 *  <param name="file">当前播放着的音频</param>
 * </summary>
 */
+ (void) addRecentVideos:(MediaItem*) file{
    for(int i = 0; i < recentVideos.count; ++i) {
        if([recentVideos[i] equals:file]){
           [recentVideos removeObjectAtIndex:i--];
        }
    }
    [recentVideos insertObject:file atIndex:0];
}
/**
 * <summary>
 *  播放音频成功后调用将当前音频文件添加到最近播放文件中
 *  <param name="file">当前播放着的音频</param>
 * </summary>
 */
+ (void) addRecentAudios:(MediaItem*) file{
    for(int i = 0; i < recentAudios.count; ++i) {
        if([recentAudios[i] equals:file]){
            [recentAudios removeObjectAtIndex:i--];
        }
    }
    [recentAudios insertObject:file atIndex:0];
}
/**
 * <summary>
 *  过滤选中的文件列表
 *  启动线程将剩余的文件添加到指定列表
 *  在相应的媒体库调用
 * </summary>
 * <param name="setname">指定的要添加当前文件的播放列表</param>
 * <param name="mediaList">要添加的当前文件列表</param>
 * <param name="myhandler">消息传递句柄</param>
 */
+ (void) addFilesToSet:(NSString*) setname List:(NSMutableArray<MediaItem*>*) mediaList handler:(id<onHandler>) myhandler{
    if([mediaType isEqualToString:OrderConst_audioAction_name]) {
        NSMutableArray<MediaItem*>* currentSet = [audioSets objectForKey:setname];
        for(int i = 0; i < mediaList.count; ++i)
            for(int j = 0; j < currentSet.count; ++j)
                if(i>=0 && [mediaList[i] equals:currentSet[j]])
                   [mediaList removeObjectAtIndex:i--];
    } else if([mediaType isEqualToString:OrderConst_imageAction_name]) {
        NSMutableArray<MediaItem*>* currentSet = [imageSets objectForKey:setname];
        for(int i = 0; i < mediaList.count; ++i)
            for(int j = 0; j < currentSet.count; ++j)
                if(i>=0 && [mediaList[i] equals:currentSet[j]])
                    [mediaList removeObjectAtIndex:i--];
    }
    if(mediaList.count > 0) {
        NSString* liststr = [mediaList yy_modelToJSONString];
        NSLog(@"MediafileHelper liststr:%@",liststr);
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:setname forKey:@"setname"];
        [param setObject:liststr forKey:@"liststr"];
        [[[Send2PCThread alloc] initWithtypeName:mediaType commandType:OrderConst_mediaAction_addFilesToSet_command Map:param Handler:myhandler] start];
    }
    //else myhandler.sendEmptyMessage(OrderConst.addPCFilesToSet_OK);
}
+ (void) addFileToLocalSet:(NSString*) name List:(NSMutableArray<MediaItem*>*) fileList {
    NSMutableArray<MediaItem*>* currentSet;
    if([mediaType isEqualToString:OrderConst_audioAction_name]) {
        currentSet = [audioSets objectForKey:name];
    } else {
        currentSet = [imageSets objectForKey:name];
    }
    for (MediaItem* file in fileList){
        BOOL state = NO;
        for(int i = 0; i < currentSet.count; ++i)
            if([currentSet[i] equals:file])
                state = YES;
        if(!state)
           [currentSet addObject:file];
    }
}
/**
 * <summary>
 *  启动线程向PC上增加音频播放的集合
 *  在音频集合页面调用
 * </summary>
 * <param name="filename">媒体文件名称</param>
 */
+ (void) addAudioPlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:setname forKey:@"setname"];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_audioAction_name commandType:OrderConst_mediaAction_addSet_command Map:param Handler:myhandler]start];
}
/**
 * <summary>
 *  启动线程向PC上增加图片播放的集合
 *  在音频集合页面调用
 * </summary>
 * <param name="filename">媒体文件名称</param>
 */
+ (void) addImagePlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:setname forKey:@"setname"];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_imageAction_name commandType:OrderConst_mediaAction_addSet_command Map:param Handler:myhandler]start];
}
/**
 * <summary>
 *  启动线程向PC上删除音频播放的集合
 *  在音频集合页面调用
 * </summary>
 * <param name="filename">媒体文件名称</param>
 */
+ (void) deleteAudioPlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:setname forKey:@"setname"];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_audioAction_name commandType:OrderConst_mediaAction_deleteSet_command Map:param Handler:myhandler] start];
}
/**
 * <summary>
 *  启动线程播放PC上指定的媒体列表到指定TV
 * </summary>
 * <param name="filetype">媒体文件类别(AUDIO、IMAGE)</param>
 * <param name="filename">媒体文件名称</param>
 * <param name="path">媒体文件路径信息</param>
 * <param name="tvname">tv名称</param>
 * <param name="myhandler">消息传递句柄</param>
 */
+ (void) playMediaSet:(NSString*) setType setName:(NSString*)setName TVName:(NSString*)tvname Handler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:setName forKey:@"setname"];
    [param setObject:tvname forKey:@"tvname"];
    [[[Send2PCThread alloc] initWithtypeName:setType commandType:OrderConst_mediaAction_playSet_command Map:param Handler:myhandler] start];
}
+ (void) playMediaSetAsBGM:(NSString*) setType setName:(NSString*)setName TVName:(NSString*)tvname Handler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:setName forKey:@"setname"];
    [param setObject:tvname forKey:@"tvname"];
    [[[Send2PCThread alloc] initWithtypeName:setType commandType:OrderConst_mediaAction_playSet_command_BGM Map:param Handler:myhandler] start];
}
+ (void) vlcContinue {
    [[[Send2TVThread alloc] initWithCmd:[[CommandUtil createPlayVLCCommand] yy_modelToJSONString]] start];
}

+ (void) vlcPause {
    [[[Send2TVThread alloc] initWithCmd:[[CommandUtil createPlayPauseVLCCommand] yy_modelToJSONString]] start];
}
+ (void) playAllMediaFile:(NSString*) filetype  Path:(NSString*) folderPath  TVName:(NSString*) tvname  Handler:(id<onHandler>) myhandler{
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:folderPath forKey:@"folder"];
    [param setObject:tvname forKey:@"tvname"];
    [param setObject:[NSString stringWithFormat:@"%d",5] forKey:@"t"];
    [[[Send2PCThread alloc] initWithtypeName:filetype commandType:OrderConst_mediaAction_playALL_command Map:param Handler:myhandler] start];
    if (![ReceiveCommandFromTVPlayer getplayerIsRun]){
        [[[ReceiveCommandFromTVPlayer alloc]initWithIsRun:YES]start];
    }
}
/**
 * <summary>
 *  启动线程向PC上删除图片播放的集合
 *  在图片集合页面调用
 * </summary>
 * <param name="filename">媒体文件名称</param>
 */
+ (void) deleteImagePlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler{
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:setname forKey:@"setname"];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_imageAction_name commandType:OrderConst_mediaAction_deleteSet_command Map:param Handler:myhandler] start];
}
@end
