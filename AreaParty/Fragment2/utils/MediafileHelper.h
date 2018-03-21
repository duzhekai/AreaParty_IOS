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
@end
