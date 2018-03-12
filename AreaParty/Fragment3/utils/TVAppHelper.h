//
//  TVAppHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandUtil.h"
#import "Send2TVThread.h"
#import "TVInforBean.h"
#import "AppItem.h"
#import "onHandler.h"
#import "OrderConst.h"
#import "GetTvListThread.h"
@interface TVAppHelper : NSObject
+ (void)currentPcInfo2TV;
+ (void) openApp:(NSString*) packgeName;
+ (void)setAppList:(NSString*)type list:(NSArray<AppItem*>*)appList;
+ (void) setMouseDevices:(NSArray<NSString*>*) list;
+ (void) setTvInfor:(TVInforBean*) infor;
+ (void) resetTotalInfors;
+ (void)loadApps:(id<onHandler>) handler;
+ (void)loadMouses:(id<onHandler>) handler;
+ (void)loadTVInfor:(id<onHandler>) handler;
+ (void) prepareForPCGame:(NSString*) pc_ip Mac: (NSString*) pc_mac;
+ (void) closeGameStream:(NSString*) pc_ip Mac: (NSString*) pc_mac;
+ (void) closeApp:(NSString*) packgeName ;
+ (void) uninstallApp:(NSString*) packgeName;
+ (void) openSettingPage;
+ (void) shutDownTV;
+ (void) rebootTV ;
+ (void) openTVRDP;
+ (void)openTVAccessibility;
+ (void)openTVMiracast;
+(NSMutableArray<AppItem*>*)getinstalledAppList;
+(NSMutableArray<AppItem*>*)getownAppList;
+ (TVInforBean*) gettvInfor;
+(NSMutableArray<NSString*>*)getmouseDevices;
@end
