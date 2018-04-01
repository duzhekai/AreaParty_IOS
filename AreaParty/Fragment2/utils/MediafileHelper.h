//
//  MediafileHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/18.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaItem.h"
#import "OrderConst.h"
#import "onHandler.h"
#import "Send2PCThread.h"
#import "ReceiveCommandFromTVPlayer.h"
@interface MediafileHelper : NSObject
+ (NSMutableArray<MediaItem*>*)getrecentAudios;
+ (NSMutableArray<MediaItem*>*)getrecentVideos;
+ (NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>*) getaudioSets;
+ (NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>*) getimageSets;
+ (NSMutableArray<NSString*>*) getstartPathList;
+ (NSMutableArray<MediaItem*>*) getmediaFiles;
+ (NSMutableArray<MediaItem*>*) getmediaFolders;
+ (void) setMediaSets:(NSMutableDictionary<NSString*,NSMutableArray<MediaItem*>*>*) tempSets typename:(NSString*) typeName;
+ (void) setRecentFiles:(NSArray<MediaItem*>*)tempFiles filetype:(NSString*)fileType;
+ (void) setMediaFiles:(NSArray<MediaItem*>*)tempMediaFiles folders:(NSArray<MediaItem*>*) folders;
+ (void)loadMediaSets:(id<onHandler>) handler;
+ (void) loadRecentMediaFiles:(id<onHandler>) handler;
+ (void) setMediaType:(NSString*) mediaType1;
+ (NSString*) getMediaType;
+ (BOOL) isPathContained:(NSString*) path  List:(NSMutableArray<NSString*>*) lists ;
+ (NSString*)getcurrentPath;
+ (void) setcurrentPath:(NSString*) path;
+ (void) loadMediaLibFiles:(id<onHandler>)handler;
+ (void) playMediaFile:(NSString*) filetype Path:(NSString*) path Filename:(NSString*) filename TVname:(NSString*) tvname  Handler:(id<onHandler>) myhandler;
+ (void) addRecentVideos:(MediaItem*) file;
+ (void) addRecentAudios:(MediaItem*) file;
+ (void) resetMediaInfors;
+ (void) addFilesToSet:(NSString*) setname List:(NSMutableArray<MediaItem*>*) mediaList handler:(id<onHandler>) myhandler;
+ (void) addFileToLocalSet:(NSString*) name List:(NSMutableArray<MediaItem*>*) fileList;
+ (void) addAudioPlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler;
+ (void) addImagePlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler;
+ (void) deleteAudioPlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler ;
+ (void) playMediaSet:(NSString*) setType setName:(NSString*)setName TVName:(NSString*)tvname Handler:(id<onHandler>) myhandler;
+ (void) vlcContinue;
+ (void) vlcPause;
+ (void) playAllMediaFile:(NSString*) filetype  Path:(NSString*) folderPath  TVName:(NSString*) tvname  Handler:(id<onHandler>) myhandler;
+ (void) deleteImagePlaySet:(NSString*) setname Handler:(id<onHandler>) myhandler;
+ (void) playMediaSetAsBGM:(NSString*) setType setName:(NSString*)setName TVName:(NSString*)tvname Handler:(id<onHandler>) myhandler ;
@end
