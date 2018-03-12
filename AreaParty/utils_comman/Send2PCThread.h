//
//  Send2PCThread.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/16.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
/**
 * Created by borispaul on 2017/6/23.
 * 获取PC的应用、媒体文件列表的线程
 */
#import <Foundation/Foundation.h>
#import "onHandler.h"
#import "OrderConst.h"
#import "CommandUtil.h"
#import "PCAppHelper.h"
#import "PCInforBean.h"
#import "MediaItem.h"
#import "MediafileHelper.h"
@interface Send2PCThread : NSThread{
    NSString* typeName;  // "SYS, APP, GAME, VIDEO, AUDIO, IMAGE"
    NSString* commandType; // GETINFOR, GETTOTALLIST, GETRECENTLIST, GETSETS, OPEN_MIRACST, OPEN_RDP, PLAY, OPEN, ADDSET, ADDFILESTOSET
    NSMutableDictionary* param;
    NSString* path;  // 当类型是媒体库时, 该字段才有效
    BOOL isRoot; // 当类型是媒体库时, 该字段才有效
    id<onHandler> myhandler;
}
- (instancetype)initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1  Handler:(id<onHandler>) myhandler1;
- (instancetype)initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1 Map:(NSMutableDictionary*)param1 Handler:(id<onHandler>) myhandler1;
- (instancetype)initWithtypeName:(NSString*)typeName1 path:(NSString*)path1 isRoot:(BOOL)isRoot1 Handler:(id<onHandler>) myhandler1;
- (instancetype)initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1 path:(NSString*)path1 Handler:(id<onHandler>) myhandler1;
@end
